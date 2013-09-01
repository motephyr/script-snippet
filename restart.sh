#!/bin/bash

/usr/local/Cellar/tomcat/7.0.29/bin/catalina stop

su motephyr -c 'cd /Users/tomcat/spring-mvc-demo;mvn install'
#su motephyr -c 'cd /Users/tomcat/ihergoAppServer;mvn install'

apachectl -k graceful

/usr/local/Cellar/tomcat/7.0.29/bin/catalina start
tail -f  /usr/local/Cellar/tomcat/7.0.29/libexec/logs/catalina.out
