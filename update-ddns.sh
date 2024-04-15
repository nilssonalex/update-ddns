#!/usr/bin/env bash
source config.sh

get_current_ip() {
	curl --retry 5 -s https://ipinfo.io/ip
}
current_IP=$(get_current_ip)

get_last_ip() {
	cat ${scriptpath}/lastip.txt
}
last_IP=$(get_last_ip)

update_ip() {
	echo "Updating IP..."
	echo " "
	echo "lastip.txt:"
	cat ${scriptpath}/lastip.txt
	echo " "
	echo "Updating Njalla..."
	curl --retry 5 -s "https://njal.la/update/?h=${njalladomain}&k=${njallakey}&auto&quiet"
	echo "Njalla is updated."
	echo " "
	echo "Saving IP address..."
	curl --retry 5 -s https://ipinfo.io/ip -o ${scriptpath}/lastip.txt
	echo "IP address saved to file"
	echo " "
	echo "lastip.txt:"
	cat ${scriptpath}/lastip.txt
	echo " "
	curl \
    -d "New IP: ${current_IP}" \
    -H "Title: New IP for ${hostname}" \
    -H "Priority: high" \
    https://ntfy.sh/${ntfytopic}
}

if [ "$last_IP" = "$current_IP" ]; then
	echo " "
	echo "Current IP is	${current_IP}"
	echo "Saved IP is	${last_IP}"
	echo "IP has not changed."
	echo " "
	
else
	echo " "
	echo "Current IP is	${current_IP}"
	echo "Saved IP is	${last_IP}"
	echo "IP has changed."
	echo " "
	update_ip
fi
