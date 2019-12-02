ls
git clone --single-branch -b bbb-22-1 https://github.com/MaximKhlobystov/docker.git
cp -r docker/{mod,setup.sh,supervisord.conf} .
cp -r docker/Dockerfile Dockerfile.test
docker build -t bbb -f Dockerfile.test .
docker run -d -p 80:80/tcp -p 443:443/tcp -p 1935:1935 -p 5066:5066 -p 3478:3478 -p 3478:3478/udp bbb -h localhost
container=$(docker ps -q)
echo $container
docker ps --all
#sleep 10
#docker ps --all
#docker exec $container service supervisor status
#docker exec $container ls
#docker exec $container echo $CIRCLE_REPOSITORY_URL
#docker exec $container echo $CIRCLE_SHA1

#echo $CIRCLE_WORKING_DIRECTORY

#docker exec $container ls
docker exec $container git clone https://github.com/MaximKhlobystov/bigbluebutton.git
#docker exec $container ls
docker exec $container bash -c "cd bigbluebutton/bigbluebutton-html5 && npm install"
#docker exec $container supervisorctl status bbb-html5
docker exec $container supervisorctl stop bbb-html5
#docker exec $container supervisorctl status bbb-html5
docker exec $container bash -c "curl https://install.meteor.com/ | sh"

docker exec -it $container curl -I localhost/html5client/check

docker exec $container bash -c "sudo apt-get install -y firefox && sudo apt-get install -y xvfb"
docker exec $container bash -c "cd bigbluebutton/bigbluebutton-html5 && curl https://install.meteor.com/ | sh && ROOT_URL=http://127.0.0.1/html5client NODE_ENV=development METEOR_ALLOW_SUPERUSER=true meteor" &
docker exec $container bash -c "cd bigbluebutton/bigbluebutton-html5 && ./node_modules/.bin/webdriver-manager update"
docker exec $container bash -c "cd bigbluebutton/bigbluebutton-html5 && xvfb-run ./node_modules/.bin/webdriver-manager start" &

echo "test"

sleep 300s

docker exec -it $container curl -I localhost/html5client/check

echo "TESTING"

docker exec $container bash -c "wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - && echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list && sudo apt-get update"
docker exec $container bash -c "sudo apt-get install -y google-chrome-stable"
docker exec $container bash -c "cd bigbluebutton/bigbluebutton-html5 && npm test -- --spec ./tests/webdriverio/specs/chat.spec.js"

echo "FINISHED"
