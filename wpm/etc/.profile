if [[  -f /etc/.env  ]]; then
for var in $(cat /etc/.env); do 
	export $var
done
fi
