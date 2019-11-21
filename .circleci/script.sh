ls
git clone --single-branch -b bbb-22-1 https://github.com/MaximKhlobystov/docker.git
cp -r docker/{mod,setup.sh,supervisord.conf} .
cp -r docker/Dockerfile Dockerfile.test
docker build -t bbb -f Dockerfile.test .
docker run -d -p 80:80/tcp -p 443:443/tcp -p 1935:1935 -p 5066:5066 -p 3478:3478 -p 3478:3478/udp bbb -h localhost
container=$(docker ps -q)
echo $container
docker ps --all
sleep 60
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
#docker exec -it $container /bin/bash

#docker exec $container service supervisor status
#docker exec $container supervisorctl status bbb-html5
echo "FINISHED"
