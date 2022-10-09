FROM ubuntu:22.04

LABEL maintainer="Christophe Alexandre <christophe.alexandre@pm.me>"

RUN  apt-get update \
  && apt-get install -y unzip \
  && apt-get install -y wget \
  && apt-get install -y xvfb \
  && apt-get install -y libxtst6 \
  && apt-get install -y libxrender1 \
  && apt-get install -y libxi6 \
  && apt-get install -y x11vnc \
  && apt-get install -y socat \
  && apt-get install -y software-properties-common

# Setup IB TWS
RUN mkdir -p /opt/TWS
WORKDIR /opt/TWS

RUN wget https://download2.interactivebrokers.com/installers/ibgateway/stable-standalone/ibgateway-stable-standalone-linux-x64.sh -O /opt/TWS/ibgateway.sh
RUN chmod a+x /opt/TWS/ibgateway.sh
#RUN chmod -R u+x *.sh && chmod -R u+x Scripts/*.sh

# Install TWS
RUN yes '' | /opt/TWS/ibgateway.sh

WORKDIR /

ENV DISPLAY :0

ADD ./vnc-config/xvfb_init /etc/init.d/xvfb
ADD ./vnc-config/vnc_init /etc/init.d/vnc
ADD ./vnc-config/xvfb-daemon-run /usr/bin/xvfb-daemon-run

ADD ./ib-automater.jar /root/ib-automater.jar
ADD ./ibgateway.vmoptions /root/Jts/ibgateway/1012/ibgateway.vmoptions
ADD runscript.sh runscript.sh

RUN chmod -R u+x runscript.sh \
  && chmod -R 777 /usr/bin/xvfb-daemon-run \
  && chmod 777 /etc/init.d/xvfb \
  && chmod 777 /etc/init.d/vnc

CMD bash runscript.sh
