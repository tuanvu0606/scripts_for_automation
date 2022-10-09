#!/bin/bash

function Get_CurrentTime()
{
    local CURRENT_TIME=$(date +$1)
    echo $CURRENT_TIME
}