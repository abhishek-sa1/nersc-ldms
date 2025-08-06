#!/bin/bash

/opt/ovis-ldms/sbin/ldmsd -F -x sock:60002 -c ./ldms_sampler.conf -a none -v INFO -m 512K -r ./sampler.pid

