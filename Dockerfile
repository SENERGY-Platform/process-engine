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
COPY conf/tomcat-users.xml /camunda/conf/tomcat-users_templ.xml
COPY conf/web.xml /camunda/conf/web_templ.xml
COPY conf/web_without_auth.xml /camunda/conf/web_without_auth.xml
COPY conf/logging.properties /camunda/conf/logging.properties
COPY conf/startup.sh /camunda/senergy_startup.sh

USER root
RUN chmod a+rw /camunda/conf/server.xml
RUN chmod a+rw /camunda/conf/server_temp.xml
RUN chmod a+rw /camunda/conf/tomcat-users_templ.xml
RUN chmod a+rw /camunda/conf/web_templ.xml
RUN chmod a+rw /camunda/conf/web_without_auth.xml
RUN chmod a+rw /camunda/conf/logging.properties
RUN chmod a+x /camunda/senergy_startup.sh
USER camunda

ENV JAVA_TOOL_OPTIONS="-Dlog4j.formatMsgNoLookups=true"
ENV LIB_DIR /camunda/lib/
ENV BIN_DIR /camunda/bin/
ENV MAIL_CONFIG ${BIN_DIR}mail-configuration.properties
ENV MAIL_CONFIG_TEMPL ${BIN_DIR}mail-configuration.properties.templ
ENV NEXUS https://app.camunda.com/nexus/repository
ENV MAIL_CONNECTOR ${NEXUS}/camunda-bpm-community-extensions/org/camunda/bpm/extension/camunda-bpm-mail-core/1.2.0/camunda-bpm-mail-core-1.2.0.jar
ENV JAVA_MAIL https://github.com/javaee/javamail/releases/download/JAVAMAIL-1_6_2/javax.mail.jar

# add camunda bpm mail connector
ADD ${MAIL_CONNECTOR} ${LIB_DIR}

# add java mail lib
ADD ${JAVA_MAIL} ${LIB_DIR}

# add mail configurations
ADD conf/mail-configuration.properties ${MAIL_CONFIG_TEMPL}
ADD conf/mail-configuration.properties ${MAIL_CONFIG}

USER root
RUN chmod a+r /camunda/lib/camunda-bpm-mail-core-1.2.0.jar
RUN chmod a+r /camunda/lib/javax.mail.jar
RUN chmod a+rw ${MAIL_CONFIG}
RUN chmod a+rw ${MAIL_CONFIG_TEMPL}
USER camunda



CMD ["./senergy_startup.sh"]