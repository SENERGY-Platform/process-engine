FROM tomcat:9-jre8

ENV CAMUNDA_VERSION "7.9.0-SNAPSHOT"
ENV CAMUNDA_V 7.9.0
ENV SERVER tomcat
ENV DATABASE postgres
ENV LIB_DIR ${CATALINA_HOME}/lib/
ENV BIN_DIR ${CATALINA_HOME}/bin/
ENV MAIL_CONFIG ${BIN_DIR}mail-configuration.properties
ENV CONF_DIR ${CATALINA_HOME}/conf/
ENV SERVER_CONFIG ${CATALINA_HOME}/conf/server.xml
ENV WEBAPP_DIR ${CATALINA_HOME}/webapps
ENV SQL_CREATE_ENGINE /tmp/sql/create/${DATABASE}_engine_${CAMUNDA_VERSION}.sql
ENV SQL_CREATE_IDENTITY /tmp/sql/create/${DATABASE}_identity_${CAMUNDA_VERSION}.sql
ENV NEXUS https://app.camunda.com/nexus/service/local/artifact/maven/redirect
ENV MAIL_CONNECTOR https://app.camunda.com/nexus/service/local/repositories/camunda-bpm-community-extensions/content/org/camunda/bpm/extension/camunda-bpm-mail-core/1.0.0/camunda-bpm-mail-core-1.0.0.jar
ENV JAVA_MAIL http://java.net/projects/javamail/downloads/download/javax.mail.jar

#install xmlstarlet, postgresql, and netcat
RUN apt-get update && \
    apt-get -y install --no-install-recommends xmlstarlet postgresql netcat && \
    apt-get clean && \
    rm -rf /var/cache/* /var/lib/apt/lists/*

# add camunda tomcat distro
#ADD ${NEXUS}?r=camunda-bpm&g=org.camunda.bpm.tomcat&a=camunda-bpm-tomcat&v=${CAMUNDA_VERSION}&e=tar.gz /tmp/camunda-tomcat.tar.gz
COPY ./dependencies/camunda-bpm-tomcat-${CAMUNDA_VERSION}.tar.gz /tmp/camunda-tomcat.tar.gz

# unpack camunda libraries
RUN tar xzf /tmp/camunda-tomcat.tar.gz lib/ -C ${LIB_DIR}

# add camunda bpm mail connector
ADD ${MAIL_CONNECTOR} ${LIB_DIR}

# add java mail lib
ADD ${JAVA_MAIL} ${LIB_DIR}

# add mail configurations
ADD conf/mail-configuration.properties ${MAIL_CONFIG}
    
# add camunda engine REST API
#ADD ${NEXUS}?r=camunda-bpm&g=org.camunda.bpm&a=camunda-engine-rest&v=${CAMUNDA_VERSION}&e=war&c=${SERVER} ${WEBAPP_DIR}/engine-rest.war
COPY ./dependencies/camunda-engine-rest-${CAMUNDA_VERSION}-tomcat.war ${WEBAPP_DIR}/engine-rest.war


# extract REST API war
RUN unzip ${WEBAPP_DIR}/engine-rest.war -d ${WEBAPP_DIR}/engine-rest

# remove REST API war
RUN rm ${WEBAPP_DIR}/engine-rest.war

# add filter for CORS
ADD conf/web.xml ${WEBAPP_DIR}/engine-rest/WEB-INF

# add bpm engine config
ADD conf/bpm-platform.xml ${CONF_DIR}

# add server config
ADD conf/server.xml ${SERVER_CONFIG}

# add scripts
ADD bin/* /usr/local/bin/

# add database drivers
RUN /usr/local/bin/download-database-drivers.sh "https://app.camunda.com/nexus/content/repositories/camunda-bpm/org/camunda/bpm/camunda-database-settings/${CAMUNDA_V}/camunda-database-settings-${CAMUNDA_V}.pom"

WORKDIR /tmp

# unpack sql files
RUN tar xzf /tmp/camunda-tomcat.tar.gz sql/

WORKDIR ${CATALINA_HOME}

EXPOSE 8080
EXPOSE 465

CMD ["/usr/local/bin/configure-and-start.sh"]