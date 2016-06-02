#
# OpenResty CentOS 7 container
#

FROM centos
MAINTAINER William Caban <william.caban@savantadvisors.com>

LABEL version="1.9.7.2-4"
LABEL build="160206"
LABEL image="01"

EXPOSE 80 443
VOLUME ["/opt/openresty"]

ENV DIRPATH /opt
ENV NGXPATH  $DIRPATH/openresty

WORKDIR $DIRPATH

COPY BUILD.sh $DIRPATH 

RUN ["$DIRPATH/BUILD.sh","buildinstall"]

ENTRY ["$NGXPATH/nginx/sbin/nginx"]

#
# END OF FILE
#
