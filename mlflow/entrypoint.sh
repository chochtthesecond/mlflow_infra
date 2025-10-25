#!/bin/bash

mlflow server \
  --backend-store-uri=${STORE_URI} \
  --artifacts-destination=${ARTIFACTS_DESTINATION} \
  --host 0.0.0.0 \
  --port=5000
