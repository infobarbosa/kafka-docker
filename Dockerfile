#imagem do kafka em ubuntu 16.04
FROM openjdk:8-alpine

MAINTAINER Barbosa <infobarbosa@yahoo.com.br>

ARG MIRROR=http://apache.mirrors.pair.com
ARG SCALA_VERSION=2.12
ARG KAFKA_VERSION=0.10.2.1
ARG KAFKA_ARTIFACT=kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz
ENV KAFKA_HOME=/opt/kafka

LABEL name="kafka" version=$VERSION

RUN apk add --no-cache wget bash \
    && mkdir /opt \
    && mkdir /kafka-starter \
    && wget -q -O - $MIRROR/kafka/"$KAFKA_VERSION"/$KAFKA_ARTIFACT | tar -xzf - -C /opt \
    && mv /opt/kafka_$SCALA_VERSION-$KAFKA_VERSION $KAFKA_HOME

COPY start.sh /kafka-starter/

RUN chmod +x /kafka-starter/start.sh

EXPOSE 9092

CMD ["/kafka-starter/start.sh"]
