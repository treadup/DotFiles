function box
    switch "$argv[1]"
	case "build"
	    _box_build
	case "cd"
	    _box_cd $argv[2..-1]
	case "db"
	    _box_db $argv[2..-1]
	case "deploy"
	    _box_deploy $argv[2..-1]
	case "log"
	    _box_log $argv[2..-1]
	case "open"
	    _box_open $argv[2..-1]
	case "shell"
	    _box_shell $argv[2..-1]
	case "start"
	    _box_start $argv[2..-1]
	case "stop"
	    _box_stop $argv[2..-1]
	case ""
	    echo "Usage: box <command>"
	    echo "where <command> can be one of the following."
	    echo "build  - build the docker image"
	    echo "cd     - change to project folders"
	    echo "db     - perform database commands"
	    echo "deploy - perform deploy commands"
	    echo "log    - view logs"
	    echo "shell  - start shell"
	    echo "start  - perform start commands"
	    echo "stop   - perform stop commands"
	case "*"
	    echo "Unknown command: $argv[1]"
    end
end

function _box_cd
    switch "argv[1]"
	case "embed"
	    cd ~/work/frontend-external/embed/
	case "frontend"
	    cd ~/work/frontend/
	case "backend"
	    cd ~/work/flowbox/
	case ""
	    echo "Usage: box cd <project>"
	    echo "where <project> can be one of the following."
	    echo "frontend"
	    echo "backend"
	    echo "embed"
	case "*"
	    echo "Unknonw project: $argv[1]"
    end
end

function _box_open
    google-chrome https://localhost:5000/
end

function _box_start
    switch "$argv[1]"
	case "frontend"
	    # Checking integrity is now done in the main project
	    # yarn --cwd ~/work/frontend check --integrity && yarn --cwd ~/work/frontend start
	    yarn --cwd ~/work/frontend start
	case "backend"
	    docker-compose -f ~/work/flowbox/docker-compose.yml up flask-app
	case ""
	    echo "Usage: box start <command>"
	    echo "where <command> can be one of the following."
	    echo "frontend - start frontend application"
	    echo "backend  - start backend application"
	case "*"
	    echo "Unknown start command: $argv[1]"
    end
end


function _box_stop
    switch "$argv[1]"
	case "backend"
	case ""
	    echo "Usage: box stop <command>"
	    echo "where <command> can be one of the following."
	    echo "backend - stop the backend application"
	case "*"
	    echo "Unknown stop command: $argv[1]"
    end
end


function _box_deploy
    switch "$argv[1]"
	case "celerytest"
	    echo "Deploying celery to test"
	    eval "cd ~/work/flowbox/flask-app/ && fab test celery deploy"
	case "celeryprod"
	    echo "Deploying celery to production"
	    eval "cd ~/work/flowbox/flask-app/ && fab live celery deploy"
	case "webtest"
	    echo "Deploying web to test"
	    eval "cd ~/work/flowbox/flask-app/ && fab test web deploy"
	case "webprod"
	    echo "Deploying web to production"
	    eval "cd ~/work/flowbox/flask-app/ && fab live web deploy"
	case "embedtest"
	    echo "Deploying embed to test"
	    cd ~/work/frontend-external/embed
	    rm -rf dist
	    yarn build:test
	    git checkout -- dist/index.html
	    fab test deploy
	case "embedprod"
	    echo "Deploying embed to live"
	    cd ~/work/frontend-external/embed
	    rm -rf dist
	    yarn build:live
	    git checkout -- dist/index.html
	    fab live deploy
	case ""
	    echo "Usage: box deploy <command>"
	    echo "where <command> can be one of the following."
	    echo "celerytest - deploy celery to test"
	    echo "celeryprod - deploy celery to prod"
	    echo "webtest    - deploy web to test"
	    echo "webprod    - deploy web to prod"
	    echo "embedtest  - deploy embed to test"
	    echo "embedprod  - deploy embed to prod"
	case "*"
	    echo "Unknown deploy command: $argv[1]"
    end
end


function _box_db
    switch "$argv[1]"
	case "psql"
	    _box_db_psql $argv[2..-1]
	case "upgrade"
	    eval "cd ~/work/flowbox/ && docker-compose exec flask-app python manage.py db upgrade"
	case "downgrade"
	    eval "cd ~/work/flowbox/ && docker-compose exec flask-app python manage.py db downgrade"
	case ""
	    echo "Usage: box db <command>"
	    echo "where <command> can be one of the following."
	    echo "psql - use psql to connect to a server"
            echo "mysql - use mysql to connect to a server"
	    echo "upgrade - upgrade the database"
	    echo "downgrade - downgrade the databse"
	case "*"
	    echo "Unknown db command: $argv[1]"
    end
end

function _box_db_psql
    switch "$argv[1]"
	case "test"
	    ssh bastion-test -t psql -U test-database-user -h test-db-hostname test-database-name $argv[2..-1]
	case "prod"
	    ssh bastion-prod -t psql -U prod-database-user -h prod-db-hostname prod-database-name $argv[2..-1]
	case "local"
	    psql -h localhost -p 5433 -U local-user local-database-name $argv[2..-1]
        case ""
	    echo "Usage: box db psql <server>"
	    echo "where <server> can be one of the following"
	    echo "test - connect to the test server"
	    echo "prod - connect to the production server"
	    echo "local - connect to the local server"
	case "*"
	    echo "Unknown server: $argv[1]"
    end
end

function _box_log
    switch "$argv[1]"
	case "celeryprod"
	    if set -q argv[2]
		pssh -t0 -H "prod-celery1 prod-celery2 prod-celery3" -P "tail -F /var/log/celeryd/worker-celery.log | grep --line-buffered '$argv[2]'"
	    else
		pssh -t0 -H "prod-celery1 prod-celery2 prod-celery3" -P "tail -F /var/log/celeryd/worker-celery.log"
	    end
	case "webprod"
	    if set -q argv[2]
		pssh -t0 -H "prod-gunicorn1 prod-gunicorn2" -P "tail -F /var/log/gunicorn.log | grep --line-buffered '$argv[2]'"
	    else
		pssh -t0 -H "prod-gunicorn1 prod-gunicorn2" -P 'tail -F /var/log/gunicorn.log'
	    end
	case "webtest"
	    if set -q argv[2]
		pssh -t0 -H "test-gunicorn1 test-gunicorn2" -P "tail -F /var/log/gunicorn.log | grep --line-buffered '$argv[2]'"
	    else
		pssh -t0 -H "test-gunicorn1 test-gunicorn2" -P 'tail -F /var/log/gunicorn.log'
	    end
	case ""
	    echo "Usage: box log <command>"
	    echo "where <command> can be one of the following."
	    echo "webprod"
	    echo "celeryprod"
	    echo "webtest"
	case "*"
	    echo "Unknown log command: $argv[1]"
    end
end


function _box_shell
    switch "$argv[1]"
	case "python"
	    docker-compose -f ~/work/flowbox/docker-compose.yml exec flask-app python manage.py shell
	case "bash"
	    docker-compose -f ~/work/flowbox/docker-compose.yml exec flask-app bash
	case ""
	    echo "Usage: box shell <shell>"
	    echo "where <shell> can be one of the following."
	    echo "shell"
	    echo "bash"
	case "*"
	    echo "Unknown shell: $argv[1]"
    end
end

function _box_build
    docker-compose -f ~/work/flowbox/docker-compose.yml build flask-app
end
