Данная конфигурация работает для следующей схемы
                                               
                              _______________  
                             | NS a         |  
                             |              |  
                  |br1|------|veth1         |  
                  |          |              |  
                  |          ----------------  
 eth0 -- br-test--            _______________  
                  |          | NS a         |  
                  |          |              |  
                  |br2|------|veth2         |  
                             |              |  
                             ----------------  

Все команды выполняются от имени администратора(!)
1. Сконфигурировать сеть командой
./network_configure.sh

2. Запустить rpcbind в имеющихся неймспейсах
./startrpc.sh a
./startrpc.sh b

3. Командой make собрать файлы клиента-сервера и поместить бинарные файлы в текущую рабочую папку
https://github.com/emc-students/rpcbind/tree/master/RPC_serv_clnt_source

4. Для каждого namespace открыть отдельную консоль и запустить в ней экземпляр сервера
NS a:

sudo ip netns exec a bash
./server

NS b:

sudo ip netns exec b bash
./server

5. Из default-namespace проверить подключение клиента к серверу в NS a
./client 192.168.0.41 "Msg for NS a"

6. Из default-namespace проверить подключение клиента к серверу в NS b
./client 192.168.0.42 "Msg for NS b"