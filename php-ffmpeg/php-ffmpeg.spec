#%global php_extdir  %(php-config --extension-dir 2>/dev/null || echo "undefined")
%global php_extdir  %(php -i| grep  ^extension_dir | awk '{print $3}'|| echo "undefined")

Name:           php-ffmpeg
Version:        0.7.1
Release:        1%{?dist}
Summary:        Extension to manipulate movie in PHP

Group:          Development/Languages
License:        GPLv2
URL:            http://ffmpeg-php.sourceforge.net/
Source0:        https://github.com/tony2001/ffmpeg-php/archive/master.tar.gz
#Source0:	http://downloads.sourceforge.net/ffmpeg-php/ffmpeg-php-%{version}.tbz2

BuildRequires:  ffmpeg-devel >= 0.5, php-devel, php-gd, re2c
Requires:       php-gd

%description
ffmpeg-php is an extension for PHP that adds an easy to use, object-oriented
API for accessing and retrieving information from video and audio files. 
It has methods for returning frames from movie files as images that can be 
manipulated using PHP's image functions. This works well for automatically 
creating thumbnail images from movies. ffmpeg-php is also useful for reporting
the duration and bitrate of audio files (mp3, wma...). ffmpeg-php can access
many of the video formats supported by ffmpeg (mov, avi, mpg, wmv...).

%prep
%setup -q -n ffmpeg-php-master
mkdir $HOME/tmp
ln -s /usr/include/ffmpeg $HOME/tmp/include

%build
phpize
CFLAGS="-I$HOME/tmp/include/ -I%{_includedir}/php/ext/gd/libgd" %configure  \
    --with-libdir=%{_lib} \
    --with-ffmpeg=$HOME/tmp \
    --enable-skip-gd-check  
make %{?_smp_mflags}

%install
rm -rf $RPM_BUILD_ROOT
make install INSTALL_ROOT=$RPM_BUILD_ROOT

# install config file
install -d $RPM_BUILD_ROOT%{_sysconfdir}/php.d
cat > $RPM_BUILD_ROOT%{_sysconfdir}/php.d/%{name}.ini << 'EOF'
; --- Enable %{name} extension module
extension=ffmpeg.so

; --- options for %{name} 
;ffmpeg.allow_persistent = 0
;ffmpeg.show_warnings = 0
EOF

%clean
make test
rm -rf $RPM_BUILD_ROOT


%files
%defattr(-,root,root,-)
%doc ChangeLog CREDITS EXPERIMENTAL INSTALL LICENSE TODO test_ffmpeg.php
%config(noreplace) %{_sysconfdir}/php.d/%{name}.ini
%{php_extdir}/ffmpeg.so

