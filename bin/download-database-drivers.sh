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

set -e

POM="$(wget -O- $1)"
POSTGRESQL_VERSION=$(echo $POM | xmlstarlet sel -t -v //_:version.postgresql)

wget -O ${LIB_DIR}/postgresql-${POSTGRESQL_VERSION}.jar "${NEXUS}?r=public&g=org.postgresql&a=postgresql&v=${POSTGRESQL_VERSION}&p=jar"
