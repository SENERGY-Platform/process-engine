#!/bin/sh

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

export PGPASSWORD=${DB_PASSWORD}

echo ">> Waiting for postgres to start"
    WAIT=0
    while ! nc -z ${DB_HOST} ${DB_PORT}; do
      sleep 1
      WAIT=$(($WAIT + 1))
      if [ "$WAIT" -gt 15 ]; then
        echo "Error: Timeout wating for Postgres to start"
        exit 1
      fi
    done

echo "CREATE ENGINE TABLES"
psql -h ${DB_HOST} -p ${DB_PORT} -U ${DB_USERNAME} -d ${DB_NAME} -f ${SQL_CREATE_ENGINE}

echo "CREATE IDENTITY TABLES"
psql -h ${DB_HOST} -p ${DB_PORT} -U ${DB_USERNAME} -d ${DB_NAME} -f ${SQL_CREATE_IDENTITY}

echo "TABLE CREATION FINISHED"