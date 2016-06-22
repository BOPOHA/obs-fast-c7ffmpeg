%global commit 01223329fddce4800e3b9cded4267dd967d676a4
%global shortcommit %(c=%{commit}; echo ${c:0:7})
%global commitdate 20151217
%global gitversion .git%{commitdate}.%{shortcommit}

Name:		ocl-icd
Version:	2.2.8
Release:	2%{?gitversion}%{?dist}
Summary:	OpenCL ICD Bindings

License:	BSD
URL:		https://forge.imag.fr/projects/ocl-icd/
Source0:        https://forge.imag.fr/frs/download.php/664/%{name}-%{version}.tar.gz
#Source0:	https://forge.imag.fr/plugins/scmgit/cgi-bin/gitweb.cgi?p=%{name}/%{name}.git;a=snapshot;h=%{commit};sf=tgz#/%{name}-%{shortcommit}.tar.gz

BuildRequires:	libtool
BuildRequires:	opencl-headers
BuildRequires:	ruby

Provides:	opencl-icd-loader


%description
OpenCL ICD Bindings


%package devel
Summary:	Development files for OpenCL ICD Bindings
Requires:	%{name}%{?_isa} = %{version}-%{release}


%description devel
This package contains the development files for %{name}.


%prep
%setup -q


%build
autoreconf -fiv
%configure
make %{?_smp_mflags}


%install
%make_install
find %{buildroot} -type f -name '*.la' -print0 | xargs -0 rm -rf
rm -rf %{buildroot}/%{_defaultdocdir}


%check
make check


%post -p /sbin/ldconfig
%postun -p /sbin/ldconfig


%files
%doc COPYING NEWS README
%{_libdir}/libOpenCL.so.*


%files devel
%doc ocl_icd_loader_gen.map ocl_icd_bindings.c
%{_includedir}/*
%{_libdir}/libOpenCL.so
%{_libdir}/pkgconfig/*.pc


%changelog
* Thu Feb 04 2016 Fedora Release Engineering <releng@fedoraproject.org> - 2.2.8-2.git20151217.0122332
- Rebuilt for https://fedoraproject.org/wiki/Fedora_24_Mass_Rebuild

* Mon Dec 21 2015 François Cami <fcami@fedoraproject.org> - 2.2.8-1.git20151217.0122332
- Update to 2.2.8.

* Wed Jun 17 2015 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 2.2.7-2.git20150606.ebbc4c1
- Rebuilt for https://fedoraproject.org/wiki/Fedora_23_Mass_Rebuild

* Tue Jun 09 2015 François Cami <fcami@fedoraproject.org> - 2.2.7-1.git20150609.ebbc4c1
- Update to 2.2.7.

* Sun Jun 07 2015 François Cami <fcami@fedoraproject.org> - 2.2.5-1.git20150606.de64dec
- Update to 2.2.5 (de64dec).

* Mon May 18 2015 Fabian Deutsch <fabiand@fedorproject.org> - 2.2.4-1.git20150518.7c94f4a
- Update to 2.2.4 (7c94f4a)

* Mon Jan 05 2015 François Cami <fcami@fedoraproject.org> - 2.2.3-1.git20141005.7cd0c2f
- Update to 2.2.3 (7cd0c2f).

* Sun Aug 17 2014 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 2.0.4-3.git20131001.4ee231e
- Rebuilt for https://fedoraproject.org/wiki/Fedora_21_22_Mass_Rebuild

* Sat Jun 07 2014 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 2.0.4-2.git20131001.4ee231e
- Rebuilt for https://fedoraproject.org/wiki/Fedora_21_Mass_Rebuild

* Tue Oct 01 2013 Björn Esser <bjoern.esser@gmail.com> - 2.0.4-1.git20131001.4ee231e
- update to recent git-snapshot
- general cleanup, squashed unneeded BuildRequires
- cleanup the %%doc mess.
- add %%check for running the testsuite

* Wed Aug 14 2013 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 2.0.2-3
- Specfile cleanup

* Sat Aug 03 2013 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 2.0.2-2
- Rebuilt for https://fedoraproject.org/wiki/Fedora_20_Mass_Rebuild

* Fri Mar 08 2013 Rob Clark <rclark@redhat.com> 2.0.2-1
- ocl-icd 2.0.2
