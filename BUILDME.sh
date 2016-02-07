#!/bin/bash
#
HERE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
VERSION=1.9.7.2
RELEASE=3
USER=$(whoami)
SUDO=""
PWD=`pwd`

# Fix issue with CI builds in docker containers (no sudo available)
if [[ ! "$USER" == "root" ]]; then
	SUDO="sudo"
fi
# Try to fix an issue with containers
echo "INITIAL PWD:" `pwd`, "INITIAL HERE" ${HERE}

install_required_packages()
{
	echo -e "\nInstalling packages required to build RPMs...."
	${SUDO} yum -y install epel-release deltarpm
	${SUDO} yum -y install git make gcc sed postgresql-devel readline-devel \
	pcre-devel openssl-devel gcc pcre-devel libxml2-devel libxslt-devel \
	gd-devel geoip-devel gperftools-devel libatomic_ops-devel rpm-build \
	gperftools-devel lua-devel
}

create_building_environment()
{
	# Try to fix an issue with containers
	echo "create_building_environment PWD:" `pwd`
	cd ${HERE}

	echo -e "\nCreating directory structure and setting up SOURCES...."
	mkdir -p ${HERE}/rpmbuild/{SOURCES,SPECS}
	cp ${HERE}/SOURCES/ngx_openresty.service ${HERE}/rpmbuild/SOURCES/
	if [ ! -f ${HERE}/SOURCES/ngx_openresty-${VERSION}.tar.gz ]; then
		echo -e "\nDownloading tar.gz source from openresty..."
		curl -o ${HERE}/SOURCES/ngx_openresty-${VERSION}.tar.gz   https://openresty.org/download/ngx_openresty-${VERSION}.tar.gz
	fi
	cp ${HERE}/SOURCES/ngx_openresty-${VERSION}.tar.gz ${HERE}/rpmbuild/SOURCES/
	cp ${HERE}/SPECS/ngx_openresty.spec ${HERE}/rpmbuild/SPECS/
}

build_package()
{
	# Try to fix an issue with containers
	echo "build_package PWD:" `pwd`
	cd ${HERE}

	if [  -f ${HERE}/rpmbuild/SOURCES/ngx_openresty-${VERSION}.tar.gz ]; then
		echo -e "\nBuilding package...."
		# for debug
		ls -lR 
		rpmbuild --buildroot=${HERE}/rpmbuild -ba ${HERE}/rpmbuild/SPECS/ngx_openresty.spec
	else
		echo -e "\nMissing dependency"
	fi
}

install_test_package()
{
	# Try to fix an issue with containers
	echo "install_test_package PWD:" `pwd`
	cd ${HERE}

	if [ -f ${HERE}/rpmbuild/RPMS/x86_64/ngx_openresty-${VERSION}-${RELEASE}.el7.centos.x86_64.rpm ]; then
		echo -e "\nInstalling package and dependencies...."
		${SUDO} yum -y install ${HERE}/rpmbuild/RPMS/x86_64/ngx_openresty-${VERSION}-${RELEASE}.el7.centos.x86_64.rpm
	else
		echo -e "\nERROR: No RPM found..."
	fi
}

run_interactive()
{
	read -n 1 -p "Install pre-req packages (y/n)?" yesno;
	
	if [[ "$yesno" == "y" ]] ; then
	 	install_required_packages
	 	create_building_environment
	else
	    echo -e "\nGenerating building environment only"
	 	create_building_environment
	fi

	read -n 1 -p "Build RPM packages (y/n)?" yesno;
	if [[ "$yesno" == "y" ]] ; then
	 	build_package
	fi

	read -n 1 -p "Install resulting RPM package (y/n)?" yesno;
	if [[ "$yesno" == "y" ]] ; then
	 	install_test_package
	fi
}

display_usage()
{
	_usage=" usage: $0 [ --help | help | install | buildonly | buildauto | buildinstall ]\n
				\t--help | help \t Display this help. (Also supports '-h')\n
				\tinstall      \t Install RPM package\n
				\tbuildonly    \t Build RPM package (assume pre-requisites have been met)\n
				\tbuildauto    \t Install build pre-requisites and build RPM package\n
				\tbuildinstall \t Build and install RPM (install build pre-requisites)\n
				"
	echo -e ${_usage}
}

case $1 in
	"install")
		install_test_package
		;;
	"buildonly")
		build_package
		;;
	"buildauto")
		install_required_packages
		create_building_environment
		build_package
		;;
	"buildinstall")
		install_required_packages
		create_building_environment
		build_package
		install_test_package
		;;
	"--help" | "help" | "-h")
		display_usage
		;;
	*)
		run_interactive
		;;
esac


#
# END OF FILE
#
