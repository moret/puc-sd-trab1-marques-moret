#!/bin/sh

echo 15-1
lua -e "simultaneous_clients = 15" -e "serv_addr = '10.0.2.18'" multi_client.lua > moret-servmono-cli15-run1.log
echo 15-2
lua -e "simultaneous_clients = 15" -e "serv_addr = '10.0.2.18'" multi_client.lua > moret-servmono-cli15-run2.log
echo 15-3
lua -e "simultaneous_clients = 15" -e "serv_addr = '10.0.2.18'" multi_client.lua > moret-servmono-cli15-run3.log

echo 10-1
lua -e "simultaneous_clients = 10" -e "serv_addr = '10.0.2.18'" multi_client.lua > moret-servmono-cli10-run1.log
echo 10-2
lua -e "simultaneous_clients = 10" -e "serv_addr = '10.0.2.18'" multi_client.lua > moret-servmono-cli10-run2.log
echo 10-3
lua -e "simultaneous_clients = 10" -e "serv_addr = '10.0.2.18'" multi_client.lua > moret-servmono-cli10-run3.log

echo 5-1
lua -e "simultaneous_clients = 5" -e "serv_addr = '10.0.2.18'" multi_client.lua > moret-servmono-cli5-run1.log
echo 5-2
lua -e "simultaneous_clients = 5" -e "serv_addr = '10.0.2.18'" multi_client.lua > moret-servmono-cli5-run2.log
echo 5-3
lua -e "simultaneous_clients = 5" -e "serv_addr = '10.0.2.18'" multi_client.lua > moret-servmono-cli5-run3.log

echo 1-1
lua -e "simultaneous_clients = 1" -e "serv_addr = '10.0.2.18'" multi_client.lua > moret-servmono-cli1-run1.log
echo 1-2
lua -e "simultaneous_clients = 1" -e "serv_addr = '10.0.2.18'" multi_client.lua > moret-servmono-cli1-run2.log
echo 1-3
lua -e "simultaneous_clients = 1" -e "serv_addr = '10.0.2.18'" multi_client.lua > moret-servmono-cli1-run3.log



