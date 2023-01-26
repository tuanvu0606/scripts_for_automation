#!/bin/bash

# This script does getting time with a format passed as the second argument
# Example: Get_CurrentTime "%y%m%d%H%M%S"

function Get_CurrentTime()
{
    local CURRENT_TIME=$(date +$1)
    echo $CURRENT_TIME
}
