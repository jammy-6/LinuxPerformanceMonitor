#!/bin/bash

# 检查并重启进程的函数
check_and_restart() {
    local process_name=$1
    local process_cmd=$2

    # 检查进程是否已运行
    if pgrep -f "$process_name" > /dev/null; then
        echo "$process_name 已运行，重启中..."
        pkill -f "$process_name"
    fi

    # 启动进程并忽略输出
    $process_cmd > /dev/null 2>&1 &
    echo $!
}

# 启动第一个后台进程
PID1=$(check_and_restart "rpc_manager/server/server" "./build/rpc_manager/server/server")

# 启动第二个后台进程
PID2=$(check_and_restart "test_monitor/src/monitor" "./build/test_monitor/src/monitor")

# 启动第三个进程
./build/display_monitor/display &
PID3=$!

# 监控进程，如果任意一个进程退出，则退出所有进程
wait -n $PID1 $PID2 $PID3
pkill -P $$