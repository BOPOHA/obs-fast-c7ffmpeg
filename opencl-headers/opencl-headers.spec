Summary:  Khronos OpenCL development headers
Name:     opencl-headers
Version:  1.2
Release:  9%{?dist}
License:  MIT
URL:      http://www.khronos.org/registry/cl/
BuildArch: noarch

Source0: http://www.khronos.org/registry/cl/api/1.2/opencl.h
Source1: http://www.khronos.org/registry/cl/api/1.2/cl_platform.h
Source2: http://www.khronos.org/registry/cl/api/1.2/cl.h
Source3: http://www.khronos.org/registry/cl/api/1.2/cl_ext.h
Source4: http://www.khronos.org/registry/cl/api/1.2/cl_dx9_media_sharing.h
Source5: http://www.khronos.org/registry/cl/api/1.2/cl_d3d10.h
Source6: http://www.khronos.org/registry/cl/api/1.2/cl_d3d11.h
Source7: http://www.khronos.org/registry/cl/api/1.2/cl_gl.h
Source8: http://www.khronos.org/registry/cl/api/1.2/cl_gl_ext.h
Source9: http://www.khronos.org/registry/cl/api/1.2/cl.hpp
Source10: https://www.khronos.org/registry/cl/api/1.2/cl_egl.h

Patch0: arm-nosse2.patch


%description
Khronos OpenCL development headers


%prep
%setup -T -c

cp %{SOURCE9} .
%patch0 -b .nosse2


%build


%install
mkdir -p $RPM_BUILD_ROOT%{_includedir}/CL/
cp \
	%{SOURCE0} \
	%{SOURCE1} \
	%{SOURCE2} \
	%{SOURCE3} \
	%{SOURCE4} \
	%{SOURCE5} \
	%{SOURCE6} \
	%{SOURCE7} \
	%{SOURCE8} \
	cl.hpp \
	%{SOURCE10} \
	$RPM_BUILD_ROOT%{_includedir}/CL/



%files
%dir %{_includedir}/CL
%{_includedir}/CL/opencl.h
%{_includedir}/CL/cl.h
%{_includedir}/CL/cl_egl.h
%{_includedir}/CL/cl_ext.h
%{_includedir}/CL/cl_d3d10.h
%{_includedir}/CL/cl_d3d11.h
%{_includedir}/CL/cl_gl.h
%{_includedir}/CL/cl_gl_ext.h
%{_includedir}/CL/cl_platform.h
%{_includedir}/CL/cl_dx9_media_sharing.h
%{_includedir}/CL/cl.hpp

%changelog
* Thu Feb 04 2016 Fedora Release Engineering <releng@fedoraproject.org> - 1.2-9
- Rebuilt for https://fedoraproject.org/wiki/Fedora_24_Mass_Rebuild

* Sun Jan 17 2016 Dave Airlie <airlied@redhat.com> - 1.2-8
- add cl_egl.h

* Wed Jun 17 2015 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 1.2-7
- Rebuilt for https://fedoraproject.org/wiki/Fedora_23_Mass_Rebuild

* Sat Jun 07 2014 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 1.2-6
- Rebuilt for https://fedoraproject.org/wiki/Fedora_21_Mass_Rebuild

* Fri Apr 25 2014 Fabian Deutsch <fabiand@fedoraproject.org> - 1.2-5
- Pull patch application into pre

* Fri Apr 25 2014 Fabian Deutsch <fabiand@fedoraproject.org> - 1.2-4
- Add patch for cl.hpp to be usable on arm rhbz#1027199

* Sat Aug 03 2013 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 1.2-3
- Rebuilt for https://fedoraproject.org/wiki/Fedora_20_Mass_Rebuild

* Fri Mar 01 2013 Dave Airlie <airlied@redhat.com> 1.2-2
- fix missing dir and remove defattr.

* Wed Feb 27 2013 Dave Airlie <airlied@redhat.com> 1.2-1
- OpenCL header files from Khronos for OpenCL 1.2

