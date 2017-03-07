FROM debian:jessie
MAINTAINER Richard Bramley <rabramley@gmail.com>

ADD mysql-proxy-0.8.5-linux-debian6.0-x86-64bit.tar.gz /var/local/
ADD ./log_errors.lua /var/local/

EXPOSE 4040

ENTRYPOINT ["/var/local/mysql-proxy-0.8.5-linux-debian6.0-x86-64bit/bin/mysql-proxy", "--proxy-lua-script=/var/local/log_errors.lua", "--proxy-backend-addresses=mysql:3306", "--proxy-address=0.0.0.0:3306"]