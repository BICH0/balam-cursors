 #!/bin/bash -x
 #---USAGE
 #script size xpos ypos source dest
 #In case there is a recipe.txt file the script will try to build all cursors specified in it

cursors=1
errorCount=0
build_cursor(){
   size=$1
   xpos=$2
   ypos=$3
   source=$4
   dest=$5
   cfgfile=$source/xcursor.cfg
   echo "Building $source"
   if [[ -f $cfgfile ]]
   then
      :>$cfgfile
   fi
   frames=$(find $source -type f -name "*.png" | sort -n -k2 --field-separator=-)
   if [[ $(echo "$frames" | wc -l) -eq 1 ]]
   then
      echo "$size $xpos $ypos $(echo $frames) 1000">>$cfgfile
   else
      for file in $frames
      do
         echo "$size $xpos $ypos $file 100" >> $cfgfile
      done
   fi
   # echo "Output:"
   # cat $cfgfile
   echo -en "Creating cursor "
   xcursorgen $cfgfile $dest
   if [[ $? -eq 0 ]]
   then
      echo -e "[\e[0;32mOK\e[0m]\n - Output on $dest"
      return 0
   else
      echo -e "[\e[0;31mERROR\e[0m]\n - Something wrong happened"
      errorCount=$(($errorCount + 1))
      return 1
   fi
 }

if [ -z "$1" ] && [ -f "./recipe.txt" ]
then
   echo -e "\nBuilding cursors from recipe file"
   lines=$(grep -ve "^[#\ ].*" ./recipe.txt | sed 's/ /$/g')
   cursors=$(echo "$lines" | wc -l)
   echo -e "Found $cursors cursors\n"
   for line in $lines
   do
      build_cursor $(echo $line | sed 's/\$/\ /g')
      echo ""
   done
elif [ -n "$1" ]
then
   build_cursor $1 $2 $3 $4 $5
else
   echo -e "[\e[0;31mERROR\e[0m]\n - You need to provide the following arguments: ./script.sh  <size> <xpos> <ypos> <source> <dest>"
   echo "Or a recipe.txt in the working folder"
   exit 1
fi
echo "----------------------------------"
if [ $errorCount -ge 1 ]
then
   echo -en "\e[0;31m"
else
   echo -en "\e[0;32m"
fi
echo -e "    Finished with $errorCount/$cursors errors \e[0m"
echo "----------------------------------"
