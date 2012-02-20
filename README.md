#Google Apps Linode DNS Script
**Please note:** While this script was written by a Linode employee, it is not a Linode product nor is it maintained by Linode. Linode should not be contacted for support using this script or to report any bugs with the script.

**License:** This script is released under the [MIT license](http://www.opensource.org/licenses/mit-license.php).

This script aids in the creation of the MX records needed for Google Apps.  You can optionally add the recommended default SPF record as well as some of the more common Google Apps CNAMEs for the core services.  This script uses the [Linode](http://www.linode.com/?r=78a747e2c08ffb6618e260c3c62f536687b9159c) [API](http://www.linode.com/api) to create the records.  So be sure to have your API key handy.

**Note:** Your API key can be obtained from the "[My Profile](https://manager.linode.com/profile/index)" link at the top right of the Linode Manager

#Special Thanks

This script has become more of a Linode community project than I had originally anticipated. I must give some thanks to the following Linode community members for taking their time to add features to this script. Their additions have improved the usability of the script overall. They've made it more of a convenience than I could have accomplished alone:

* [Scott "pwae/praetorian" Sinclair](https://github.com/pwae)
* [Michael "chesty" Chesterton](https://github.com/chesty)
* [Douglas "dwfreed" Freed](https://github.com/dwfreed)


#Using The Script

First you'll need to download the script so that you can run it:

    wget "https://raw.github.com/theckman/gapps-linode-dns/master/gapps-linode-dns.sh"

or

    curl -O "https://raw.github.com/theckman/gapps-linode-dns/master/gapps-linode-dns.sh"

Make the script executable:

    chmod +x gapps-linode-dns.sh

Then run the script:

    theckman@tron:~# ./gapps-linode-dns.sh
	####################
	#  Google Apps MX  #
	# Records Creation #
	#      Script      #
	####################

	Enter API key: [redacted]

	Enter your master domain name: timheckman.net

	Would you like to add the recommended default SPF record for Google Apps [y/N]: y

	You can also add CNAMEs to make navigating to the Google Apps web interface easier.
	Would you like to add some Google Apps CNAMEs [y/N]: y

	Would you like to add a CNAME for mail.timheckman.net [y/N]: y

	Would you like to add a CNAME for calendar.timheckman.net [y/N]: y

	Would you like to add a CNAME for contacts.timheckman.net [y/N]: y

	Would you like to add a CNAME for docs.timheckman.net [y/N]: y

	Creating MX records...

	ASPMX.L.GOOGLE.COM:
	{"ERRORARRAY":[],"DATA":{"ResourceID":[redacted]},"ACTION":"domain.resource.create"}
	ALT1.ASPMX.L.GOOGLE.COM:
	{"ERRORARRAY":[],"DATA":{"ResourceID":[redacted]},"ACTION":"domain.resource.create"}
	ALT2.ASPMX.L.GOOGLE.COM:
	{"ERRORARRAY":[],"DATA":{"ResourceID":[redacted]},"ACTION":"domain.resource.create"}
	ASPMX2.GOOGLEMAIL.COM:
	{"ERRORARRAY":[],"DATA":{"ResourceID":[redacted]},"ACTION":"domain.resource.create"}
	ASPMX3.GOOGLEMAIL.COM:
	{"ERRORARRAY":[],"DATA":{"ResourceID":[redacted]},"ACTION":"domain.resource.create"}

	Creating SPF record...

	{"ERRORARRAY":[],"DATA":{"ResourceID":[redacted]},"ACTION":"domain.resource.create"}

	Creating CNAMEs...

	mail:
	{"ERRORARRAY":[],"DATA":{"ResourceID":[redacted]},"ACTION":"domain.resource.create"}
	calendar:
	{"ERRORARRAY":[],"DATA":{"ResourceID":[redacted]},"ACTION":"domain.resource.create"}
	contacts:
	{"ERRORARRAY":[],"DATA":{"ResourceID":[redacted]},"ACTION":"domain.resource.create"}
	docs:
	{"ERRORARRAY":[],"DATA":{"ResourceID":[redacted]},"ACTION":"domain.resource.create"}

	You'll need to update the URLs for your Google Apps Core Services to the CNAMEs
	that you just created: https://www.google.com/a/timheckman.net

	Everything should be finished at this point (assuming no errors were returned via API)!
	Please verify the created records within the Linode DNS Manager:
	https://manager.linode.com/dns/domain/timheckman.net
	<3 heckman

#License
Copyright (c) 2012 Tim Heckman and contributors

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
