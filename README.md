NOTE: This repo has been ###ARCHIVED###
=======================================

ngx_openresty-rpm-spec for CentOS 7
====================================

This spec file will build an **OpenResty** [http://openresty.org]() RPM for **CentOS 7**. It has been tested with CentOS 7, but it should work with any RedHat 7 based Linux.

To simplify the build and test process the `BUILDME.sh` bash scripts will take care of creating the build directories, installing the required dependencies for the build environment and the installation of the resulting RPM.

The RPM will install all files and binaries under `/opt/openresty`

**OpenResty** is a full-fledged web application server by bundling the standard Nginx core,
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

First, the scripts assumes it is using the current working directory.

	git clone https://github.com/williamcaban/ngx_openresty-rpm-spec.git

Second, execute the Build & Install (script assumes it is running as root and that these sources
are copied into the current working directory.

	./BUILDME.sh

Script will run interactive mode if execution mode is not specified.

```
./BUILDME.sh [ --help | help | install | buildonly | buildauto | buildinstall ]
        --help | help    Display this help. (Also supports '-h')
        install          Install RPM package
        buildonly        Build RPM package (assume pre-requisites have been met)
        buildauto        Install build pre-requisites and build RPM package
        buildinstall     Build and install RPM (install build pre-requisites)
```

USING MANUAL BUILD
------------------

First, install the required packages for the RPM build environment:

	yum -y install epel-release

	yum -y install git make gcc sed postgresql-devel readline-devel \
	pcre-devel openssl-devel gcc pcre-devel libxml2-devel libxslt-devel \
	gd-devel geoip-devel gperftools-devel libatomic_ops-devel rpm-build \
	gperftools-devel lua-devel


Second, create the rpmbuild path:

	mkdir -p ./rpmbuild/{SOURCES,SPECS}

Third, copy or download source files into correct folders:

	cp ./SOURCES/openresty.service ./rpmbuild/SOURCES/
	cp ./SPECS/openresty.spec ./rpmbuild/SPECS/
	curl -o ./rpmbuild/SOURCES/openresty-1.9.7.5.tar.gz  https://openresty.org/download/openresty-1.9.7.5.tar.gz

Finally, build the RPM:

	rpmbuild -ba ./rpmbuild/SPECS/openresty.spec

The resulting RPMs will be in `./rpmbuild/RPMS/{platform}/` and the SRPM will be in `~/rpmbuild/SRPMS/`.


INSTALLATING THE RPM
--------------------

To install the resulting RPM and all the RPM dependencies:

	yum -y install ./rpmbuild/RPMS/x86_64/openresty-1.9.7.5-1.el7.centos.x86_64.rpm


STARTING THE SERVICE
====================
The NGINX process can be started with the following command:

	systemctl start openresty

To enable the process to automatically start when machines start execute the following command:

	systemctl enable openresty


**IMPORTANT:** If you are using some other web server in the same server as your RPM build server, make sure to modify the configuration of one of the servers to run in a port diferent from port 80 (http default port).


FUTURE WORK
===========
Support for sub-packages for each module or set of modules.

Support build and deploy of the RPM for multiple dev & deployment environments:
- Docker (reference included)
- Vagrant (reference included)
- Ansible?
- SaltStack?
- Puppet?
