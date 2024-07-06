#!/bin/bash

# Define the stack name
STACK_NAME=${1}

# Get the name of the first service in the stack
FIRST_SERVICE=$(docker service ls --filter label=com.docker.stack.namespace=$STACK_NAME --format "{{.Name}}" | head -n 1)

if [ -z "$FIRST_SERVICE" ]; then
  echo "No services found in stack $STACK_NAME."
  exit 1
fi

# Get the creation time of the first service
CREATION_TIME=$(docker service inspect --format '{{.CreatedAt}}' $FIRST_SERVICE)
echo "Creation time is: $CREATION_TIME"
# Preprocess the date string to remove nanoseconds and timezone
CREATION_TIME=$(echo $CREATION_TIME | sed 's/\.[0-9]* .*//')

if [ -z "$CREATION_TIME" ]; then
  echo "Could not retrieve creation time for service $FIRST_SERVICE."
  exit 1
fi

# Convert the creation time to a timestamp
CREATION_TIMESTAMP=$(date -d "$CREATION_TIME" +%s)

# Get the current time as a timestamp
CURRENT_TIMESTAMP=$(date +%s)

# Calculate the running time in seconds
RUNNING_TIME=$((CURRENT_TIMESTAMP - CREATION_TIMESTAMP))
echo "RUNNING_TIME is: ${RUNNING_TIME}"

# Convert running time to a human-readable format
DAYS=$((RUNNING_TIME / 86400))
HOURS=$(( (RUNNING_TIME % 86400) / 3600 ))
MINUTES=$(( (RUNNING_TIME % 3600) / 60 ))
SECONDS=$(( RUNNING_TIME % 60 ))

echo "Stack $STACK_NAME has been running for: $DAYS days, $HOURS hours, $MINUTES minutes, $SECONDS seconds"

exit 0

# Running Example
# ./Get_DockerStackRunningTime.sh "your_stack_name"