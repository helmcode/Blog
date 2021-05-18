#!/bin/bash
# Autor: Barckcode
# Description: Script to deploy in pro/pre

######################### VARS
# Parameters
ENV=$1

# Binaries
BINARY="/bin"
USR_BINARY="/usr/bin"

# Source
SOURCE_CODE="/var/www/helmcode.com"
SOURCE_CODE_PRE="/var/www/pre_helmcode.com"

# Logs
LOG_PATH="/tmp/deploy.log"
LOG_PATH_PRE="/tmp/deploy_pre.log"

# Commands
DATE="$(date):"

######################### SCRIPT
echo "*********************************************" >> $LOG_PATH
echo $DATE >> $LOG_PATH

# Enviroment validation
if [[ $ENV = "PRO" ]]
then
    cd $SOURCE_CODE
    $USR_BINARY/git checkout main >> $LOG_PATH_PRE
    $USR_BINARY/git checkout . >> $LOG_PATH
    $USR_BINARY/git pull >> $LOG_PATH

    if [[ $? -eq 0 ]]
    then
        echo "$DATE Pull ejecutado con éxito" >> $LOG_PATH
        $USR_BINARY/docker restart flask_app >> $LOG_PATH

        if [[ $? -eq 0 ]]
        then
            echo "$DATE Restart de flask_app ejecutado con éxito" >> $LOG_PATH
            exit 0
        else
            echo "$DATE ERROR - Restart de flask_app ejecutado sin éxito" >> $LOG_PATH
            exit 1
        fi
    else
        echo "$DATE ERROR - Pull ejecutado sin éxito" >> $LOG_PATH
        exit 1
    fi
elif [[ $ENV = "PRE" ]]
    cd $SOURCE_CODE_PRE
    $USR_BINARY/git checkout pre >> $LOG_PATH_PRE
    $USR_BINARY/git checkout . >> $LOG_PATH_PRE
    $USR_BINARY/git pull origin pre >> $LOG_PATH_PRE

    if [[ $? -eq 0 ]]
    then
        echo "$DATE Pull ejecutado con éxito" >> $LOG_PATH_PRE
        $USR_BINARY/docker restart flask_app_pre >> $LOG_PATH_PRE

        if [[ $? -eq 0 ]]
        then
            echo "$DATE Restart de flask_app ejecutado con éxito" >> $LOG_PATH_PRE
            exit 0
        else
            echo "$DATE ERROR - Restart de flask_app ejecutado sin éxito" >> $LOG_PATH_PRE
            exit 1
        fi
    else
        echo "$DATE ERROR - Pull ejecutado sin éxito" >> $LOG_PATH_PRE
        exit 1
    fi
else
    echo "$DATE ERROR - El parámetro indicado no corresponde a ninguno de los entornos disponibles [ PRO / PRE ]" >> $LOG_PATH
    exit 1
fi
