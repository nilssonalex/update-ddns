# update-ddns

A tiny script to update a Njalla dynamic domain and notify via ntfy when done

## config.sh: 
Create a config file
```
#!/usr/bin/env bash
hostname="hostname"
scriptpath="/path/to/script"
njalladomain="domain.to.update"
njallakey="njallakey"
ntfytopic="ntfytopic"
```

## cronjob
Run as cronjob with path
```
PATH=/bin:/usr/bin:/path/to/script
* * * * * /path/to/script/update-ddns.sh > /dev/null 2>&1
```