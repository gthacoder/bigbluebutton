ls
git clone --single-branch -b bbb-22-1 https://github.com/MaximKhlobystov/docker.git
cp -r docker/{mod,setup.sh,supervisord.conf} .
cp -r docker/Dockerfile Dockerfile.test
docker build -t bbb -f Dockerfile.test .
docker run -d -p 80:80/tcp -p 443:443/tcp -p 1935:1935 -p 5066:5066 -p 3478:3478 -p 3478:3478/udp bbb -h localhost
container=$(docker ps -q)
echo $container
docker ps --all
docker exec $container echo $CIRCLE_PR_REPONAME
docker exec $container echo $CIRCLE_PR_USERNAME
docker exec $container echo $CIRCLE_SHA1

docker exec $container bash -c "git clone https://github.com/MaximKhlobystov/bigbluebutton.git && cd bigbluebutton && git reset --hard $CIRCLE_SHA1 && git log -1 --stat"
docker exec $container bash -c "cd bigbluebutton/bigbluebutton-html5 && npm install"
docker exec $container supervisorctl stop bbb-html5
docker exec $container bash -c "curl https://install.meteor.com/ | sh"

docker exec -it $container curl -I localhost/html5client/check

docker exec $container bash -c "sudo apt-get install -y firefox && sudo apt-get install -y xvfb"
docker exec $container bash -c "cd bigbluebutton/bigbluebutton-html5 && curl https://install.meteor.com/ | sh && ROOT_URL=http://127.0.0.1/html5client NODE_ENV=development METEOR_ALLOW_SUPERUSER=true meteor" &

echo "test"

sleep 250s

docker exec -it $container curl -I localhost/html5client/check

echo "TESTING"

docker exec $container bash -c "cd bigbluebutton/bigbluebutton-html5/tests/pptr && npm install -g mocha && mocha test.js"

#docker exec $container bash -c "cd bigbluebutton/bigbluebutton-html5 && npm test -- --spec ./tests/webdriverio/specs/chat.spec.js"



echo "FINISHED"
