 #!/bin/bash -x
 #---USAGE
 #script size xpos ypos source dest
 cfgfile=$4/xcursor.cfg
 if [[ -f $cfgfile ]]
 then
    :>$cfgfile
 fi
 frames=$(find $4 -type f -name "*.png" | sort -n -k2 --field-separator=-)
 if [[ $(echo "$frames" | wc -l) -eq 1 ]]
 then
   echo "$1 $2 $3 $(echo $frames) 1000">>$cfgfile
 else
   for file in $frames
   do
      echo "$1 $2 $3 $file 100" >> $cfgfile
   done
 fi
 echo "Output:"
 cat $cfgfile
 echo -en "\nCreating cursor "
 xcursorgen $cfgfile $5
 if [[ $? -eq 0 ]]
 then
    echo -e "[\e[0;32mOK\e[0m]\n - Output on $5"
 else
    echo -e "[\e[0;31mERROR\e[0m]\n - Something wrong happened"
 fi