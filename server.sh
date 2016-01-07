#! /bin/bash

#On ferme le service mais le serveur reste opérationnel
while true
do
nc.traditional -l -p 4569 -c "./service.sh -pass login_pass.txt"
done

#chmod 755 server.sh
#+x
#chmod 644 lofin_pass.txt
#nc localhost 4567