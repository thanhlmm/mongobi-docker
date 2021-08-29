# Start from fresh debian stretch & add some tools
# note: rsyslog & curl (openssl,etc) needed as dependencies too
FROM ubuntu 

# Setup default environment variables
ENV TZ="Asia/ho_chi_minh"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ENV MONGODB_CONNECTURI localhost
ENV MONGODB_USER user
ENV MONGODB_PASSWORD password
ENV LISTEN_PORT 3307

RUN apt update
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata
RUN apt install -y rsyslog nano curl lsb

# Download BI Connector to /mongosqld
WORKDIR /tmp
RUN curl https://info-mongodb-com.s3.amazonaws.com/mongodb-bi/v2/mongodb-bi-linux-x86_64-ubuntu2004-v2.14.3.tgz -o bi-connector.tgz && \
  tar -xvzf bi-connector.tgz && rm bi-connector.tgz && \
  mv /tmp/mongodb-bi-linux-x86_64-ubuntu2004-v2.14.3 /mongosqld

# SSL KEY
RUN openssl req -x509 -nodes -days 365 -subj "/C=CA/ST=QC/O=Company, Inc./CN=n8n.cuthanh.com" -addext "subjectAltName=DNS:n8n.cuthanh.com" -newkey rsa:2048 -out certificate.pem  -keyout key.pem
RUN cat key.pem certificate.pem > mongo.pem

# Start Everything
# note: we need to use sh -c "command" to make rsyslog running as deamon too
RUN service rsyslog start
CMD sh -c "/mongosqld/bin/mongosqld --logPath /var/log/mongosqld.log --mongo-ssl --mongo-uri $MONGODB_CONNECTURI --auth -u $MONGODB_USER -p $MONGODB_PASSWORD --addr 0.0.0.0:$LISTEN_PORT  --sslMode requireSSL --sslPEMKeyFile mongo.pem"
