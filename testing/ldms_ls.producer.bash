#!/bin/bash
/opt/ovis-ldms/sbin/ldms_ls -x sock -h localhost -p 10001  -l -a ovis -A conf=$(pwd)/ldmsauth.conf
