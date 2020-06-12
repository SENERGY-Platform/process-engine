#!/bin/bash

rm -f /camunda/conf/server.xml
cp /camunda/conf/server_temp.xml /camunda/conf/server.xml
cp ${MAIL_CONFIG_TEMPL} ${MAIL_CONFIG}
sed -i -e "s/GMAIL_USER/$GMAIL_USER/g" ${MAIL_CONFIG}
sed -i -e "s/GMAIL_PW/$GMAIL_PW/g" ${MAIL_CONFIG}

./camunda.sh