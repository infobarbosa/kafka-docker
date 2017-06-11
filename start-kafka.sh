#montagem do arquivo server.properties
. /kafka-starter/server-properties.sh

#inicializando o kafka (parte do pressuposto de que o zookeeper já está em execuçao em outra máquina)
cd $KAFKA_HOME

bin/kafka-server-start.sh config/server.properties

