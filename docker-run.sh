#Comando DOCKER RUN
docker run -d \
       --net bigdata \
       --ip 172.18.0.4 \
       --env ZOOKEEPER_CONNECT="172.18.0.3:2181" \
       --name kafka \
       infobarbosa/kafka:standalone 

