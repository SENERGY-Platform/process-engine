#!/bin/bash

#   Copyright 2018 InfAI (CC SES)
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.


DB_DRIVER=${DB_DRIVER:-org.postgresql.Driver}
DB_HOST=${DB_HOST:-db}
DB_PORT=${DB_PORT:-5432}
DB_URL=${DB_URL:-jdbc:postgresql://db:5432/camunda}
DB_USERNAME=${DB_USERNAME:-camunda}
DB_PASSWORD=${DB_PASSWORD:-camunda}

XML_JDBC="//Resource[@name='jdbc/ProcessEngine']"
XML_DRIVER="${XML_JDBC}/@driverClassName"
XML_URL="${XML_JDBC}/@url"
XML_USERNAME="${XML_JDBC}/@username"
XML_PASSWORD="${XML_JDBC}/@password"


echo "use gmail user ${GMAIL_USER} in ${MAIL_CONFIG}"
sed -i.bak -e "s/\${GMAIL_USER}/${GMAIL_USER}/" ${MAIL_CONFIG}
rm ${MAIL_CONFIG}.bak

echo "use gmail pw ${GMAIL_PW} in ${MAIL_CONFIG}"
sed -i.bak -e "s/\${GMAIL_PW}/${GMAIL_PW}/" ${MAIL_CONFIG}
rm ${MAIL_CONFIG}.bak


if [ -z "$SKIP_DB_CONFIG" ]
then
  echo "Configure database"
  xmlstarlet ed -L \
    -u "${XML_DRIVER}" -v "${DB_DRIVER}" \
    -u "${XML_URL}" -v "${DB_URL}" \
    -u "${XML_USERNAME}" -v "${DB_USERNAME}" \
    -u "${XML_PASSWORD}" -v "${DB_PASSWORD}" \
    ${SERVER_CONFIG}

    if [ -z "$SKIP_CREATE_SCHEMA" ]
    then
    	bash /usr/local/bin/${DATABASE}.sh
    fi	
fi

exec ${CATALINA_HOME}/bin/catalina.sh run