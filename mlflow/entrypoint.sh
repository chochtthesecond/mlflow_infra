#!/bin/bash

if [ ! -z "$MLFLOW_AUTH_USERS" ]; then
  echo "Creating users.conf from environment variable"
  echo "$MLFLOW_AUTH_USERS" | tr ',' '\n' > /app/users.conf
  chmod 600 /app/users.conf
fi

pip install mlflow[auth] > /dev/null 2>&1

mlflow server \
  --backend-store-uri=${STORE_URI} \
  --artifacts-destination=${ARTIFACTS_DESTINATION} \
  --host 0.0.0.0 \
  --port=5000 \
  --config-file /app/mlflow.conf
