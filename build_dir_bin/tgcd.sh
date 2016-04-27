#!/bin/bash

# # # USAGE: tgcd.sh $jnlpPort        # for server-server mode
# # #    OR: tgcd.sh $jnlpPort client # for client-client mode
# # #    OR: tgcd.sh ''        $mode  # for default port

DEBUG='1' ; # Blank ('') for no debug output.
sleepy=10 ;
what=tgcd ;
jnlpPort=$1 ;
which=$2 ;
server=$3 ; # Only used if which=client.
[[ $which ]] || which=server ;
which="$which-$which" ;
[[ $server ]] || server=$JNLP_APP_IP ;
[[ $jnlpPort ]] || jnlpPort=$JENKINS_SLAVE_AGENT_PORT ;
[[ $jnlpPort ]] || jnlpPort=44422 ;
[[ $nextPort ]] || nextPort=$JENKINS_SLAVE_AGENT_JNLP_PORT ;
[[ $nextPort ]] || nextPort=$((jnlpPort + 1)) ;
if [[ "$which" == "server-server" ]] ; then
  mode='-L' ;
  flag1='-p' ;
  arg1="$jnlpPort" ;
  flag2='-q' ;
  arg2="$nextPort" ;
else
  [[ $server ]] || echo "WARNING: $0: No \$server arg (3rd arg) nor \$JNLP_APP_IP environment variable defined." ;
  mode='-C' ;
  flag1='-s' ;
  arg1="localhost:$jnlpPort" ;
  flag2='-c' ;
  # arg2="jenkins-jnlp.$domain:$nextPort" ;
  arg2="$server:$nextPort" ;
  flag3='-i' ;
  arg3='10' ;
fi ;
if [[ $DEBUG ]] ; then
  echo "DEBUG: In $0:" ;
  pwd ;
  id ;
  echo ;
fi ;
nohup /home/$USER/app/bin/$what $mode $flag1 $arg1 $flag2 $arg2 $flag3 $arg3 -m f \
  & echo "Backgrounding '$what $mode $flag1 $arg1 $flag2 $arg2 $flag3 $arg3 -m f '." ;
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
