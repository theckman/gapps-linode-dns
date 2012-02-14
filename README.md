#Google Apps Linode DNS Script
**Please note:** While this script was written by a Linode employee, it is not a Linode product nor is it maintained by Linode. Linode should not be contacted for support using this script or to report any bugs with the script.

**License:** This script is released under the [MIT license](http://www.opensource.org/licenses/mit-license.php).

This script aids in the creation of the MX records needed for Google Apps.  You can optionally add the recommended default SPF record as well.  This script uses the [Linode](http://www.linode.com/?r=78a747e2c08ffb6618e260c3c62f536687b9159c) [API](http://www.linode.com/api) to create the records.  So be sure to have your API key handy.

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

	Would you like to add a default SPF record for Google Apps [y/n]: y

	Creating MX records...

	{"ERRORARRAY":[],"DATA":{"ResourceID":[redacted]},"ACTION":"domain.resource.create"}
	{"ERRORARRAY":[],"DATA":{"ResourceID":[redacted]},"ACTION":"domain.resource.create"}
	{"ERRORARRAY":[],"DATA":{"ResourceID":[redacted]},"ACTION":"domain.resource.create"}
	{"ERRORARRAY":[],"DATA":{"ResourceID":[redacted]},"ACTION":"domain.resource.create"}
	{"ERRORARRAY":[],"DATA":{"ResourceID":[redacted]},"ACTION":"domain.resource.create"}

	Creating SPF record...

	{"ERRORARRAY":[],"DATA":{"ResourceID":[redacted]},"ACTION":"domain.resource.create"}

	Should be finished at this point (assuming no errors were generated from API calls)!
	Please verify the created records within the Linode DNS Manager.
	<3 heckman