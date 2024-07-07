#!/bin/bash
# Declare and load varaibles
echo "Loading variables..."
DOCKER_SWARM_STACK_TIME_LIMIT=$ENV_DOCKER_SWARM_STACK_TIME_LIMIT

for stack in $(docker stack ls --format '{{.Name}}' | awk 'length($0) == 6'); do
  echo "Processing stack: $stack"
  # Add your commands here to perform operations on each stack
  # For example, you could inspect the stack:
  docker stack ps $stack
  # Or remove the stack:
  # docker stack rm $stack
  STACK_RUNNING_TIME=$(./Get_DockerStackRunningTime.sh $stack  | grep RUNNING_TIME | awk '{print $3}')

  if [ $STACK_RUNNING_TIME -gt $DOCKER_SWARM_STACK_TIME_LIMIT ]; then
    echo "the running time for $stack is $STACK_RUNNING_TIME which is greater than $DOCKER_SWARM_STACK_TIME_LIMIT"
    docker stack rm $stack
  else
    echo "the running time for $stack is $STACK_RUNNING_TIME which is lower than $DOCKER_SWARM_STACK_TIME_LIMIT"
    echo "doing nothing..."
  fi
done
