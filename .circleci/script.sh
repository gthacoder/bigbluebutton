ls
git clone --single-branch -b bbb-22 https://github.com/MaximKhlobystov/docker.git
cp -r docker/{mod,setup.sh,supervisord.conf} .
cp -r docker/Dockerfile Dockerfile.test
docker build -t bbb -f Dockerfile.test .
docker run --privileged -d -p 80:80/tcp -p 443:443/tcp -p 1935:1935 -p 5066:5066 -p 3478:3478 -p 3478:3478/udp bbb -h localhost
container=$(docker ps -q)
echo $container
docker stop $container
docker start $container
docker exec $container supervisorctl status bbb-html5

