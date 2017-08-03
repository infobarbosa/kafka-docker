#Comando DOCKER RUN
docker run -d \
       --net bigdata \
       --ip 172.18.0.4 \
       --name kafka \
       infobarbosa/kafka:standalone 

