if [[ -z "${CAMUNDA_APP_PASSWORD}" ]]; then
  curl --fail-with-body http://localhost:8080/engine-rest/incident/count
else
  curl --fail-with-body http://camunda:$CAMUNDA_APP_PASSWORD@localhost:8080/engine-rest/incident/count
fi
