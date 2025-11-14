{
  pkgs ? <nixpkgs> { },
}:
pkgs.mkShell {

  packages = with pkgs; [
    mariadb
    mongodb-7_0
    (pkgs.python312.withPackages (
      python-pkgs: with python-pkgs; [
        mysql-connector
        pymongo
        jupyter
        jupyterlab-lsp
        pip
        numpy
        pandas
      ]
    ))
  ];

  shellHook = ''
    MYSQL_BASEDIR=${pkgs.mariadb}
    MYSQL_HOME="$PWD/mysql"
    MYSQL_DATADIR="$MYSQL_HOME/data"
    export MYSQL_UNIX_PORT="$MYSQL_HOME/mysql.sock"
    MYSQL_PID_FILE="$MYSQL_HOME/mysql.pid"
    alias mysql='mysql -u root'

    if [ ! -d "$MYSQL_HOME" ]; then
      # Make sure to use normal authentication method otherwise we can only
      # connect with unix account. But users do not actually exists in nix.
      mysql_install_db --no-defaults --auth-root-authentication-method=normal \
        --datadir="$MYSQL_DATADIR" --basedir="$MYSQL_BASEDIR" \
        --pid-file="$MYSQL_PID_FILE"
    fi

    # Starts the daemon
    # - Don't load mariadb global defaults in /etc with `--no-defaults`
    # - Disable networking with `--skip-networking` and only use the socket so 
    #   multiple instances can run at once
    mysqld --no-defaults --datadir="$MYSQL_DATADIR" --pid-file="$MYSQL_PID_FILE" \
      --socket="$MYSQL_UNIX_PORT" 2> "$MYSQL_HOME/mysql.log" &
    MYSQL_PID=$!

    MONGO_HOME="$PWD/mongo"
    MONOG0_LOGS="$PWD/mongo/mongod.log"
    if [ ! -d "$MONGO_HOME" ]; then
        mkdir $MONGO_HOME
    fi

    if [ ! -f "$MONGO_LOGS" ]; then
        touch $MONGO_HOME
    fi

    mongod --dbpath $MONGO_HOME --bind_ip 127.0.0.1 --logpath $MONOG0_LOGS --fork --nounixsocket
    MONOGO_PID=$!

    finish()
    {
      mysqladmin -u root --socket="$MYSQL_UNIX_PORT" shutdown
      kill $MYSQL_PID
      wait $MYSQL_PID
      kill $MONOGO_PID
      wait $MONOGO_PID
    }
    trap finish EXIT
  '';
}
