
PATH=$1
TYPE=$2
TODAY=`date +%Y%m%d%H`

show_usage()
{
	echo "Usage: ${0##*/} <path to httproot> <production/development/unstable>"
}


if [ $# -ne 2 ]; then
	show_usage
	exit 0
fi

if [ -z "$PATH" ];then
	show_usage
	exit 0
fi

if [ ! -d "$PATH" ]; then
	show_usage
	exit 1
fi

remove_master()
{
	sed -i '/\[MASTER_ONLY:START\]/,/\[MASTER_ONLY:END\]/d' $FILE_WEB_XML
}

remove_slave()
{
	sed -i '/\[SLAVE_ONLY:START\]/,/\[SLAVE_ONLY:END\]/d' $FILE_WEB_XML
}

add_JS_VERSION()
{
       sed -i "/\[UNSTABLE_CONSTANT_CONFIG:END\]/a \  public final static int JS_VERSION = $TODAY;" $FILE_IHERGO_CONSTANTS_JAVA
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
