export PORT=5300
export MIX_ENV=prod mix ecto.create
export MIX_ENV=prod mix ecto.migrate
export GIT_PATH=/home/tasktracka/src/TaskTracka 

PWD=`pwd`
if [ $PWD != $GIT_PATH ]; then
	echo "Error: Must check out git repo to $GIT_PATH"
	echo "  Current directory is $PWD"
	exit 1
fi

if [ $USER != "tasktracka" ]; then
	echo "Error: must run as user 'tasktracka'"
	echo "  Current user is $USER"
	exit 2
fi

mix deps.get
(cd assets && npm install)
(cd assets && ./node_modules/brunch/bin/brunch b -p)
mix phx.digest
mix release --env=prod


crontab - <<CRONTAB
@reboot bash /home/tasktracka/src/TaskTracka/start.sh
CRONTAB

#. start.sh
