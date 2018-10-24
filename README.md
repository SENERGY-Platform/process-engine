# SEPL BPM Engine

SEPL BPM engine standalone server based on Apache Tomcat and Camunda BPM Platform with integrated RESTful API

## Camunda
the camunda dependency is replaced with a fork which fixes a bug (github.com/IngoRoessner/camunda-bpm-platform)

## Usage

Start a database container with the following environment variables (e.g. PostgreSQL):
+ POSTGRES_USER=camunda
+ POSTGRES_PASSWORD=camunda
+ POSTGRES_DATABASE=camunda

Edit Dockerfile (preconfigured for PostgreSQL) according to the database to be used:

    ENV DATABASE database_name
    RUN apt-get database_name

Create a new bin/database_name.sh that looks like following (e.g. PostgreSQL):

    #!/bin/sh

    export PGPASSWORD=${DB_PASSWORD}

    echo ">> Waiting for postgres to start"
        WAIT=0
        while ! nc -z db 5432; do
        sleep 1
        WAIT=$(($WAIT + 1))
        if [ "$WAIT" -gt 15 ]; then
            echo "Error: Timeout wating for Postgres to start"
            exit 1
        fi
        done

    echo "CREATE ENGINE TABLES"
    psql -h db -U ${DB_USERNAME} -d ${DB_NAME} -f ${SQL_CREATE_ENGINE}

    echo "CREATE IDENTITY TABLES"
    psql -h db -U ${DB_USERNAME} -d ${DB_NAME} -f ${SQL_CREATE_IDENTITY}`


Make sure that download-database-drivers.sh downloads the appropriate database driver.

Start the tomcat container with the following environment variables (e.g. PostgreSQL):
+ DB_DRIVER=org.postgresql.Driver
+ DB_URL=jdbc:postgresql://db:5432/camunda
+ DB_USERNAME=camunda
+ DB_PASSWORD=camunda
+ DB_NAME=camunda
+ GMAIL_USER=user@gmail.com
+ GMAIL_PW=password

Test:

    http://127.0.0.1:8080/engine-rest/engine