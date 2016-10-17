FROM mhart/alpine-node:6
MAINTAINER Apigee Link

ADD     . /
WORKDIR /
RUN     npm install

CMD        ["server.js"]
ENTRYPOINT ["node"] 
