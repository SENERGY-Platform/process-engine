#!/bin/bash

rm -f /camunda/conf/server.xml
cp /camunda/conf/server_temp.xml /camunda/conf/server.xml

./camunda.sh