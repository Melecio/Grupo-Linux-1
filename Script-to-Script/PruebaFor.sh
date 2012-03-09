#! /bin/bash
    
for j in $(seq 2 20)
do 
    ssh-copy-id -i ~/.ssh/id_rsa.pub root@et$j.ac.labf.usb.ve 
done 
