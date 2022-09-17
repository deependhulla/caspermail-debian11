#!/bin/bash

## if process running kill it
killall -9 balance 1>/dev/null 2>/dev/null 

## for Same server use 25-> 18025, 465 -> 18465 , 587 -> 18587

/usr/sbin/balance 3325 110.168.10.20:18025 110.168.10.21:25 110.168.10.22:25
/usr/sbin/balance 3465 110.168.10.20:18465 110.168.10.21:465 110.168.10.22:465
/usr/sbin/balance 3587 110.168.10.20:18587 110.168.10.21:587 110.168.10.22:587

echo "Load Balance Started"
ps a |  grep balance | grep -v grep | grep -v load


