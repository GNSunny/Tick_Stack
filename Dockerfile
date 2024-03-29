FROM debian:latest
MAINTAINER sunnynehar <sunnynehar56@gmail.com>

RUN apt-get update && apt-get install -y wget curl telnet

RUN wget https://dl.influxdata.com/influxdb/releases/influxdb_1.7.9_amd64.deb \
  && dpkg -i influxdb_1.7.9_amd64.deb

RUN wget https://dl.influxdata.com/telegraf/releases/telegraf_1.12.4-1_amd64.deb \
  && dpkg -i telegraf_1.12.4-1_amd64.deb

RUN wget https://dl.influxdata.com/chronograf/releases/chronograf_1.7.14_amd64.deb \
  && dpkg -i chronograf_1.7.14_amd64.deb

RUN wget https://dl.influxdata.com/kapacitor/releases/kapacitor_1.5.3_amd64.deb \
  && dpkg -i kapacitor_1.5.3_amd64.deb

RUN influxd config > /etc/influxdb/influxdb.generated.conf

RUN apt-get update && apt-get install -y supervisor net-tools
# RUN easy_install supervisor
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

CMD ["/usr/bin/supervisord"]


# CMD ["sh", "-c" "service influxdb auotorestart=true"]
# CMD ["sh", "-c" "service telegraf auotorestart=true"]
# CMD ["sh", "-c" "service chronograf auotorestart=true"]
# CMD ["sh", "-c" "service kapacitor auotorestart=true"]

# CMD ["/usr/bin/influxdb", "--config", "/etc/influxdb/influxdb.conf"]
# CMD ["/usr/bin/telegraf", "--config", "/etc/telegraf/telegraf.conf"]
# CMD ["/usr/bin/chronograf", "--config", "/etc/chronograf/config.conf"]
# CMD ["/usr/bin/kapacitor", "--config", "/etc/kapacitor/kapacitor.conf"]