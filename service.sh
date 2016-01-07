#! /bin/bash

#Debug
#set -x

regexp_helo="^HELO\s(.*)"
regexp_mail_from="^MAIL FROM:\s?<?([a-z0-9._%+-]+@[a-z0-9.-]+(\.[a-z]{2,4})?)>?"
regexp_rcpt_to="^RCPT TO:\s?<?([a-z0-9._%+-]+@[a-z0-9.-]+(\.[a-z]{2,4})?)>?"

#On test que le serveur est bien lance
PARENT_PROCESS=$(ps h -o comm $(ps hoppid $PPID))
if [[ $PARENT_PROCESS != 'server.sh' ]]; then
	echo "Launch server.sh first could be better..."
	exit 0;
fi

#AUTHENTIFICATION
#Si pas de -pass et login_pass.txt en arguments
#l'utilisateur est directement sorti
#connected=0
connected=1
not_used()
{
if [[ ${1} == "-pass" && ${2} == "login_pass.txt" ]]; then
    #On verifie que le fichier login_pass existe bien si oui login
    if [[ -f $2 ]]; then
        unset login
        unset pwd
        #On lui demande de se connecter
        echo "User :"
        read login
        echo "Password :"
        #-s pour pas voir ce que l'on tape mais ne semble fonctionner
        #seulement sur terminal
        #read -s pwd
        #du coup on affiche des *
        #ne fonctionne pas non plus...
				#while IFS= read -p "$prompt" -r -s -n 1 char
				#do
				#	if [[ $char == $'\0' ]]; then
				#		break
				#  fi
				#  prompt='*'
				#  password+="$char"
				#done
				read pwd
        #on va utiliser les donnees du fichiers
        #mises en forme pour avoir directement deux variables que l'on test
        source ${2};
        if [[ $login == $user && $pwd == $pass ]]; then
            connected=1
            echo "Connection etablished"
            echo
        else
            echo "Connection failed"
            exit 0
        fi
    else
      echo "File login_pass.txt not found"
      exit 0
    fi
else
  echo "Syntax : ./service.sh -pass login_pass.txt"
  exit 0
fi
}

#On cree un nouvel email au nom aleatoire
rand=$RANDOM
tempFile='.temp_mail'
file=$rand$tempFile
touch $file

#QUIT
quit='QUIT'
closeServer()
{
    #Si on a pas fini de rentrer les data on supprime le mail
    if [[ $dataTrue != 1 ]]; then
      echo "Connection closed by foreign host."
      rm $file
    #sinon on le déplace dans le dossier correspondant a celui cense recevoir le mail
  	else
	    echo "221  Bye"
	    echo  >> $file
	    echo R: 221 2.0.0 Bye >> $file
	    #On verifie si le fichier n'existe pas deja sinon on renomme
	    fileAlReadyExist "$folder" "$rand"
    fi
    #On efface les mails non envoyes
    find . -maxdepth 1 -type f -name "*.temp_mail" -delete
    exit 0
}

#On verifie si le fichier n'existe pas deja, si c'est le cas -> renommage
fileAlReadyExist()
{
    search=`find $1 -name $2`
    if [[ $search != '' ]]; then
      tmpName=$RANDOM
      #On evite que le nouveau nom soit lui aussi deja utilise
      while [[ $tmpName == $rand ]];
      do
      	tmpName=$RANDOM
      done
    	mv $file $tmpName
    	mv $tmpName $folder
    else
    	mv $file $rand
			mv $rand $folder
    fi
}

#Initialisation
echo "220 $(hostname -f) Service ready"
echo R: 220 $(hostname -f) Service ready >> $file

#HELP
helpS='HELP'
helpFonc()
{
    #On affiche l'usage des fonctions disponible ainsi que leurs fonctions
    echo "-----"
    echo "HELO <everything you want>"
    echo "MAIL FROM: <addresse@domaine.xx>"
    echo "RCPT TO: <addresse@domaine.xx>"
    echo "DATA"
    echo "NOOP"
}

#RSET
rset='RSET'
reset()
{
		#Effacer le mail actuel puis recommencer, helo aussi ?
		echo "250 2.0.0 Ok"
}

#VRFY
addressExist=0
vrfy()
{
    folder=`find -maxdepth 1 -type d -name $1`
  if [[ $folder != '' ]]; then
    addressExist=1
    echo  >> $file
    echo S: VRFY $1 >> $file
    echo "R: 250 <$1>" >> $file
  fi
}

#NOOP
noop='NOOP'
noop()
{
    #Pour faire la commande nous sommes obligatoirement connectés donc on renvoi OK
    echo "250 2.0.0 Ok"
}

