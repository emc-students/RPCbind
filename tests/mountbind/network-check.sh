#!/bin/bash

echo "Cheking ping to NS a"
ping -c 3 192.168.1.11

echo "Checking ping to NS b"
ping -c 3 192.168.2.13

echo "Checking ping from NS a to default"
ip netns exec a ping -c 3 192.168.1.10

echo "Checking ping from NS b to default"
ip netns exec b ping -c 3 192.168.2.12