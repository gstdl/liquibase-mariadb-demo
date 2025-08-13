#!/bin/bash


# update the database expected state, if it fails exit, otherwise store total change sets in variable
liquibase --defaults-file=liquibase.properties update || exit 1

# check for liquibase history and count number of implemented changes, store the count result
count=$(liquibase --defaults-file=liquibase.properties history | grep changelog/ | wc -l)

# for every count rollback the changes, if it fails exit
for i in $(seq 1 $count); do
    liquibase --defaults-file=liquibase.properties rollback-count --count=$i || exit 1
    # re-update the database, if it fails exit
    liquibase --defaults-file=liquibase.properties update  || exit 1
done
