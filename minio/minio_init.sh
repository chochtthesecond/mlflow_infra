#!/bin/bash

mc alias set minio $MINIO_URI $MINIO_ROOT_USER $MINIO_ROOT_PASSWORD

BUCKETS=$(mc ls minio)

while read -r p || [ -n "$p" ]; do
  # if ! $BUCKETS | grep --word-regexp --quiet $p; then
  mc mb minio/$p
  # else
  #   echo "bucket $p already exists"
  # fi
done <$BUCKETS_LIST

echo "end init"
