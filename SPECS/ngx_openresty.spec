Name:		ngx_openresty
Version:	1.9.7.2
Release:	4%{?dist}
Summary:	a fast web app server by extending nginx
Distribution: CentOS 7

Group:		Productivity/Networking/Web/Servers
License:	BSD
URL:		openresty.org
Source0:	http://openresty.org/download/%{name}-%{version}.tar.gz
Source1:	https://raw.githubusercontent.com/williamcaban/ngx_openresty-rpm-spec/master/SOURCES/ngx_openresty.service
Packager:   William Caban <william.caban@savantadvisors.com>

BuildRequires:	sed git make gcc postgresql-devel readline-devel pcre-devel openssl-devel gcc pcre-devel libxml2-devel libxslt-devel gd-devel geoip-devel gperftools-devel libatomic_ops-devel lua-devel
Requires:	postgresql readline pcre openssl pcre libxml2 libxslt gd geoip gperftools libatomic
Requires(pre):	shadow-utils

%define user nginx
%define homedir /opt/ngx_openresty

%description
OpenResty (aka. ngx_openresty) is a full-fledged web application server by bundling the standard Nginx core,
lots of 3rd-party Nginx modules, as well as most of their external dependencies.

OpenResty is not an Nginx fork. It is just a software bundle.

The following NGINX modules are enabled with this package:
http_iconv_module
http_postgres_module
select_module
poll_module
file-aio
http_realip_module
http_addition_module
http_xslt_module
http_image_filter_module
http_geoip_module
http_sub_module
http_dav_module
http_flv_module
http_gzip_static_module
http_auth_request_module
http_random_index_module
http_secure_link_module
http_degradation_module
http_stub_status_module
http_ssl_module
with-http_realip_module
mail
mail_ssl_module
google_perftools_module
pcre
pcre-jit
md5-asm
sha1-asm
libatomic
pcre-jit
luajit
lua51

%prep
%setup -q

%build
./configure --prefix=%{homedir} \
--with-http_iconv_module \
--with-http_postgres_module \
--with-pg_config=/usr/bin/pg_config \
--with-select_module \
--with-poll_module \
--with-file-aio \
--with-http_realip_module \
--with-http_addition_module \
--with-http_xslt_module \
--with-http_image_filter_module \
--with-http_geoip_module \
--with-http_sub_module \
--with-http_dav_module \
--with-http_flv_module \
--with-http_gzip_static_module \
--with-http_auth_request_module \
--with-http_random_index_module \
--with-http_secure_link_module \
--with-http_degradation_module \
--with-http_stub_status_module \
--with-http_ssl_module \
--with-http_realip_module \
--with-mail \
--with-mail_ssl_module \
--with-google_perftools_module \
--with-pcre \
--with-pcre-jit \
--with-md5-asm \
--with-sha1-asm \
--with-libatomic \
--with-pcre-jit \
--with-luajit \
--with-lua51

make %{?_smp_mflags}


%pre
getent group %{user} || groupadd -f -r %{user}
getent passwd %{user} || useradd -M -d %{homedir} -g %{user} -s /bin/nologin %{user}


%install
rm -rf %{buildroot}
make install DESTDIR=%{buildroot}
mkdir -p %{buildroot}/usr/lib/systemd/system/
cp %{_sourcedir}/ngx_openresty.service %{buildroot}/usr/lib/systemd/system/ngx_openresty.service



%clean
rm -rf %{buildroot}


%files
%defattr(-,root,root,-)

%attr(755,root,root) /usr/lib/systemd/system/ngx_openresty.service
%{homedir}/luajit
%{homedir}/luajit/*
%{homedir}/lualib
%{homedir}/lualib/*
%{homedir}/nginx
%{homedir}/nginx/html/*
%{homedir}/nginx/logs
%{homedir}/nginx/sbin
%{homedir}/nginx/sbin/nginx
%{homedir}/bin
%{homedir}/bin/resty

%{homedir}/nginx/conf
%{homedir}/nginx/conf/fastcgi.conf.default
%{homedir}/nginx/conf/fastcgi_params.default
%{homedir}/nginx/conf/mime.types.default
%{homedir}/nginx/conf/nginx.conf.default
%{homedir}/nginx/conf/scgi_params.default
%{homedir}/nginx/conf/uwsgi_params.default

%config %{homedir}/nginx/conf/fastcgi.conf.default
%config %{homedir}/nginx/conf/scgi_params
%config %{homedir}/nginx/conf/uwsgi_params
%config %{homedir}/nginx/conf/fastcgi_params
%config %{homedir}/nginx/conf/koi-win
%config %{homedir}/nginx/conf/nginx.conf
%config %{homedir}/nginx/conf/mime.types.default
%config %{homedir}/nginx/conf/koi-utf
%config %{homedir}/nginx/conf/fastcgi_params.default
%config %{homedir}/nginx/conf/win-utf
%config %{homedir}/nginx/conf/uwsgi_params.default
%config %{homedir}/nginx/conf/nginx.conf.default
%config %{homedir}/nginx/conf/scgi_params.default
%config %{homedir}/nginx/conf/mime.types
%config %{homedir}/nginx/conf/fastcgi.conf

%preun

%postun


%changelog
* Sat Feb 06 2016 William Caban <william.caban@savantadvisors.com> 1.9.7.2-4
- Modifications to BUILD script to support multiple actions (install, buildonly, buildauto, buildinstall) 
- Initial support to Gitlab-CI with docker runners

* Fri Feb 05 2016 Lee Trout <lee@yhathq.com> 1.9.7.2-3
- Remove Postgres & Bump version to 1.9.7.2

* Sun Sep 06 2015 William Caban <william.caban@savantadvisors.com> 1.9.3.1-2
- Add explicit support for pcre-jit, luajit, lua51

* Thu Sep 03 2015 William Caban <william.caban@savantadvisors.com> 1.9.3.1-1
- Initial SVNT RPM release
- Based on work by Brent Thomson https://github.com/brnt/openresty-rpm-spec
