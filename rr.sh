#!/bin/bash
# save as: monitor_rtpengine.sh
OUT=rtpengine.log
TS=$(date -u +%Y-%m-%dT%H:%M:%SZ)

# session + port count directly from rtpengine's control port
echo "$TS" >> $OUT
echo "list totals" | nc -u -w1 172.22.0.16 2224 >> $OUT 2>&1
echo "list sessions" | nc -u -w1 172.22.0.16 2224 | wc -l >> $OUT 2>&1

# actual UDP sockets rtpengine process holds in the 30000-50000 range
PID=$(docker inspect -f '{{.State.Pid}}' rtpengine 2>/dev/null)
if [ -n "$PID" ]; then
  COUNT=$(nsenter -t "$PID" -n ss -uan 2>/dev/null | awk '{split($5,a,":"); if (a[2]+0 >= 30000 && a[2]+0 <= 50000) print}' | wc -l)
  echo "$TS rtpengine_udp_sockets_in_range=$COUNT / 20000" >> $OUT
fi
