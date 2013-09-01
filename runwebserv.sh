#!/bin/bash

# sudo su ihergo -c '/opt/local/lib/postgresql84/bin/pg_ctl -D /opt/local/var/db/postgresql84/ihergo start'
# cd /opt/local/lib/postgresql84/bin
# cd /opt/local/share/java/tomcat6/bin
# cd /opt/local/apache2/bin 
# tail -f  /opt/local/share/java/tomcat6/logs/catalina.out

#su postgres -c '/opt/local/lib/postgresql84/bin/pg_ctl -D /opt/local/var/db/postgresql84/dido start'
#su - postgres '/opt/local/lib/postgresql84/bin/pg_ctl -D /opt/local/var/db/postgresql84/dido start'
#su - ihergo -c '/opt/local/lib/postgresql84/bin/pg_ctl -D /opt/local/var/db/postgresql84/ihergo start'

su - motephyr -c '/usr/local/bin/pg_ctl -D /usr/local/var/postgres start'

apachectl -k graceful 
if [ $? ];
then
  /usr/local/Cellar/tomcat/7.0.29/bin/catalina start
  tail -f  /usr/local/Cellar/tomcat/7.0.29/libexec/logs/catalina.out
fi
