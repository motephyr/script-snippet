#!/bin/bash

/usr/local/Cellar/tomcat/7.0.29/bin/catalina stop
apachectl -k stop

#su - ihergo -c '/opt/local/lib/postgresql84/bin/pg_ctl -D /opt/local/var/db/postgresql84/ihergo stop'
#su - postgres -c '/opt/local/lib/postgresql84/bin/pg_ctl -D /opt/local/var/db/postgresql84/dido stop'
#su postgres -c '/opt/local/lib/postgresql84/bin/pg_ctl -D /opt/local/var/db/postgresql84/dido -m fast stop'

su - motephyr -c '/usr/local/bin/pg_ctl -D /usr/local/var/postgres stop -s -m fast'
