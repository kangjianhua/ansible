#!/bin/bash
for ip in $(cat ./list.txt);do echo ---$ip---;ping -i 0.1 -c3 $ip |grep loss;done
