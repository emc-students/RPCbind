ip netns add a
ip netns add b
echo "Namespaces a and b created"

brctl addbr br-test
brctl stp br-test off
ip link set dev br-test up
echo "Bridge added"

ip link add veth1 type veth peer name br1
ip link add veth2 type veth peer name br2
echo "Veth1-br1 and veth2-br2 added"

brctl addif br-test br1
brctl addif br-test br2  
echo "Br1 and br2 added to bridge"


ip link set veth1 netns a
ip link set veth2 netns b
echo "veth1 added to NS a, veth2 added to NS b"

ip addr add 192.168.0.40/24 dev br-test 
ip netns exec a ip addr add 192.168.0.41/24 dev veth1
ip netns exec b ip addr add 192.168.0.42/24 dev veth2
echo "Set IP-addresses:"
echo "bridge 192.168.0.40"
echo "br1    192.168.0.41"
echo "br2    192.168.0.42"

ip netns exec a ip link set veth1 up
ip netns exec b ip link set veth2 up
ip netns exec a ip link set lo up
ip netns exec b ip link set lo up

echo "Network successfuly created                    "
echo "                                               "
echo "                              _______________  "
echo "                             | NS a         |  " 
echo "                             |              |  "
echo "                  |br1|------|veth1         |  "
echo "                  |          |              |  "
echo "                  |          ----------------  "
echo " eth0 -- br-test--            _______________  "
echo "                  |          | NS a         |  "
echo "                  |          |              |  "
echo "                  |br2|------|veth2         |  "
echo "                             |              |  "
echo "                             ----------------  "

