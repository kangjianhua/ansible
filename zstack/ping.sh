#!/bin/bash
for ip in $(cat /workspace/ansible/zstack/list.txt);do echo ---$ip---;ping -i 0.1 -c3 $ip |grep loss;done
