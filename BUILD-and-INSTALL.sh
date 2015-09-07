#!/bin/bash
#

install_required_packages()
{
	echo -e "\nInstalling packages required to build RPMs...."
	yum -y install epel-release
	yum -y install git make gcc sed postgresql-devel readline-devel \
	pcre-devel openssl-devel gcc pcre-devel libxml2-devel libxslt-devel \
	gd-devel geoip-devel gperftools-devel libatomic_ops-devel rpm-build \
	gperftools-devel
}

create_building_environment()
{
	echo -e "\nCreating directory structure and setting up SOURCES...." 
	mkdir -p ~/rpmbuild/{SOURCES,SPECS}
	cp ~/ngx_openresty-rpm-spec/SOURCES/ngx_openresty.service ~/rpmbuild/SOURCES/
	#cd ~/rpmbuild/SOURCES && { curl -O https://openresty.org/download/ngx_openresty-1.9.3.1.tar.gz ; cd  -; }
	if [ ! -f ~/ngx_openresty-rpm-spec/SOURCES/ngx_openresty-1.9.3.1.tar.gz ]; then
		echo -e "\nDownloading tar.gz source from openresty..."
		curl -o ~/ngx_openresty-rpm-spec/SOURCES/ngx_openresty-1.9.3.1.tar.gz   https://openresty.org/download/ngx_openresty-1.9.3.1.tar.gz
	fi
	cp ~/ngx_openresty-rpm-spec/SOURCES/ngx_openresty-1.9.3.1.tar.gz ~/rpmbuild/SOURCES/
	cp ~/ngx_openresty-rpm-spec/SPECS/ngx_openresty.spec ~/rpmbuild/SPECS/
}

build_package()
{
	echo -e "\nBuilding package...."
	rpmbuild -ba ~/rpmbuild/SPECS/ngx_openresty.spec
}

install_test_package()
{
	echo -e "\nInstalling package and dependencies...."
	yum -y install /root/rpmbuild/RPMS/x86_64/ngx_openresty-1.9.3.1-1.el7.centos.x86_64.rpm
}


read -n 1 -p "Install pre-req packages (y/n)?" yesno;
if [[ "$yesno" == "y" ]] ; then
 	install_required_packages
 	create_building_environment
else
    echo -e "\nGenerating building environment only"
    create_building_envioronment
fi

if [  -f ~/rpmbuild/SOURCES/ngx_openresty-1.9.3.1.tar.gz ]; then
	read -n 1 -p "Build RPM packages (y/n)?" yesno;
	if [[ "$yesno" == "y" ]] ; then
	 	build_package
	fi
else
	echo -e "\nMissing dependency"
fi

if [ -f ~/rpmbuild/RPMS/x86_64/ngx_openresty-1.9.3.1-1.el7.centos.x86_64.rpm ]; then
	read -n 1 -p "Install resulting RPM package (y/n)?" yesno;
	if [[ "$yesno" == "y" ]] ; then
	 	install_test_package
	fi
else
	echo -e "\nERROR: No RPM found..."
fi

#
# END OF FILE
#
