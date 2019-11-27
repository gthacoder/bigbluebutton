ls
git clone --single-branch -b bbb-22-1 https://github.com/MaximKhlobystov/docker.git
cp -r docker/{mod,setup.sh,supervisord.conf} .
cp -r docker/Dockerfile Dockerfile.test
docker build -t bbb -f Dockerfile.test .
docker run -d -p 80:80/tcp -p 443:443/tcp -p 1935:1935 -p 5066:5066 -p 3478:3478 -p 3478:3478/udp bbb -h localhost
container=$(docker ps -q)
echo $container
docker ps --all
sleep 10
docker ps --all
#docker exec $container service supervisor status
#sleep 120
#docker ps --all
docker exec $container service supervisor status
docker exec $container ls
docker exec $container echo $CIRCLE_REPOSITORY_URL
docker exec $container echo $CIRCLE_SHA1
#docker stop $container
#docker start $container
#docker exec $container supervisorctl status bbb-html5
#docker exec $container service supervisor status
#docker exec $container unlink /var/run/supervisor.sock
#docker exec $container service supervisor start
#docker ps --all
#docker start $container

echo $CIRCLE_WORKING_DIRECTORY

docker exec $container ls
docker exec $container git clone https://github.com/MaximKhlobystov/bigbluebutton.git
docker exec $container ls
docker exec $container bash -c "cd bigbluebutton/bigbluebutton-html5 && npm install"
docker exec $container supervisorctl status bbb-html5
docker exec $container supervisorctl stop bbb-html5
docker exec $container supervisorctl status bbb-html5
docker exec $container bash -c "curl https://install.meteor.com/ | sh"
#docker exec $container bash -c "cd bigbluebutton/bigbluebutton-html5 && npm install forever -g && ROOT_URL=http://127.0.0.1/html5client NODE_ENV=development METEOR_ALLOW_SUPERUSER=true forever meteor"
#docker exec -it $container /bin/bash

docker exec -it $container curl -I localhost/html5client/check

docker exec $container bash -c "sudo apt-get install firefox && sudo apt-get install xvfb"
docker exec $container bash -c "cd bigbluebutton/bigbluebutton-html5 && curl https://install.meteor.com/ | sh && ROOT_URL=http://127.0.0.1/html5client NODE_ENV=development METEOR_ALLOW_SUPERUSER=true meteor" &
docker exec $container bash -c "cd bigbluebutton/bigbluebutton-html5 && ./node_modules/.bin/webdriver-manager update"
docker exec $container bash -c "cd bigbluebutton/bigbluebutton-html5 && xvfb-run ./node_modules/.bin/webdriver-manager start" &

echo "test"

sleep 300s

docker exec -it $container curl -I localhost/html5client/check

#docker exec $container service supervisor status
#docker exec $container supervisorctl status bbb-html5
echo "FINISHED"
