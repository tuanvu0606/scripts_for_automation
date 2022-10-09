#!/bin/bash

function Get_CurrentTime()
{
    local CURRENT_TIME=$(date +$1)
    echo $CURRENT_TIME
}

# TODO: we need to treat this time format as a data section, next step is to move this to the implementation place
TIME_FORMAT="%H%M%S%d%m%Y"
result=$(Get_CurrentTime $TIME_FORMAT)
echo $result