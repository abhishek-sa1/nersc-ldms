#!/bin/sh
export PYTHONPATH=/opt/ovis-ldms/lib/python3.10/site-packages/
HOST="localhost"
PORT="60002"
NOW="$(date +"%Y%m%d-%H%M%S")"
echo "=====================
DATE:$NOW
SCRIPT:$0
HOST:$HOST
PORT:$PORT
====================="
echo "
======================
daemon_status:
======================
"
/opt/ovis-ldms/bin/ldmsd_controller -x sock -h $HOST -p $PORT --cmd daemon_status
echo "
======================
updtr_status summary:
======================
"
/opt/ovis-ldms/bin/ldmsd_controller -x sock -h $HOST -p $PORT --cmd "updtr_status summary"
echo "
===================
prdcr_stats:
===================
"
/opt/ovis-ldms/bin/ldmsd_controller -x sock -h $HOST -p $PORT --cmd prdcr_stats
echo "
===================
strgp_status:
===================
"
/opt/ovis-ldms/bin/ldmsd_controller -x sock -h $HOST -p $PORT --cmd strgp_status
echo "
===================
stream_status:
===================
"
/opt/ovis-ldms/bin/ldmsd_controller -x sock -h $HOST -p $PORT --cmd stream_status
echo "
===================
update_time_stats:
===================
"
/opt/ovis-ldms/bin/ldmsd_controller -x sock -h $HOST -p $PORT --cmd update_time_stats
echo "
===================
thread_stats:
===================
"
/opt/ovis-ldms/bin/ldmsd_controller -x sock -h $HOST -p $PORT --cmd "thread_stats"
echo "
===================
set_stats: (Units: Bytes/sec)
===================
"
/opt/ovis-ldms/bin/ldmsd_controller -x sock -h $HOST -p $PORT --cmd "set_stats"

