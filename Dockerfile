FROM openjdk:8-jdk-slim

ENV JMETER_VERSION 5.2.1
ENV JMETER_HOME /jmeter/apache-jmeter-${JMETER_VERSION}/
ENV PATH $JMETER_HOME/bin:$PATH
ENV MYSQL_CONNECTOR_VERSION 8.0.15

RUN apt-get update && apt-get -y install wget

RUN mkdir /jmeter
WORKDIR /jmeter

RUN wget https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz && \
    tar -xzf apache-jmeter-$JMETER_VERSION.tgz && \
    rm apache-jmeter-$JMETER_VERSION.tgz && \
    wget https://dev.mysql.com/get/Downloads/Connector/J/mysql-connector-java-${MYSQL_CONNECTOR_VERSION}.tar.gz && \
    tar -xzf mysql-connector-java-${MYSQL_CONNECTOR_VERSION}.tar.gz && \
    rm mysql-connector-java-${MYSQL_CONNECTOR_VERSION}.tar.gz && \
    cp -p mysql-connector-java-${MYSQL_CONNECTOR_VERSION}/mysql-connector-java-${MYSQL_CONNECTOR_VERSION}.jar $JMETER_HOME/lib/ && \
    sed -i.bak -e "s/#server.rmi.ssl.disable=false/server.rmi.ssl.disable=true/" ${JMETER_HOME}/bin/jmeter.properties

COPY entrypoint.sh ${JMETER_HOME}/
RUN chmod +x ${JMETER_HOME}/entrypoint.sh

EXPOSE 6000 1099 50000

ENTRYPOINT ${JMETER_HOME}/entrypoint.sh
