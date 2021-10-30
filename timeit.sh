(time ./main < $0 &>/dev/null) 2>&1 | grep -E "user|sys" | awk '{print $2}' | awk '{split($0,a,"m"); print a[2]}' | awk '{split($0,a,"s"); print a[1]}' | awk '{s+=$1} END {print s}'
