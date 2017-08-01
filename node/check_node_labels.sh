#!/bin/bash 

docker node inspect `hostname` |grep -A 5 Labels
