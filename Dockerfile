FROM ubuntu:18.04
LABEL Description="This image can be used to regularly buy from Kraken through their API" Version="1.0"

RUN apt-get update -y 
RUN apt-get upgrade -y
RUN apt-get install -y cron 
RUN apt-get install nodejs -y
RUN apt-get install npm -y
COPY . /src

# Install app dependencies
RUN cd /src; npm install

# Add crontab file in the cron directory
RUN touch /etc/cron.d/stack-cron
RUN touch /etc/cron.d/withdraw-cron

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/stack-cron
RUN chmod 0644 /etc/cron.d/withdraw-cron

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

# set some default envs
ENV KRAKEN_API_KEY="apiKeyFromTheKrakenSettings" \
KRAKEN_API_SECRET="privateKeyFromTheKrakenSettings" \ 
KRAKEN_API_FIAT="USD" \ 
KRAKEN_BUY_AMOUNT=21 \
CRON_STACK="1-59/2 * * * *" \
CRON_WDR="*/2 * * * *" \
KRAKEN_MAX_REL_FEE=0.5 \
KRAKEN_WITHDRAW_KEY="withdrawalKeyFromKrakenFunding" \
TEST=1

ENTRYPOINT ["/src/docker-entrypoint.sh"]

# Run the command on container startup
CMD cron && touch /var/log/cron.log && tail -f /var/log/cron.log
