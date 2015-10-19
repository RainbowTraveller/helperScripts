#!/bin/bash

for i in $( ls error_log-* );
do
    cat $i >> error_log_union
done
