#
# MySQL Dockerfile
#
# https://github.com/dockerfile/mysql
#

# Pull base image.
FROM ubuntu:14.10

# Install MySQL.
RUN \
  echo "export http_proxy=http://sowmya_nethi:Openstack14@hysbc1.persistent.co.in:8080" >> /etc/profile \
  && echo "export https_proxy=http://sowmya_nethi:Openstack14@hysbc1.persistent.co.in:8080" >> /etc/profile \
  && . /etc/profile \
  && touch /root/Dockerfile_testfile \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server \
  && rm -rf /var/lib/apt/lists/* \
  && sed -i 's/^\(bind-address\s.*\)/# \1/' /etc/mysql/my.cnf \
  && sed -i 's/^\(log_error\s.*\)/# \1/' /etc/mysql/my.cnf \
  && echo "mysqld_safe &" > /tmp/config \
  && echo "mysqladmin --silent --wait=30 ping || exit 1" >> /tmp/config \
  && echo "mysql -e 'GRANT ALL PRIVILEGES ON *.* TO \"root\"@\"%\" WITH GRANT OPTION;'" >> /tmp/config \
  && bash /tmp/config \
  && rm -f /tmp/config

# Define mountable directories.
VOLUME ["/etc/mysql", "/var/lib/mysql"]

# Define working directory.
WORKDIR /data

# Define default command.
CMD ["mysqld_safe"]

# Expose ports.
EXPOSE 3306
