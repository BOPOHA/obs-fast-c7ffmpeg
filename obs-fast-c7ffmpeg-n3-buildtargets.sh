#!/bin/bash
set -e
LANG=en_US.UTF-8
REPONAME='obs-fast-c7ffmpeg'
export ACC=Admin
export REPO_NAME="home:$ACC:$REPONAME"
export TMP_DIR="/home/tmp"
export PKG_DIR="$HOME/$REPONAME"
mkdir -p $TMP_DIR 
rm -rf /root/.config/osc/trusted-certs/linux_443.pem
yes 2 |osc list

osc meta prj -F - centos6 << EOF
<project name="centos6">  
 <title>centos6</title>  
 <description></description>  
 <person role="maintainer" userid="Admin"/>  
 <person role="bugowner" userid="Admin"/> 
 <repository name="epel">
   <arch>x86_64</arch>
   <arch>i586</arch>
 </repository>
 <repository name="updates">
   <arch>x86_64</arch>
   <arch>i586</arch>
 </repository>
 <repository name="os">
   <arch>x86_64</arch>
   <arch>i586</arch>
 </repository>
</project>
EOF

osc meta prj -F - centos7 << EOF
<project name="centos7">  
 <title>centos7</title>  
 <description></description>  
 <person role="maintainer" userid="Admin"/>  
 <person role="bugowner" userid="Admin"/> 
 <repository name="epel">
   <arch>x86_64</arch>
 </repository>
 <repository name="updates">
   <arch>x86_64</arch>
 </repository>
 <repository name="os">
   <arch>x86_64</arch>
 </repository>
</project>
EOF

cd $PKG_DIR
osc meta prjconf -F ___env/centos7.conf  centos7
osc meta prjconf -F ___env/centos6.conf  centos6

osc meta prj home:$ACC -F - << EOF 
<project name="home:$ACC">
  <title>$ACC's Home Project</title>
  <description></description>
  <person userid="$ACC" role="maintainer"/>
  <person userid="$ACC" role="bugowner"/>
</project>
EOF


osc meta prj $REPO_NAME -F - << EOF
<project name="$REPO_NAME">
  <title>$REPO_NAME</title>
  <description>$REPO_NAME</description>
  <person userid="$ACC" role="maintainer"/>
  <repository name="CentOS_7">
    <path project="centos7" repository="epel"/>
    <path project="centos7" repository="updates"/>
    <path project="centos7" repository="os"/>
    <arch>x86_64</arch>
  </repository>
  <repository name="CentOS_6">
    <path project="centos6" repository="epel"/>
    <path project="centos6" repository="updates"/>
    <path project="centos6" repository="os"/>
    <arch>i586</arch>
    <arch>x86_64</arch>
  </repository>
  <build>
    <disable repository="CentOS_6"/>
  </build>
</project>
EOF

