#!/bin/bash
DISABLEc6x64=True
DISABLEc6x32=True
DISABLEc7x64=False

rcobsscheduler shutdown
mkdir -p /home/repos/{centos6,centos7}/{os,updates,epel}/{x86_64,i586}

if [ "$DISABLEc6x64" = "False" ]; then
    cd       /home/repos/centos6/os/x86_64/       && rsync --progress  -av --delete --exclude debug/ --exclude "*debuginfo*" rsync://mirrors.kernel.org/centos/6/os/x86_64/Packages/ .
    cd       /home/repos/centos6/updates/x86_64/  && rsync --progress  -av --delete --exclude debug/ --exclude "*debuginfo*" rsync://mirrors.kernel.org/centos/6/updates/x86_64/Packages/ .
    cd       /home/repos/centos6/epel/x86_64/     && rsync --progress  -av --delete --exclude debug/ --exclude "*debuginfo*" rsync://mirror.pnl.gov/epel/6/x86_64/ .
fi

if [ "$DISABLEc6x32" = "False" ]; then
    cd       /home/repos/centos6/os/i586/         && rsync --progress  -av --delete --exclude debug/ --exclude "*debuginfo*" rsync://mirrors.kernel.org/centos/6/os/i386/Packages/ .
    cd       /home/repos/centos6/updates/i586/    && rsync --progress  -av --delete --exclude debug/ --exclude "*debuginfo*" rsync://mirrors.kernel.org/centos/6/updates/i386/Packages/ .
    cd       /home/repos/centos6/epel/i586/       && rsync --progress  -av --delete --exclude debug/ --exclude "*debuginfo*" rsync://mirror.pnl.gov/epel/6/i386/ .
fi

if [ "$DISABLEc7x64" = "False" ]; then
    cd       /home/repos/centos7/os/x86_64/       && rsync --progress  -av --delete --exclude debug/ --exclude "*debuginfo*" rsync://mirrors.kernel.org/centos/7/os/x86_64/Packages/ .
    cd       /home/repos/centos7/updates/x86_64/  && rsync --progress  -av --delete --exclude debug/ --exclude "*debuginfo*" rsync://mirrors.kernel.org/centos/7/updates/x86_64/Packages/ .
    cd       /home/repos/centos7/epel/x86_64/     && rsync --progress  -av --delete --exclude debug/ --exclude "*debuginfo*" rsync://mirror.pnl.gov/epel/7/x86_64/ .
fi

for PRJ in centos6 centos7; do
  for REPO in os updates epel; do
    for ARCH in x86_64 i586; do
      REPO_PATH="/srv/obs/build/$PRJ/$REPO/$ARCH/:full" ;
      mkdir -p $REPO_PATH ; find  $REPO_PATH/ -type l -delete ;
      find /home/repos/$PRJ/$REPO/$ARCH -name "*.rpm" -exec ln -s {} $REPO_PATH/ \;
    done
  done
done


chown -R obsrun.obsrun  /home/repos /srv/obs/build
rcobsscheduler start
#obs_admin --rescan-repository $PROJECT $REPO  x86_64
obs_admin --deep-check-project centos6 x86_64
obs_admin --deep-check-project centos6 i586
obs_admin --deep-check-project centos7 x86_64

