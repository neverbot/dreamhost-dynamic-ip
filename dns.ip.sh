#!/bin/bash

# get a dreamhost api key from https://panel.dreamhost.com/?tree=home.api
# it must be of the type dns-* (All dns functions)

# change DREAMHOST_API_KEY, PATH_TO_A_WRITABLE_FILE and PATH_TO_THE_PHP_SCRIPT
# to their proper values and have fun

KEY="DREAMHOST_API_KEY"
FILENAME_IP='/PATH_TO_A_WRITABLE_FILE/last_ip.txt'
URL_GET_IP="http://127.0.0.1/PATH_TO_THE_PHP_SCRIPT/whatismyip.php"

DOMAINS=('mydomain.com' \
'blog.mydomain.com' \
'www.mydomain.com')

function log() { echo "$@" 1>&2; }
function error() { echo "$@" 1>&2; }
function fail() { [ $# -eq 0 ] || error "$@"; exit 1; }

# Get the last global ip, stored in our file
function get_last_ip(){ 
	echo `cat $FILENAME_IP`
}

# get the current ip from a remote service
function get_current_ip(){ 
	echo `curl $URL_GET_IP 2>/dev/null`
}

function get_dh_stored_ip(){
  log "Getting dreamhost stored ip for: $1"
	echo `curl "https://api.dreamhost.com/?key=$KEY&cmd=dns-list_records" --ciphers RSA 2>/dev/null | grep -E "(\s+)$1(\s+)A" | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}'`	
}

function add_dh_record(){
  log "Adding dreamhost record $1 to $2"
  echo `curl "https://api.dreamhost.com/?key=$KEY&cmd=dns-add_record&record=$2&type=A&value=$1" --ciphers RSA 2>/dev/null`
}

function remove_dh_record(){
  log "Deleting dreamhost record $1 to $2"
  echo `curl "https://api.dreamhost.com/?key=$KEY&cmd=dns-remove_record&record=$2&type=A&value=$1" --ciphers RSA 2>/dev/null`	
}

function change_ip(){
	add_dh_record $current_ip $1
	remove_dh_record $dh_ip $1
	echo "$current_ip" > $FILENAME_IP
}

last_ip=$(get_last_ip)
log 'Last ip used:' $last_ip

current_ip=$(get_current_ip)
log 'Current system ip:' $current_ip

if [ -z $current_ip ]; then
	log 'External ip service not working?'
	exit 1
fi

for i in ${DOMAINS[@]}; do

	dh_ip=''

	log '------------------------------------------------------------'

	dh_ip=$(get_dh_stored_ip ${i})
	log "Dreamhost ip for ${i}:" $dh_ip

	if [ -z $dh_ip ]; then
		log "Dreamhost has no info stored for ${i}"
		continue
	fi

	if [ "$current_ip" == "$dh_ip" ]; then
	  log 'Same ip, do nothing'
	  continue
	else
	  change_ip ${i}
	fi

done








