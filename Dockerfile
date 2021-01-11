FROM alpine:3.10
LABEL Description="This image can be used to regularly buy from Kraken through their API" Version="1.0"

RUN   apk --no-cache add \
      wget \
      curl \
      nodejs \
      npm \
      supervisor

#RUN apt-get update -y
#RUN apt-get upgrade -y
#RUN apt-get install -y cron
#RUN apt-get install nodejs -y
#RUN apt-get install npm -y
#RUN apt-get install -y supervisor

COPY . /src
RUN chmod +x /src/withdraw-sats.sh
RUN chmod +x /src/stack-sats.sh

# Install app dependencies
RUN cd /src; npm install

# install crontab ui
ENV   CRON_PATH /etc/crontabs
RUN   mkdir /crontab-ui; touch $CRON_PATH/root; chmod +x $CRON_PATH/root
WORKDIR /crontab-ui
COPY cron/supervisord.conf /etc/supervisord.conf
COPY cron/ /crontab-ui
RUN   npm install
ENV   HOST 0.0.0.0
ENV   PORT 8000
ENV   CRON_IN_DOCKER true
EXPOSE $PORT

# Run the command on container startup
CMD ["supervisord", "-c", "/etc/supervisord.conf"]
