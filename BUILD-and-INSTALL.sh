#!/bin/bash
#

echo "Installing required packages...."
yum -y install git make gcc sed postgresql-devel readline-devel \
pcre-devel openssl-devel gcc pcre-devel libxml2-devel libxslt-devel \
gd-devel geoip-devel gperftools-devel libatomic_ops-devel rpm-build

echo "Creating directory structure and setting up SOURCES...." 
mkdir -p ~/rpmbuild/{SOURCES,SPECS}
cp ~/openresty-spec/SOURCES/ngx_openresty.service ~/rpmbuild/SOURCES/
#cd ~/rpmbuild/SOURCES && { curl -O https://openresty.org/download/ngx_openresty-1.9.3.1.tar.gz ; cd  -; }
#curl -o ~/rpmbuild/SOURCES/ngx_openresty-1.9.3.1.tar.gz  https://openresty.org/download/ngx_openresty-1.9.3.1.tar.gz
cp ~/openresty-spec/SOURCES/ngx_openresty-1.9.3.1.tar.gz ~/rpmbuild/SOURCES/
cp ~/openresty-spec/SPECS/ngx_openresty.spec ~/rpmbuild/SPECS/

echo "Building package...."
rpmbuild -ba ~/rpmbuild/SPECS/ngx_openresty.spec


echo "Installing package and dependencies...."
yum -y install /root/rpmbuild/RPMS/x86_64/ngx_openresty-1.9.3.1-1.el7.centos.x86_64.rpm

#
# END OF FILE
#
