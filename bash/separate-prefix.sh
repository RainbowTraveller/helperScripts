#!/bin/bash
mystring="Staging-jobName"
prefix=${mystring%-*}
echo $prefix
