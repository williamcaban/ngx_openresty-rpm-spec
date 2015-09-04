ngx_openresty-rpm-spec for CentOS 7
====================================

This spec file will build an OpenResty RPM for CentOS 7. It has been tested with CentOS 7, but it should work with any RedHat 7 based Linux.

To simplify my build and test process the `BUILD-and-INSTALL.sh` bash scripts will take care of creating the build directories, installing the dependencies
required for the build environment and the installation of the resulting RPM.

The RPM will install all files and binaries under `/opt/ngx_openresty`


USING THE BUILD & INSTALL SCRIPT
--------------------------------

You can build the RPM manually or use the Build & Install script.

First make sure these file and folders are in /root/openresty-spec/

	git clone ...

Second, download the ngx_openresty source:

	cd /root/openresty-spec/SOURCES
	curl -O https://openresty.org/download/ngx_openresty-1.9.3.1.tar.gz

The Build & Isntall script assumes it is running as root and that these sources
are copied into `/root/openresty-spec/`

	/root/openresty-spec/BUILD-and-INSTALL.sh


USING MANUAL BUILD
------------------

First, install the required packages for the RPM build environment:

	yum -y install git make gcc sed postgresql-devel readline-devel \
	pcre-devel openssl-devel gcc pcre-devel libxml2-devel libxslt-devel \
	gd-devel geoip-devel gperftools-devel libatomic_ops-devel rpm-build


Second, create the rpmbuild path:

	mkdir -p ~/rpmbuild/{SOURCES,SPECS}

Third, copy or download source files into correct folders:

	cp ~/openresty-spec/SOURCES/ngx_openresty.service ~/rpmbuild/SOURCES/
	cp ~/openresty-spec/SPECS/ngx_openresty.spec ~/rpmbuild/SPECS/
	curl -o ~/rpmbuild/SOURCES/ngx_openresty-1.9.3.1.tar.gz  https://openresty.org/download/ngx_openresty-1.9.3.1.tar.gz

Finally, build the RPM:

	rpmbuild -ba ~/rpmbuild/SPECS/ngx_openresty.spec

The resulting RPMs will be in `~/rpmbuild/RPMS/{platform}/` and the SRPM will be in `~/rpmbuild/SRPMS/`.


INSTALLATION
------------

To install the resulting RPM and all the required dependencies 

	yum -y install /root/rpmbuild/RPMS/x86_64/ngx_openresty-1.9.3.1-1.el7.centos.x86_64.rpm


STARTING
========
The NGINX process can be started with the following command:

	systemctl start ngx_openresty


IMPORTANT: If you are using some other web server make sure you modify the configuration of one of the servers to run in a non default port.

