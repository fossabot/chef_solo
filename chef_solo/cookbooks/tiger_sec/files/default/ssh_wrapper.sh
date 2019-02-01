#!/bin/sh 
exec /usr/bin/ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i "/home/tiger/.ssh/id_rsa" "$@"