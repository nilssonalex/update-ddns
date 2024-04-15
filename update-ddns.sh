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
	echo "Uppdaterar IP..."
	echo " "
	echo "lastip.txt:"
	cat ${scriptpath}/lastip.txt
	echo " "
	echo "Anropar Njalla..."
	curl --retry 5 -s "https://njal.la/update/?h=${njalladomain}&k=${njallakey}&auto&quiet"
	echo "Njalla är uppdaterat."
	echo " "
	echo "Sparar aktuell IP-adress..."
	curl --retry 5 -s https://ipinfo.io/ip -o ${scriptpath}/lastip.txt
	echo "Aktuell IP-adress sparad"
	echo " "
	echo "lastip.txt:"
	cat ${scriptpath}/lastip.txt
	echo " "
	echo "IP uppdaterad."
	echo " "
	curl \
    -d "Ny IP-adress: ${current_IP}" \
    -H "Title: Ny IP för ${hostname}" \
    -H "Priority: high" \
    https://ntfy.sh/${ntfytopic}
}

if [ "$last_IP" = "$current_IP" ]; then
	echo " "
	echo "Ett litet script för att uppdatera DNS!"
	echo "Aktuell IP är	${current_IP}"
	echo "Lagrad IP är	${last_IP}"
	echo "IP har inte ändrats sedan sist."
	echo "Avslutar script."
	echo " "
	
else
	echo " "
	echo "Ett litet script för att uppdatera DNS!"
	echo "IP har ändrat sedan sist!"
	echo "Lagrad IP är 	${last_IP}"
	echo "Aktuell IP är 	${current_IP}"
	echo " "
	update_ip
fi
