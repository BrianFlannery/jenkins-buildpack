#!/bin/bash

# # # USAGE: tgcd.sh $jnlpPort        # for server-server mode
# # #    OR: tgcd.sh $jnlpPort client # for client-client mode
# # #    OR: tgcd.sh ''        $mode  # for default port

DEBUG='1' ; # Blank ('') for no debug output.
sleepy=10 ;
what=tgcd ;
jnlpPort=$1 ;
which=$2 ;
[[ $which ]] || which=server ;
which="$which-$which" ;
[[ $jnlpPort ]] || jnlpPort=44422 ;
nextPort=$((jnlpPort + 1)) ;
if [[ "$which" == "server-server" ]] ; then
  mode='-L' ;
  flag1='-p' ;
  arg1="$jnlpPort" ;
  flag2='-q' ;
  arg2="$nextPort" ;
else
  mode='-C' ;
  flag1='-s' ;
  arg1="localhost:$jnlpPort" ;
  flag2='-c' ;
  arg2="jenkins-jnlp.$domain:$nextPort" ;
fi ;
if [[ $DEBUG ]] ; then
echo "DEBUG: In $0:" ;
pwd ;
id ;
echo ;
fi ;
nohup /home/$USER/app/bin/$what $mode $flag1 $arg1 $flag2 $arg2 \
  & echo "Backgrounding '$what $mode $flag1 $arg1 $flag2 $arg2'." ;
sleep $sleepy ;
#

stillUp() {
  x=`ps -ef | egrep -v egrep | egrep -v "$what[.]sh" | egrep $what ` ;
  [[ $x ]] || echo "ERROR: Lost $what process." ;
  [[ $x ]] && sleep $sleepy || exit 1 ;
}

while 'true' ; do
  stillUp ;
done ;

#
