#!/bin/bash

rm -f /camunda/conf/server.xml
cp /camunda/conf/server_temp.xml /camunda/conf/server.xml
cp ${MAIL_CONFIG_TEMPL} ${MAIL_CONFIG}
sed -i -e "s/GMAIL_USER/$GMAIL_USER/g" ${MAIL_CONFIG}
sed -i -e "s/GMAIL_PW/$GMAIL_PW/g" ${MAIL_CONFIG}

rm -f /camunda/conf/tomcat-users.xml
cp /camunda/conf/tomcat-users_templ.xml /camunda/conf/tomcat-users.xml

rm -f /camunda/conf/web.xml
if [[ -z "${CAMUNDA_APP_PASSWORD}" ]]; then
  echo "no camunda app password set"
  cp /camunda/conf/web_without_auth.xml /camunda/conf/web.xml
else
  echo "use camunda app password"
  cp /camunda/conf/web_templ.xml /camunda/conf/web.xml
  sed -i -e "s/CAMUNDA_APP_PASSWORD/$CAMUNDA_APP_PASSWORD/g" /camunda/conf/tomcat-users.xml
fi

rm -f /camunda/conf/bpm-platform.xml
if [[ -z "${ACTIVE_JOB_EXECUTER}" ]]; then
  ACTIVE_JOB_EXECUTER="true"
fi
if [ "${ACTIVE_JOB_EXECUTER}" = "true" ]; then
  echo "use active job executer"
  cp /camunda/conf/bpm-platform-active.xml /camunda/conf/bpm-platform.xml
else
  echo "use inactive job executer"
  cp /camunda/conf/bpm-platform-inactive.xml /camunda/conf/bpm-platform.xml
fi



./camunda.sh