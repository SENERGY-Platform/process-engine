FROM camunda/camunda-bpm-platform:tomcat-7.11.0

RUN rm -rf /camunda/webapps/ROOT
RUN rm -rf /camunda/webapps/camunda
RUN rm -rf /camunda/webapps/camunda-invoice
RUN rm -rf /camunda/webapps/camunda-welcome
RUN rm -rf /camunda/webapps/docs
RUN rm -rf /camunda/webapps/examples
RUN rm -rf /camunda/webapps/h2
RUN rm -rf /camunda/webapps/host-manager
RUN rm -rf /camunda/webapps/manager

COPY conf/bpm-platform.xml /camunda/conf/bpm-platform.xml
COPY conf/server.xml /camunda/conf/server_temp.xml
COPY conf/startup.sh /camunda/senergy_startup.sh

USER root
RUN chmod o+w /camunda/conf/server.xml
RUN chmod o+x /camunda/senergy_startup.sh
USER camunda

ENV LIB_DIR ${CATALINA_HOME}/lib/
ENV BIN_DIR ${CATALINA_HOME}/bin/
ENV MAIL_CONFIG ${BIN_DIR}mail-configuration.properties
ENV NEXUS https://app.camunda.com/nexus/repository
ENV MAIL_CONNECTOR ${NEXUS}/camunda-bpm-community-extensions/org/camunda/bpm/extension/camunda-bpm-mail-core/1.2.0/camunda-bpm-mail-core-1.2.0.jar
ENV JAVA_MAIL https://github.com/javaee/javamail/releases/download/JAVAMAIL-1_6_2/javax.mail.jar

# add camunda bpm mail connector
ADD ${MAIL_CONNECTOR} ${LIB_DIR}

# add java mail lib
ADD ${JAVA_MAIL} ${LIB_DIR}

# add mail configurations
ADD conf/mail-configuration.properties ${MAIL_CONFIG}

CMD ["./senergy_startup.sh"]