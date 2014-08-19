dreamhost-dynamic-ip
====================

Shell script to run in a local server with dynamic ip, to update the 
dreamhost dns info when our ip has changed.

### Three files here:

* `dns.ip.sh`: The shell script which should be run in the local server. 
  Give it execution permissions and include it in the crontab file:
  `
  $ sudo crontab -e
  `
  And add a line like:
  `
  */30    *      *     *    *    /path/to/the/script/dns.ip.sh
  `
  Note dreamhost has a limit in its api, so if you call the api more
  than a certain number of times, the next will be ignored until its 
  counter resets.
  
* `whatismyip.php`: a little php file which checks dyndns.com and gives you
  your ip. Put it somewhere reachable by your web server 
  (maybe `/var/www/something/whatismyip.php`) and test it with a browser. 
  It should show just an ip. Executing
  `$ php whatismyip.php` 
  you should see the same result.
  
* `last_ip.txt`: not really needed, here the last ip used is stored. 
  For future use.

### Installation/configuration:

Edit the first lines in `dns.ip.sh` with the paths used to store these files
and include the **Dreamhost API key**. You can get one from 
https://panel.dreamhost.com/?tree=home.api
and it must be of the type `dns-*` (All dns functions).

Edit the domain names you want to be updated. They must exist first in the 
dreamhost panel, of course. Go to 
https://panel.dreamhost.com/index.cgi?tree=domain.manage
, select the domain managed by dreamhost which you want to use and click in 
its "DNS" link under the domain name. You could add new ones in the 
"_Add a custom DNS record to_" section (must be of _Type A_), or even use/update
the main one, so it's not mandatory to have anything stored/hosted in dreamhost.


Hope it helps somebody. To test some kind of local server it was useful for me, 
and to test some services not allowed by the dreamhost hosting which you
can use in your own local server.
