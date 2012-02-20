#!/usr/bin/env bash
####
# Copyright (c) 2012 Tim Heckman <timothy.heckman@gmail.com>
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

echo -n "Would you like to add a default SPF record for Google Apps [y/N]: "
read ADD_SPF
echo

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

echo
echo "Should be finished at this point (assuming no errors were generated from API calls)!"
echo "Please verify the created records within the Linode DNS Manager."
echo "<3 heckman"
exit 0
