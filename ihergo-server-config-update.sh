#!/bin/bash
# ==============================================================
# About:
#        Update ihergo configs like web.xml, IhergoConstants.java and hibernate.cfg.xml...
#
# ==============================================================
# History
# When          Who       What
# 2011/03/14    Youchen   File created
#
# ==============================================================

IHERGO_PATH=$1
TYPE=$2
TODAY=`date +%Y%m%d%H`

show_usage()
{
	echo "Usage: ${0##*/} <path to ihergo httproot> <production/development/unstable>"
}


if [ $# -ne 2 ]; then
	show_usage
	exit 0
fi

if [ -z "$IHERGO_PATH" ];then
	show_usage
	exit 0
fi

if [ ! -d "$IHERGO_PATH" ]; then
	show_usage
	exit 1
fi
FILE_WEB_XML=$IHERGO_PATH/WEB-INF/web.xml

FILE_HIBERNATE_CFG=$IHERGO_PATH/WEB-INF/src/hibernate.cfg.xml
FILE_HIBERNATE_MAIL_CFG=$IHERGO_PATH/WEB-INF/src/hibernateMail.cfg.xml
FILE_HIBERNATE_SEARCH_CFG=$IHERGO_PATH/WEB-INF/src/hibernateSearch.cfg.xml
FILE_HIBERNATE_REPORT_CFG=$IHERGO_PATH/WEB-INF/src/hibernateReport.cfg.xml
FILE_HIBERNATE_PROJECT_CFG=$IHERGO_PATH/WEB-INF/src/hibernateProject.cfg.xml
FILE_HIBERNATE_BONUS_CFG=$IHERGO_PATH/WEB-INF/src/hibernateBonus.cfg.xml

FILE_IHERGO_CONSTANTS_JAVA=$IHERGO_PATH/WEB-INF/src/tw/com/click/ihergo/util/IhergoConstants.java


remove_master()
{
	sed -i '/\[MASTER_ONLY:START\]/,/\[MASTER_ONLY:END\]/d' $FILE_WEB_XML
}

remove_slave()
{
	sed -i '/\[SLAVE_ONLY:START\]/,/\[SLAVE_ONLY:END\]/d' $FILE_WEB_XML
}

remove_local()
{
	# Remove local db settings
	sed -i '/\[LOCAL_DB_CONNECTION_IHERGO:START\]/,/\LOCAL_DB_CONNECTION_IHERGO:END\]/d' $FILE_HIBERNATE_CFG
	sed -i '/\[LOCAL_DB_CONNECTION_IHERGO_MAIL:START\]/,/\LOCAL_DB_CONNECTION_IHERGO_MAIL:END\]/d' $FILE_HIBERNATE_MAIL_CFG
	sed -i '/\[LOCAL_DB_CONNECTION_IHERGO_SEARCH:START\]/,/\LOCAL_DB_CONNECTION_IHERGO_SEARCH:END\]/d' $FILE_HIBERNATE_SEARCH_CFG
	sed -i '/\[LOCAL_DB_CONNECTION_IHERGO_REPORT:START\]/,/\LOCAL_DB_CONNECTION_IHERGO_REPORT:END\]/d' $FILE_HIBERNATE_REPORT_CFG
                sed -i '/\[LOCAL_DB_CONNECTION_IHERGO_PROJECT:START\]/,/\LOCAL_DB_CONNECTION_IHERGO_PROJECT:END\]/d' $FILE_HIBERNATE_PROJECT_CFG
       sed -i '/\[LOCAL_DB_CONNECTION_IHERGO_BONUS:START\]/,/\LOCAL_DB_CONNECTION_IHERGO_BONUS:END\]/d' $FILE_HIBERNATE_BONUS_CFG

	# Remove local constants
	sed -i '/\[LOCAL_CONSTANT_PATH:START\]/,/\[LOCAL_CONSTANT_PATH:END\]/d' $FILE_IHERGO_CONSTANTS_JAVA
	sed -i '/\[LOCAL_CONSTANT_CONFIG:START\]/,/\[LOCAL_CONSTANT_CONFIG:END\]/d' $FILE_IHERGO_CONSTANTS_JAVA
}

update_production()
{
	# Insert DB Settings
	sed -i '/\[PRODUCTION_DB_CONNECTION_IHERGO:START\]/a \
        <property name="connection.url">jdbc:postgresql://192.168.1.100:5432/ihergo?useUnicode=true&amp;characterEncoding=UTF-8&amp;autoReconnect=true</property> \
        <property name="connection.username">ihergo</property> \
        <property name="connection.password">ihergo382</property>' $FILE_HIBERNATE_CFG

	sed -i '/\[PRODUCTION_DB_CONNECTION_IHERGO_MAIL:START\]/a \
        <property name="connection.url">jdbc:postgresql://192.168.1.110:5432/ihergoMail?useUnicode=true&amp;characterEncoding=UTF-8&amp;autoReconnect=true</property> \
        <property name="connection.username">ihergo</property> \
        <property name="connection.password">ihergo382</property>' $FILE_HIBERNATE_MAIL_CFG

	sed -i '/\[PRODUCTION_DB_CONNECTION_IHERGO_SEARCH:START\]/a \
        <property name="connection.url">jdbc:postgresql://192.168.1.120:5432/ihergoSearch?useUnicode=true&amp;characterEncoding=UTF-8&amp;autoReconnect=true</property> \
        <property name="connection.username">ihergo</property> \
        <property name="connection.password">ihergo382</property>' $FILE_HIBERNATE_SEARCH_CFG

	sed -i '/\[PRODUCTION_DB_CONNECTION_IHERGO_REPORT:START\]/a \
        <property name="connection.url">jdbc:postgresql://192.168.1.120:5432/ihergoReport?useUnicode=true&amp;characterEncoding=UTF-8&amp;autoReconnect=true</property> \
        <property name="connection.username">ihergo</property> \
        <property name="connection.password">ihergo382</property>' $FILE_HIBERNATE_REPORT_CFG

       sed -i '/\[PRODUCTION_DB_CONNECTION_IHERGO_PROJECT:START\]/a \
        <property name="connection.url">jdbc:postgresql://192.168.1.120:5432/ihergoProject?useUnicode=true&amp;characterEncoding=UTF-8&amp;autoReconnect=true</property> \
        <property name="connection.username">ihergo</property> \
        <property name="connection.password">ihergo382</property>' $FILE_HIBERNATE_PROJECT_CFG

                sed -i '/\[PRODUCTION_DB_CONNECTION_IHERGO_BONUS:START\]/a \
        <property name="connection.url">jdbc:postgresql://192.168.1.120:5432/ihergoBonus?useUnicode=true&amp;characterEncoding=UTF-8&amp;autoReconnect=true</property> \
        <property name="connection.username">ihergo</property> \
        <property name="connection.password">ihergo382</property>' $FILE_HIBERNATE_BONUS_CFG



	# Remove comments, to make constants available.
	sed -i '/\[PRODUCTION_CONSTANT_PATH:START\]/d' $FILE_IHERGO_CONSTANTS_JAVA
	sed -i '/\[PRODUCTION_CONSTANT_PATH:END\]/d' $FILE_IHERGO_CONSTANTS_JAVA
                
              # Add JS_VERSION
	sed -i '/\[PRODUCTION_CONSTANT_CONFIG:START\]/d' $FILE_IHERGO_CONSTANTS_JAVA
        sed -i "/\[PRODUCTION_CONSTANT_CONFIG:END\]/a \  public final static int JS_VERSION = $TODAY;" $FILE_IHERGO_CONSTANTS_JAVA
	sed -i '/\[PRODUCTION_CONSTANT_CONFIG:END\]/d' $FILE_IHERGO_CONSTANTS_JAVA

	sed -i 's/<property name="c3p0\.min_size">5<\/property>/<property name="c3p0.min_size">80<\/property>/' $FILE_HIBERNATE_CFG
	sed -i 's/<property name="c3p0\.max_size">20<\/property>/<property name="c3p0.max_size">80<\/property>/' $FILE_HIBERNATE_CFG

	sed -i 's/<property name="c3p0\.min_size">1<\/property>/<property name="c3p0.min_size">80<\/property>/' $FILE_HIBERNATE_MAIL_CFG
	sed -i 's/<property name="c3p0\.max_size">5<\/property>/<property name="c3p0.max_size">80<\/property>/' $FILE_HIBERNATE_MAIL_CFG

	sed -i 's/<property name="c3p0\.min_size">1<\/property>/<property name="c3p0.min_size">20<\/property>/' $FILE_HIBERNATE_SEARCH_CFG
	sed -i 's/<property name="c3p0\.max_size">5<\/property>/<property name="c3p0.max_size">20<\/property>/' $FILE_HIBERNATE_SEARCH_CFG

	sed -i 's/<property name="c3p0\.min_size">1<\/property>/<property name="c3p0.min_size">5<\/property>/' $FILE_HIBERNATE_REPORT_CFG
	sed -i 's/<property name="c3p0\.max_size">5<\/property>/<property name="c3p0.max_size">5<\/property>/' $FILE_HIBERNATE_REPORT_CFG

	sed -i 's/<property name="c3p0\.min_size">1<\/property>/<property name="c3p0.min_size">20<\/property>/' $FILE_HIBERNATE_PROJECT_CFG
	sed -i 's/<property name="c3p0\.max_size">5<\/property>/<property name="c3p0.max_size">20<\/property>/' $FILE_HIBERNATE_PROJECT_CFG

	sed -i 's/<property name="c3p0\.min_size">5<\/property>/<property name="c3p0.min_size">30<\/property>/' $FILE_HIBERNATE_BONUS_CFG
	sed -i 's/<property name="c3p0\.max_size">30<\/property>/<property name="c3p0.max_size">30<\/property>/' $FILE_HIBERNATE_BONUS_CFG

       # Remove local web.xml setting
       sed -i '/\[LOCAL_ONLY:START\]/,/\[LOCAL_ONLY:END\]/d' $FILE_WEB_XML

}

update_development()
{
	# Insert DB Settings
	sed -i '/\[DEVELOPMENT_DB_CONNECTION_IHERGO:START\]/a \
        <property name="connection.url">jdbc:postgresql://127.0.0.1:5432/ihergo?useUnicode=true&amp;characterEncoding=UTF-8&amp;autoReconnect=true</property> \
        <property name="connection.username">ihergo</property> \
        <property name="connection.password">ihergo382</property>' $FILE_HIBERNATE_CFG

	sed -i '/\[DEVELOPMENT_DB_CONNECTION_IHERGO_MAIL:START\]/a \
        <property name="connection.url">jdbc:postgresql://127.0.0.1:5432/ihergoMail?useUnicode=true&amp;characterEncoding=UTF-8&amp;autoReconnect=true</property> \
        <property name="connection.username">ihergo</property> \
        <property name="connection.password">ihergo382</property>' $FILE_HIBERNATE_MAIL_CFG

	sed -i '/\[DEVELOPMENT_DB_CONNECTION_IHERGO_SEARCH:START\]/a \
        <property name="connection.url">jdbc:postgresql://127.0.0.1:5432/ihergoSearch?useUnicode=true&amp;characterEncoding=UTF-8&amp;autoReconnect=true</property> \
        <property name="connection.username">ihergo</property> \
        <property name="connection.password">ihergo382</property>' $FILE_HIBERNATE_SEARCH_CFG

	sed -i '/\[DEVELOPMENT_DB_CONNECTION_IHERGO_REPORT:START\]/a \
        <property name="connection.url">jdbc:postgresql://127.0.0.1:5432/ihergoReport?useUnicode=true&amp;characterEncoding=UTF-8&amp;autoReconnect=true</property> \
        <property name="connection.username">ihergo</property> \
        <property name="connection.password">ihergo382</property>' $FILE_HIBERNATE_REPORT_CFG

	sed -i '/\[DEVELOPMENT_DB_CONNECTION_IHERGO_PROJECT:START\]/a \
        <property name="connection.url">jdbc:postgresql://127.0.0.1:5432/ihergoReport?useUnicode=true&amp;characterEncoding=UTF-8&amp;autoReconnect=true</property> \
        <property name="connection.username">ihergo</property> \
        <property name="connection.password">ihergo382</property>' $FILE_HIBERNATE_PROJECT_CFG

	sed -i '/\[DEVELOPMENT_DB_CONNECTION_IHERGO_BONUS:START\]/a \
        <property name="connection.url">jdbc:postgresql://127.0.0.1:5432/ihergoReport?useUnicode=true&amp;characterEncoding=UTF-8&amp;autoReconnect=true</property> \
        <property name="connection.username">ihergo</property> \
        <property name="connection.password">ihergo382</property>' $FILE_HIBERNATE_BONUS_CFG

	# Remove comments, to make constants available.
	sed -i '/\[DEVELOPMENT_CONSTANT_PATH:START\]/d' $FILE_IHERGO_CONSTANTS_JAVA
	sed -i '/\[DEVELOPMENT_CONSTANT_PATH:END\]/d' $FILE_IHERGO_CONSTANTS_JAVA
       
                # Add JS_VERSION
	sed -i '/\[DEVELOPMENT_CONSTANT_CONFIG:START\]/d' $FILE_IHERGO_CONSTANTS_JAVA
       sed -i "/\[DEVELOPMENT_CONSTANT_CONFIG:END\]/a \  public final static int JS_VERSION = $TODAY;" $FILE_IHERGO_CONSTANTS_JAVA
	sed -i '/\[DEVELOPMENT_CONSTANT_CONFIG:END\]/d' $FILE_IHERGO_CONSTANTS_JAVA

       # Remove local web.xml setting
       sed -i '/\[LOCAL_ONLY:START\]/,/\[LOCAL_ONLY:END\]/d' $FILE_WEB_XML
}

update_unstable()
{
	# Insert DB Settings
	sed -i '/\[UNSTABLE_DB_CONNECTION_IHERGO:START\]/a \
        <property name="connection.url">jdbc:postgresql://127.0.0.1:5432/ihergo?useUnicode=true&amp;characterEncoding=UTF-8&amp;autoReconnect=true</property> \
        <property name="connection.username">ihergo</property> \
        <property name="connection.password">ihergo382</property>' $FILE_HIBERNATE_CFG

	sed -i '/\[UNSTABLE_DB_CONNECTION_IHERGO_MAIL:START\]/a \
        <property name="connection.url">jdbc:postgresql://127.0.0.1:5432/ihergoMail?useUnicode=true&amp;characterEncoding=UTF-8&amp;autoReconnect=true</property> \
        <property name="connection.username">ihergo</property> \
        <property name="connection.password">ihergo382</property>' $FILE_HIBERNATE_MAIL_CFG

	sed -i '/\[UNSTABLE_DB_CONNECTION_IHERGO_SEARCH:START\]/a \
        <property name="connection.url">jdbc:postgresql://127.0.0.1:5432/ihergoSearch?useUnicode=true&amp;characterEncoding=UTF-8&amp;autoReconnect=true</property> \
        <property name="connection.username">ihergo</property> \
        <property name="connection.password">ihergo382</property>' $FILE_HIBERNATE_SEARCH_CFG

	sed -i '/\[UNSTABLE_DB_CONNECTION_IHERGO_REPORT:START\]/a \
        <property name="connection.url">jdbc:postgresql://127.0.0.1:5432/ihergoReport?useUnicode=true&amp;characterEncoding=UTF-8&amp;autoReconnect=true</property> \
        <property name="connection.username">ihergo</property> \
        <property name="connection.password">ihergo382</property>' $FILE_HIBERNATE_REPORT_CFG

	sed -i '/\[UNSTABLE_DB_CONNECTION_IHERGO_PROJECT:START\]/a \
        <property name="connection.url">jdbc:postgresql://127.0.0.1:5432/ihergoReport?useUnicode=true&amp;characterEncoding=UTF-8&amp;autoReconnect=true</property> \
        <property name="connection.username">ihergo</property> \
        <property name="connection.password">ihergo382</property>' $FILE_HIBERNATE_PROJECT_CFG

	sed -i '/\[UNSTABLE_DB_CONNECTION_IHERGO_BONUS:START\]/a \
        <property name="connection.url">jdbc:postgresql://127.0.0.1:5432/ihergoReport?useUnicode=true&amp;characterEncoding=UTF-8&amp;autoReconnect=true</property> \
        <property name="connection.username">ihergo</property> \
        <property name="connection.password">ihergo382</property>' $FILE_HIBERNATE_BONUS_CFG

	# Remove comments, to make constants available.
	sed -i '/\[UNSTABLE_CONSTANT_PATH:START\]/d' $FILE_IHERGO_CONSTANTS_JAVA
	sed -i '/\[UNSTABLE_CONSTANT_PATH:END\]/d' $FILE_IHERGO_CONSTANTS_JAVA

               # Add JS_VERSION
	sed -i '/\[UNSTABLE_CONSTANT_CONFIG:START\]/d' $FILE_IHERGO_CONSTANTS_JAVA
       sed -i "/\[UNSTABLE_CONSTANT_CONFIG:END\]/a \  public final static int JS_VERSION = $TODAY;" $FILE_IHERGO_CONSTANTS_JAVA
	sed -i '/\[UNSTABLE_CONSTANT_CONFIG:END\]/d' $FILE_IHERGO_CONSTANTS_JAVA
}

case $TYPE in
	production)
		echo "Updating files to production"
		remove_master
		remove_local
		update_production
		echo "Done"
	;;
	development)
		echo "Updating files to development"
		remove_master
		remove_local
		update_development
		echo "Done"
	;;
	unstable)
		echo "Updating files to unstable"
		remove_local
		update_unstable
		echo "Done"
	;;
	*)
		show_usage
		exit 1
	;;
esac
