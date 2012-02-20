#!/usr/bin/env bash
####
# Copyright (c) 2012 Tim Heckman <timothy.heckman@gmail.com> and contributors
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this
# software and associated documentation files (the "Software"), to deal in the Software
# without restriction, including without limitation the rights to use, copy, modify, 
# merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to the following 
# conditions:
#
# The above copyright notice and this permission notice shall be included in all copies 
# or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
# PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
# CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
# OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
# **** IMPORTANT PLEASE READ THE FOLLOWING SECTION ****
# This script is not written by, nor maintained by, Linode.  Nor is it affiliated 
# with Linode directly in any way.  Do not contact Linode to report any issues or 
# file any bug reports regarding this script.
# **** IMPORTANT PLEASE READ THE PREVIOUS SECTION ****
####

MX_RECORDS=(
	"ASPMX.L.GOOGLE.COM"
	"ALT1.ASPMX.L.GOOGLE.COM"
	"ALT2.ASPMX.L.GOOGLE.COM"
	"ASPMX2.GOOGLEMAIL.COM"
	"ASPMX3.GOOGLEMAIL.COM"
)
MX_PRIORITY=(
	"10"
	"20"
	"20"
	"30"
	"30"
)
GAPPS_SPF="v=spf1%20include:_spf.google.com%20~all"

ARRLEN=`expr ${#MX_RECORDS[@]} - 1`

if hash curl 2>&-; then
    CMD="curl -s"
else
    if hash wget 2>&-; then
        CMD="wget -qO-"
    else
        echo "Sorry, this script requires you to have curl or wget to continue!"
        exit 1
    fi
fi

/bin/cat <<EOF
####################
#  Google Apps MX  #
# Records Creation #
#      Script      #
####################

EOF

if [ -z "${LINODE_API_KEY}" ]; then
	echo -n "Enter API key: "
	read API_KEY
	echo
else
	API_KEY="${LINODE_API_KEY}"
fi

if [ -z "${GDOMAIN}" ]; then
	echo -n "Enter your master domain name: "
	read DOMAIN
	echo
else
	DOMAIN="${GDOMAIN}"
	echo "Adding entries for ${DOMAIN}"
fi

API_URL="https://api.linode.com/?api_key=${API_KEY}\
&api_responseformat=json\
&api_action=domain.list"
DOMAIN_ID=`$CMD "${API_URL}" | sed -E 's/.*"DOMAINID":([0-9]+),.*"DOMAIN":"'"${DOMAIN}"'".*/\1/'`

if [ `echo -n "${DOMAIN_ID}" |  sed -E 's/[0-9]+/1/'` != "1" ]; then 
	echo "Domain not found"
	exit
fi

echo -n "Would you like to add the recommended default SPF record for Google Apps [y/N]: "
read ADD_SPF
echo

echo "You can also add CNAMEs to make navigating to the Google Apps web interface easier."
echo -n "Would you like to add some Google Apps CNAMEs [y/N]: "
read ADD_CNAME
echo

if [ "$ADD_CNAME" == "y" -o "$ADD_CNAME" == "Y" ]; then
	CNAME_LIST=(
		"mail"
		"calendar"
		"contacts"
		"docs"
	)
	CNAME_LEN=$((${#CNAME_LIST[*]} - 1))
	CNAME_ADD=()
	for ((i=0; i <= CNAME_LEN; i++ ))
	do
		echo -n "Would you like to add a CNAME for ${CNAME_LIST[i]}.${DOMAIN} [y/N]: "
		read DO_CNAME
		echo
		CNAME_ADD[$i]=${DO_CNAME}
	done
fi

echo "Creating MX records..."
echo
for ((i=0; i <= ARRLEN; i++))
do
	API_URL="https://api.linode.com/\
?api_key=${API_KEY}\
&api_action=domain.resource.create\
&domainid=${DOMAIN_ID}\
&type=MX\
&target=${MX_RECORDS[i]}\
&priority=${MX_PRIORITY[i]}"
		echo "${MX_RECORDS[i]}:"
		$CMD "${API_URL}"
		echo
done

if [ "$ADD_SPF" == "y" -o "$ADD_SPF" == "Y" ]; then
	echo
	echo "Creating SPF record..."
	echo
	API_URL="https://api.linode.com/\
?api_key=${API_KEY}\
&api_action=domain.resource.create\
&domainid=${DOMAIN_ID}\
&type=TXT\
&target=${GAPPS_SPF}"
	$CMD "${API_URL}"
	echo
fi

if [ "$ADD_CNAME" == "y" -o "$ADD_CNAME" == "Y" ]; then
	echo
	echo "Creating CNAMEs..."
	echo
	for ((i=0; i <= CNAME_LEN; i++ ))
	do
		if [ "${CNAME_ADD[i]}" == "y" -o "${CNAME_ADD[i]}" == "Y" ]; then
			API_URL="https://api.linode.com/\
?api_key=${API_KEY}\
&api_action=domain.resource.create\
&domainid=${DOMAIN_ID}\
&type=CNAME\
&name=${CNAME_LIST[i]}\
&target=ghs.google.com"
			echo "${CNAME_LIST[i]}:"
			$CMD "${API_URL}"
			echo
		fi
	done
	echo
	echo "You'll need to update the URLs for your Google Apps Core Services to the CNAMEs"
	echo "that you just created: https://www.google.com/a/${DOMAIN}"
	echo
fi

echo "Everything should be finished at this point (assuming no errors were returned via API)!"
echo "Please verify the created records within the Linode DNS Manager:"
echo "https://manager.linode.com/dns/domain/${DOMAIN}"
echo "<3 heckman"
exit 0
