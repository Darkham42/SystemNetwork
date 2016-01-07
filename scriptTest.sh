#! /bin/bash

#echo -n "Enter your name and press [ENTER]: " 
#read chaine1
#echo "Your name is: $chaine1"
#chaine2='Thomas'
#echo "On recherche Thomas"
#if [[ "$chaine2" =~ "$chaine1" ]]; then
#
#      echo "c'est bon !"
#
#fi
#read helo
#d=($(IFS="." ; echo $helo))
#hostnametapeByUser=${d}
#echo $hostnametapeByUser



#chaine="bonjour au revoir..demain..hier..lundi mardi mercredi"
#chaine=$(sed -e 's/\../\./g' <<< $chaine)
#echo "$chaine"



#if [[ "$hostnametapeByUser" =~ "$hostname" ]]; then
     #echo "c'est bon !"
 #else
 	#echo "pas bon"
#fi



#echo "1"
#read message
#fighter="$fighter$message"
#echo $fighter
#echo "2"
#read message
#fighter="$fighter$message"
#echo $fighter
#echo "3"
#read message
#fighter="$fighter$message"
#echo $fighter

#taille5="12345"
#taille3="1234"
#taille1="0"

#if [[ ${#taille5} == 5 ]]; then
#	echo "ok"
#else
#	echo "pas ok"
#fi

#helo='RCPT TO: dad@ad.da'
#d=($(IFS=": " ; echo $helo))
#testa=${d[2]}
#echo "$testa"


#h='test@tpmail.info.unicaen.fr'

#maFonction() 
#{
#  folder=`find -maxdepth 1 -type d -name $1| head -n1`
#  if [[ $folder != '' ]]; then
#    echo "exist"
#  else
#    echo "introuvable"
#  fi
#}

# appel de ma fonction
#maFonction "$h"

#folder='test@tpmail.info.unicaen.fr'
#file='asa'

#maFonction() 
#{
#  search=`find $1 -name $2`
#  if [[ $search != '' ]]; then
#    echo "exist"
#  else
#    echo "introuvable"
#  fi
#}

#maFonction "$folder" "$file"

#find /root/directory/to/search -name 'filename.*'
#find . -type f  ! -name "*.*" -delete
#find folder/ -name "*.cpp"

#file=test1
#touch $file
#ls
#echo Renommage
#if
#fileNew=test1rename
#mv $file $fileNew
#ls
#echo -----
#echo "1 : $file"
#echo "2 : $fileNew"
#file=$fileNew
#echo "3 : $file"

#tes=$(( ( RANDOM % 3 )  + 1 ))
#echo $tes

#while IFS= read -p "$prompt" -r -s -n 1 char
#do
#  if [[ $char == $'\0' ]]
#  then
#      break
#  fi
#  prompt='*'
#  password+="$char"
#done1

a=$(( ( RANDOM % 5 )  + 1 ))

touch fileTest
echo "ligne1" >> fileTest
echo "ligne2" >> fileTest
echo "ligne3 $a" >> fileTest
echo "ligne3" >> fileTest
echo "ligne4 dad" >> fileTest
echo "ligne5" >> fileTest
message=`sed -n '/ligne4/q;p' fileTest`
rm fileTest
touch fileTest
echo "$message" >> fileTest