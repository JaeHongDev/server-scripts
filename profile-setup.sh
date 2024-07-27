#!/bin/bash

msg_write(){ 
	echo ""
	echo "==========================================="
	echo "$1"
	echo "==========================================="
	echo ""
}



read -p "input session timeout: " TIME_OUT

if ! echo "$TIME_OUT" | grep -qE '^[0-9]+$'; then
	echo "시간 입력은 숫자만 가능해요"
	exit 1
fi

read -p "server name: " USERNAME


PROFILE_PATH="~/.profile"
BASHRC_PATH="~/.bashrc"



echo 'HISTTIMEFORMAT="%F %T -- "' >> "$PROFILE_PATH"
echo 'export HISTTIMEFORMAT' >> "$PROFILE_PATH"
echo "export TMOUT=$TIME_OUT" >> "$PROFILE_PATH"

source "$PROFILE_PATH"

msg_write "write session timeout"

echo "PS1='[\e[1;31m$USERNAME\e[0m][\e[1;32m\t\e[0m][\e[1;33m\u\e[0m@\e[1;36m\h\e[0m \w] \n\$ \[\033[00m\]'" >> "$BASHRC_PATH"

echo "tty=`tty | awk -F"/dev/" '{print $2}'`" >> "$BASHRC_PATH"
echo "IP=`w | grep "$tty" | awk '{print $3}'`" >> "$BASHRC_PATH"
echo "export PROMPT_COMMAND='logger -p local0.debug "[USER]$(whoami) [IP]$IP [PID]$$ [PWD]`pwd` [COMMAND] $(history 1 | sed "s/^[ ]*[0-9]\+[ ]*//" )"'" >> "$BASHRC_PATH"

source "$BASHRC_PATH"


# rsyslog 설정 파일 경로
RSYSLOG_CONF="/etc/rsyslog.d/50-default.conf"

# 추가할 로그 설정
LOG_SETTING="local0.* /var/log/command.log"

# 설정 파일에 로그 설정 추가
echo "$LOG_SETTING" >> "$RSYSLOG_CONF"

# rsyslog 서비스 재시작
service rsyslog restart


