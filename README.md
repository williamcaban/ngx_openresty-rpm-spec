ngx_openresty-rpm-spec for CentOS 7
====================================

This spec file will build an **OpenResty** [http://openresty.org]() RPM for **CentOS 7**. It has been tested with CentOS 7, but it should work with any RedHat 7 based Linux.

To simplify the build and test process the `BUILD-and-INSTALL.sh` bash scripts will take care of creating the build directories, installing the required dependencies for the build environment and the installation of the resulting RPM.

The RPM will install all files and binaries under `/opt/ngx_openresty`

**OpenResty** (aka. ngx_openresty) is a full-fledged web application server by bundling the standard Nginx core,
lots of 3rd-party Nginx modules, as well as most of their external dependencies.

**OpenResty** is **not** an **NGINX** fork. It is just a software bundle.

The following **NGINX** modules are enabled with this package:

- http\_iconv\_module
- http\_postgres\_module
- select\_module
- poll\_module
- file-aio
- http\_realip\_module
- http\_addition\_module
- http\_xslt\_module
- http\_image\_filter\_module
- http\_geoip\_module
- http\_sub\_module
- http\_dav\_module
- http\_flv\_module
- http\_gzip\_static\_module
- http\_auth\_request\_module
- http\_random\_index\_module
- http\_secure\_link\_module
- http\_degradation\_module
- http\_stub\_status\_module
- http\_ssl\_module
- with-http\_realip\_module
- mail
- mail\_ssl\_module
- google\_perftools\_module
- pcre
- pcre-jit
- md5-asm
- sha1-asm
- libatomic 
- pcre-jit
- luajit
- lua51

USING THE BUILD & INSTALL SCRIPT
--------------------------------

You can build the RPM manually or use the Build & Install script.

First, the scripts assumes it is using the folder `~/ngx_openresty-rpm-spec/`

	git clone https://github.com/williamcaban/ngx_openresty-rpm-spec.git

Second, execute the Build & Isntall (script assumes it is running as root and that these sources
are copied into `~/ngx_openresty-rpm-spec/`

	~/ngx_openresty-rpm-spec/BUILD-and-INSTALL.sh


USING MANUAL BUILD
------------------

First, install the required packages for the RPM build environment:

	yum -y install epel-release

	yum -y install git make gcc sed postgresql-devel readline-devel \
	pcre-devel openssl-devel gcc pcre-devel libxml2-devel libxslt-devel \
	gd-devel geoip-devel gperftools-devel libatomic_ops-devel rpm-build \
	gperftools-devel


Second, create the rpmbuild path:

	mkdir -p ~/rpmbuild/{SOURCES,SPECS}

Third, copy or download source files into correct folders:

	cp ~/ngx_openresty-rpm-spec/SOURCES/ngx_openresty.service ~/rpmbuild/SOURCES/
	cp ~/ngx_openresty-rpm-spec/SPECS/ngx_openresty.spec ~/rpmbuild/SPECS/
	curl -o ~/rpmbuild/SOURCES/ngx_openresty-1.9.3.1.tar.gz  https://openresty.org/download/ngx_openresty-1.9.3.1.tar.gz

Finally, build the RPM:

	rpmbuild -ba ~/rpmbuild/SPECS/ngx_openresty.spec

The resulting RPMs will be in `~/rpmbuild/RPMS/{platform}/` and the SRPM will be in `~/rpmbuild/SRPMS/`.


INSTALLATING THE RPM
--------------------

To install the resulting RPM and all the RPM dependencies:

	yum -y install ~/rpmbuild/RPMS/x86_64/ngx_openresty-1.9.3.1-1.el7.centos.x86_64.rpm


STARTING THE SERVICE
====================
The NGINX process can be started with the following command:

	systemctl start ngx_openresty


**IMPORTANT:** If you are using some other web server in the same server as your RPM build server, make sure to modify the configuration of one of the servers to run in a port diferent from port 80 (http default port).








