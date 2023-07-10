if [[ -z "${CAMUNDA_APP_PASSWORD}" ]]; then
  curl --fail http://localhost:8080/engine-rest/incident/count
else
  curl --fail http://camunda:$CAMUNDA_APP_PASSWORD@localhost:8080/engine-rest/incident/count
fi
