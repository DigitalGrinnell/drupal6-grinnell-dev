#!/bin/bash
# This is dynmotd.sh, as part of Puppet module "dynmotd".  
PROCCOUNT=`ps -Afl | wc -l`
PROCCOUNT=`expr $PROCCOUNT - 5`
GROUPZ=`groups`
if [[ $GROUPZ == *irc* ]]; then
ENDSESSION=`cat /etc/security/limits.conf | grep "@irc" | grep maxlogins | awk {'print $4'}`
PRIVLAGED="IRC Account"
else
ENDSESSION="Unlimited"
PRIVLAGED="Regular User"
fi
echo -e "\033[1;32m`hostname | figlet -f /usr/share/figlet/small.flf`"
echo -e "\033[0;35m+++++++++++++++++: \033[0;37mSystem Data\033[0;35m :+++++++++++++++++++
\033[0;35m+  \033[0;37mHostname \033[0;35m= \033[1;32m<%= @hostname %>
\033[0;35m+  \033[0;37mAdapters \033[0;35m= \033[1;32m<%= @interfaces %>
\033[0;35m+   \033[0;37mAddress \033[0;35m= \033[1;32meth0: <%= @ipaddress_eth0 %>
\033[0;35m+   \033[0;37m        \033[0;35m= \033[1;32meth1: <%= @ipaddress_eth1 %>
\033[0;35m+   \033[0;37m        \033[0;35m= \033[1;32meth2: <%= @ipaddress_eth2 %>
\033[0;35m+    \033[0;37mKernel \033[0;35m= \033[1;32m`uname -r`
\033[0;35m+    \033[0;37mMemory \033[0;35m= \033[1;32m`cat /proc/meminfo | grep MemTotal | awk {'print $2'}` kB"
#
# Replaced lines below with Puppet facts (above) on March 24, 2014.
#\033[0;35m+  \033[0;37mHostname \033[0;35m= \033[1;32m `hostname`
#\033[0;35m+  \033[0;37mAdapters \033[0;35m= \033[1;32m<%= @interfaces %>
#\033[0;35m+   \033[0;37mAddress \033[0;35m= \033[1;32meth0: `/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`
#\033[0;35m+   \033[0;37m        \033[0;35m= \033[1;32meth1: `/sbin/ifconfig eth1 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`
#\033[0;35m+   \033[0;37m        \033[0;35m= \033[1;32meth2: `/sbin/ifconfig eth2 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`
#
echo -e "\033[0;35m++++++++++++++++++: \033[0;37mUser Data\033[0;35m :++++++++++++++++++++
\033[0;35m+  \033[0;37mUsername \033[0;35m= \033[1;32m`whoami`
\033[0;35m+ \033[0;37mPrivlages \033[0;35m= \033[1;32m$PRIVLAGED
\033[0;35m+  \033[0;37mSessions \033[0;35m= \033[1;32m`who | grep $USER | wc -l` of $ENDSESSION MAX
\033[0;35m+ \033[0;37mProcesses \033[0;35m= \033[1;32m$PROCCOUNT of `ulimit -u` MAX"
echo -e "\033[0;35m++++++++++++++++++: \033[0;37mDisk Data\033[0;35m :++++++++++++++++++++
\033[1;32m`df -h / | grep '%'`"
echo -e "\033[0;35m+++++++++++++: \033[0;37mHelpful Information\033[0;35m :+++++++++++++++
\033[0;35m+ \033[0;37mMOTD Script \033[0;35m= \033[1;32m/usr/local/bin/dynmotd
\033[0;35m+ \033[0;37mMaintenance Info \033[0;35m= \033[1;32m/etc/motd-maint
\033[0;35m+ \033[0;37mFor documentation see GitHub \033[0;35m= \033[1;32mSummittDweller/docs"
echo -e "\033[0;35m+++++++++++: \033[0;31mMaintenance Information\033[0;35m :+++++++++++++
\033[0;35m+\033[1;32m `cat /etc/motd-maint`
\033[0;35m+++++++++++++++++++++++++++++++++++++++++++++++++++\033[0;37m"
