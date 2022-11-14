FROM ubuntu:22.04

RUN apt-get update -y \
    && apt-get install -y curl vim dnsutils telegraf net-tools iputils-ping tcpdump supervisor \
    && apt-get clean cache \
    && rm -rf /var/lib/apt

COPY scripts/ipmon.sh /usr/local/bin/ipmon.sh
COPY supervisor/ipmon.conf /etc/supervisor/conf.d/ipmon.conf
COPY supervisor/telegraf.conf /etc/supervisor/conf.d/telegraf.conf
COPY supervisor/supervisor.conf /etc/supervisor/supervisor.conf
COPY telegraf/telegraf.conf /etc/telegraf/telegraf.conf

USER root

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisor.conf"]
