%define _unpackaged_files_terminate_build 0

#
#==============================================================================================
# spec file for package Biorails (Version 3.0.0)
# by Robert Shell bob@biorails.org
# Copyright (c) 2008 Alces Ltd.
#==============================================================================================
#
# This file and all modifications and additions to the pristine
# package are under the same license as the package itself.
#
# Please submit bug fixes or comments via http://biorails.org/
#
summary:	Biorails Enterprise 3.0 Web Application
name:		biorails
version:	3.0
release:	0
source:	        %{name}-%{version}.tar.gz
vendor: 	Alces, Ltd.
packager: 	Edge Software consultancy Ltd <support@edgesoftwareconsultancy.com>
group:		Productivity/Other
License:        Other License(s), see package
prefix:		/opt/%{name}/%{version}
URL:		http://biorails.org/
buildroot: %{_tmppath}/%{name}
AutoReqProv: no
BuildRequires: apache2 ruby gcc gcc-c++ glibc-devel ImageMagick ImageMagick-devel gcc make subversion zlib-devel
requires: apache2 ruby gcc gcc-c++ glibc-devel ImageMagick ImageMagick-devel gcc make subversion zlib-devel

%description
This is a Web Application to be hosted behind apache 2.2

#
#==============================================================================================
# Prep phase taking are from SOURCES and preparing
#==============================================================================================
#
%prep
%setup -q
#
#==============================================================================================
# Build phase compiling all the source files for ruby, htmldoc etc.
#==============================================================================================
#
%build
export BIORAILS_BUILD=$PWD
export BIORAILS_HOME=/opt/%{name}/%{version}
#
# Build and install locally ruby
#
cd ${BIORAILS_BUILD}
# Compile ruby
cd src/ruby
./configure -prefix=$BIORAILS_HOME
make clean
make DESTDIR=${RPM_BUILD_ROOT}
#
# Build and install locally ruby OCI8 interface
#
# Compile OCI8
cd ${BIORAILS_BUILD}
export LD_LIBRARY_PATH=${BIORAILS_BUILD}/lib/oracle.10.2.0.4
cd src/ruby-oci8
make clean
make


#
#==============================================================================================
# Build phase compiling all the source files for ruby, htmldoc etc.
#==============================================================================================
#
%install
export BIORAILS_BUILD=$PWD
rm -rf $RPM_BUILD_ROOT
mkdir -p ${RPM_BUILD_ROOT}%{prefix}
mkdir -p /usr/bin
mkdir -p /etc/init.d
#
# Setup environment
#
export BIORAILS_HOME=${RPM_BUILD_ROOT}%{prefix}
export GEM_HOME=${BIORAILS_HOME}/lib/gems/1.8
export LD_LIBRARY_PATH=${BIORAILS_HOME}/lib/oracle.10.2.0.4
#
# Copy site
#
cp -a site ${BIORAILS_HOME}
cp -a lib  ${BIORAILS_HOME}
cp -a bin  ${BIORAILS_HOME}
install bin/biorails                ${RPM_BUILD_ROOT}/usr/bin/biorails
install etc/init.d/biorails-daemon  ${RPM_BUILD_ROOT}/init.d/biorails-daemon
#
# Install ruby
#
cd ${BIORAILS_BUILD}
cd src/ruby
make install DESTDIR=${BIORAILS_BUILD}
#
# Install oracle driver
#
mkdir -p ${BIORAILS_HOME}/lib/ruby/site_ruby/1.8/i686-linux/
cd ${BIORAILS_BUILD}
cd src/ruby-oci8
cp lib/oci8.rb          ${BIORAILS_HOME}/lib/ruby/site_ruby/1.8/oci8.rb
cp -R lib/DBD           ${BIORAILS_HOME}/lib/ruby/site_ruby/1.8/
cp ext/oci8/oci8lib.so  ${BIORAILS_HOME}/lib/ruby/site_ruby/1.8/i686-linux/
 
%clean
rm -rf $RPM_BUILD_ROOT

%files
#%defattr(-,root,root)
/usr/bin/biorails
%{prefix}/*

