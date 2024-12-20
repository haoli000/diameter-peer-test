#!/bin/bash

# Start three instances of freeDiameter
/usr/bin/freeDiameterd -c /conf/freeDiameter1.conf -ddd > /tmp/log1.txt 2>&1 &
PID1=$!
sleep 1

/usr/bin/freeDiameterd -c /conf/freeDiameter2.conf -ddd > /tmp/log2.txt 2>&1 &
PID2=$!
sleep 1

/usr/bin/freeDiameterd -c /conf/freeDiameter3.conf -ddd > /tmp/log3.txt 2>&1 &
PID3=$!

# Wait for 5 seconds
echo "=== Run 3 instances of freeDiameterd for 5s ==="
sleep 5

# Terminate the processes
kill $PID1 $PID2 $PID3

# Output logs to stdout
echo "=== Logs from Instance 1 ==="
cat /tmp/log1.txt
echo "=== Logs from Instance 2 ==="
cat /tmp/log2.txt
echo "=== Logs from Instance 3 ==="
cat /tmp/log3.txt
