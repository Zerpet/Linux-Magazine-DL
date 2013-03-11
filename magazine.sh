#!/bin/bash

function init {  
  cd /home/$(whoami)
  mkdir -p magazine-tmp
  cd magazine-tmp
}

function cleanup {
  rm -r /home/$(whoami)/magazine-tmp &> /dev/null
}

function pre_checks {
  # TODO check if pdftk and wget are installed
  echo "TODO"
}

init

echo -n "Introduce the last number you have suscribed: "
read A

echo -n "Introduce your username: "
read user

echo -n "Introduce the password (will not echo): "
read -s pass
echo

for i in `seq -f %02g 1 $A` ; do
  echo "Downloading magazine number $i..."
  # There are different URIs for magazines depending on how many magazines do you have suscribed
  wget -q --recursive -l1 -nH --cut-dirs=3 -A pdf --http-user=$user --http-password=$pass https://www.linux-magazine.es/issue/${i}/
  wget -q --recursive -l1 -nH --cut-dirs=3 -A pdf --http-user=$user --http-password=$pass https://www.linux-magazine.es/digital/issue/${i}/
  
  # 4º Unión de todos los artículos descargados en un sólo pdf.
  pdftk *.pdf cat output linuxmagazine${i}.pdf
  mv linuxmagazine${i}.pdf /home/$(whoami)/
  rm *.pdf
done

cleanup

