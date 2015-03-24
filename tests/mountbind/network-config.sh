#!/bin/bash

echo "Adding namespaces a, b"
ip netns add a
ip netns add b

echo "Adding pairs of veth-s"
ip link add veth1 type veth peer name veth2
ip link add veth3 type veth peer name veth4

echo "Set veth2 to ns a, veth 4 to ns b"
ip link set veth2 netns a
ip link set veth4 netns b

echo "Set ip address 192.168.1.10/24 dev veth1"
ip addr add 192.168.1.10/24 dev veth1
echo "Set ip address 192.168.2.12/24 dev veth3"
ip addr add 192.168.2.12/24 dev veth3

echo "Set ip addresses to veth2/veth4"
ip netns exec a ip addr add 192.168.1.11/24 dev veth2
ip netns exec b ip addr add 192.168.2.13/24 dev veth4

echo "Set lo up"
ip netns exec a ip link set lo up
ip netns exec b ip link set lo up

echo "Set veth2/veth4 up"
ip netns exec a ip link set veth2 up
ip netns exec b ip link set veth4 up

echo "Set veth1/veth3 up"
ip link set veth1 up
ip link set veth3 up

"Network configuration complite!"