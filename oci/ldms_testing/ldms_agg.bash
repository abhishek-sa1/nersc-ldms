#!/bin/bash

/opt/ovis-ldms/sbin/ldmsd -F -x sock:60003 -c ./ldms_agg.conf -a none -v INFO -m 512K -r ./agg.pid

