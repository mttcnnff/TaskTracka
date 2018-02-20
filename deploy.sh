export PORT=5300
export MIX_ENV=prod
export GIT_PATH=/home/tasktracka/src/TaskTracka 

mix ecto.create
mix ecto.migrate

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

mkdir -p ~/www
mkdir -p ~/old

NOW=`date +%s`
if [ -d ~/www/TaskTracka ]; then
	echo mv ~/www/TaskTracka ~/old/$NOW
	mv ~/www/TaskTracka ~/old/$NOW
fi

mkdir -p ~/www/TaskTracka
REL_TAR=~/src/TaskTracka/_build/prod/rel/tasktracka/releases/0.0.1/tasktracka.tar.gz
(cd ~/www/TaskTracka && tar xzvf $REL_TAR)

crontab - <<CRONTAB
@reboot bash /home/tasktracka/src/TaskTracka/start.sh
CRONTAB

#. start.sh
