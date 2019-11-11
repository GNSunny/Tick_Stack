FROM centos:7
MAINTAINER sunnynehar <sunnynehar56@gmail.com>

RUN yum update -y && yum install -y wget curl telnet

RUN wget https://dl.influxdata.com/influxdb/releases/influxdb-1.7.9.x86_64.rpm \
  && yum localinstall -y influxdb-1.7.9.x86_64.rpm

RUN wget https://dl.influxdata.com/telegraf/releases/telegraf-1.12.4-1.x86_64.rpm \
  && yum localinstall -y telegraf-1.12.4-1.x86_64.rpm

RUN wget https://dl.influxdata.com/chronograf/releases/chronograf-1.7.14.x86_64.rpm \
  && yum localinstall -y chronograf-1.7.14.x86_64.rpm

RUN wget https://dl.influxdata.com/kapacitor/releases/kapacitor-1.5.3.x86_64.rpm \
  && yum localinstall -y kapacitor-1.5.3.x86_64.rpm

RUN influxd config > /etc/influxdb/influxdb.generated.conf

RUN yum update -y && yum install -y supervisor python-setuptools net-tools
RUN easy_install supervisor -y
# Server Supervisor is an advanced network monitoring tool that can constantly watch different types of web-servers and network resources.
# It periodically checks if monitored servers or network resources are online and providing required services.
# If a monitored object unexpectedly goes offline or drops some of its important services,
# Server Supervisor can instantly warn the administrator by email, IM, or SMS.
# Besides, it will supply a significant amount of information to help the administrator
# find sources of the problem and prevent it from happening in the future.

# Configure supervisord
ADD ./conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Configure TICK files
ADD ./conf/influxdb.conf /etc/influxdb/influxdb.conf
ADD ./conf/telegraf.conf /etc/telegraf/telegraf.conf
ADD ./conf/chronograf.conf /etc/chronograf/config.conf
ADD ./conf/kapacitor.conf /etc/kapacitor/kapacitor.conf
RUN rm *.rpm
RUN mkdir -p /data/chronograf && chown -R chronograf:chronograf /data/chronograf && chmod 777 /data/chronograf

VOLUME /var/lib/influxdb/meta
VOLUME /var/lib/influxdb/data
VOLUME /var/lib/influxdb/wal
VOLUME /data/kapacitor
VOLUME /data/chronograf

EXPOSE  80
EXPOSE 8125/udp
EXPOSE 10000
EXPOSE 8083
EXPOSE 8086
EXPOSE 8088

<<<<<<< HEAD
# CMD ["sh", "-c" "service influxdb auotorestart=true"]
# CMD ["sh", "-c" "service telegraf auotorestart=true"]
# CMD ["sh", "-c" "service chronograf auotorestart=true"]
# CMD ["sh", "-c" "service kapacitor auotorestart=true"]

# CMD ["/usr/bin/influxdb", "--config", "/etc/influxdb/influxdb.conf"]
# CMD ["/usr/bin/telegraf", "--config", "/etc/telegraf/telegraf.conf"]
# CMD ["/usr/bin/chronograf", "--config", "/etc/chronograf/config.conf"]
# CMD ["/usr/bin/kapacitor", "--config", "/etc/kapacitor/kapacitor.conf"]

CMD     ["/usr/bin/supervisord"]
=======
CMD     ["/usr/bin/influxdb"]
CMD     ["/usr/bin/telegraf"]
CMD     ["/usr/bin/chronograf"]
CMD     ["/usr/bin/kapacitor"]
>>>>>>> 55c860a5a60d0bdc54af21c12e81d04fca362c7a