#HELO
heloTrue=0
while [ $connected == 1 ] && [ $heloTrue != 1 ]
do
    read helo
    helo_debug=$helo
    if [[ "$helo" =~ "$quit" ]]; then
        closeServer
    elif [[ "$helo" =~ "$helpS" ]]; then
        helpFonc
    elif [[ "$helo" =~ "$rset" ]]; then
        reset
    elif [[ "$helo" =~ "$noop" ]]; then
        noop
    #Sinon si l'utilisateur a rentre HELO avec une info viable
    #on stock tout et continu
    elif [[ "$helo" =~ $regexp_helo ]]; then
        heloTrue=1
        echo "250 $(hostname -f)"
        echo S: $helo >> $file
        echo R: 250 $(hostname -f) >> $file
    else
        echo "502 5.5.2 Error: command not recognized"
    fi
done

#MAIL FROM
mailFTrue=0
while [ $connected == 1 ] && [ $connected == 1 ] && [ $heloTrue == 1 ] && [ $mailFTrue != 1 ]
do
    read mailF
    mailF_debug=$mailF

    if [[ "$mailF" =~ "$quit" ]]; then
        closeServer
    elif [[ "$mailF" =~ "$helpS" ]]; then
        helpFonc
    elif [[ "$mailF" =~ "$rset" ]]; then
        reset
    elif [[ "$mailF" =~ "$noop" ]]; then
        noop
    #Sinon si l'utilisateur a rentre MAIL FROM avec une adresse viable
    #on stock tout et continu
    elif [[ "$mailF" =~ $regexp_mail_from ]]; then
        mailFTrue=1
        address=${BASH_REMATCH[1]}
        echo "250 2.1.0 Ok"
        echo  >> $file
        echo "S: MAIL FROM: <$address>" >> $file
        echo R: 250 OK >> $file
    else
        echo "501 5.1.7 Bad sender address syntax"
    fi
done

#RCPT TO
rcptTTrue=0
while [ $connected == 1 ] && [ $heloTrue == 1 ] && [ $mailFTrue == 1 ] && [ $rcptTTrue != 1 ]
do
    read rcptT
    rcpT_debug=$rcptT

    if [[ "$rcptT" =~ "$quit" ]]; then
        closeServer
    elif [[ "$rcptT" =~ "$helpS" ]]; then
        helpFonc
    elif [[ "$rcptT" =~ "$rset" ]]; then
        reset
    elif [[ "$rcptT" =~ "$noop" ]]; then
        noop
    #Sinon si l'utilisateur a rentre RCPT avec une info viable
    #on verifie que l'adresse existe bien
    #on stock alors tout et continu
    elif [[ "$rcptT" =~ $regexp_rcpt_to ]]; then
        address=${BASH_REMATCH[1]}
        vrfy "$address"
        if [[ $addressExist == 1 ]]; then
            rcptTTrue=1
            echo "250 2.1.0 Ok"
            echo  >> $file
            echo "S: RCPT TO: <$address>" >> $file
            echo "R: 250 OK" >> $file
        else
            echo "554 5.7.1 <$address>: Relay access denied"
            echo  >> $file
 						echo "S: RCPT TO: <$address>" >> $file
            echo R: 550 No such user here >> $file
        fi
    else
        echo "501 5.1.3 Bad recipient address syntax"
    fi
done

#DATA
dataTrue=0
point=0
doublePoint='..'
while [ $connected == 1 ] && [ $heloTrue == 1 ] && [ $mailFTrue == 1 ] && [ $rcptTTrue == 1 ] && [ dataTrue != 1 ]
do
    read data
    if [[ "$data" =~ "$quit" ]]; then
        closeServer
    elif [[ "$data" =~ "$helpS" ]]; then
        helpFonc
    elif [[ "$data" =~ "$rset" ]]; then
        reset
    elif [[ "$data" =~ "$noop" ]]; then
        noop
    elif [[ "$data" =~ ^(DATA) ]]; then
        echo "354 End data with <CR><LF>.<CR><LF>"
        echo  >> $file
        echo S: DATA >> $file
        echo "R: 354 Start mail input; end with <CRLF>.<CRLF>" >> $file
        while [ $point == 0 ]
        do
            read message
            #ligne avec deux points = .
            #point au milieu d'une phrase marche
            #si juste un point fin du DATA
            if [[ "$message" =~ "$doublePoint" ]]; then
                #reprendre message et le couper
                message=$(sed -e 's/\../\./g' <<< $message)
                echo S: $message >> $file
            else
                if [[ "$message" == $'.\r' ]]; then
                    echo "S: <CRLF>.<CRLF>" >> $file
                    point=1
                    break
                else
                    echo S: $message >> $file
                fi
            fi
        done
        echo "250 2.0.0 Ok: queued as $rand"
        echo R: 250 OK >> $file
        dataTrue=1
    else
        echo "500 Syntax error, command unrecognised"
    fi
done