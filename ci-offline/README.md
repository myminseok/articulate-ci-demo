

# docker repo
```
docker run -d -p 5000:5000 --restart=always --name registry registry:2
```

## upload docker image for articulate
```
docker pull pivotalservices/docker-concourse-cf-tools:latest
docker tag pivotalservices/docker-concourse-cf-tools localhost:5000/pivotalservices/docker-concourse-cf-tools
docker push localhost:5000/pivotalservices/docker-concourse-cf-tools
docker image remove pivotalservices/docker-concourse-cf-tools:latest
docker image remove  localhost:5000/pivotalservices/docker-concourse-cf-tools

docker pull myminseok/java8_git_mvn:v1
docker tag myminseok/java8_git_mvn:v2 localhost:5000/myminseok/java8_git_mvn:v1
docker push localhost:5000/myminseok/java8_git_mvn:v1
docker image remove myminseok/java8_git_mvn:v1
docker image remove localhost:5000/myminseok/java8_git_mvn:v1
```


# nexus
```
docker run -d -p 8081:8081 --name nexus sonatype/nexus:oss
```
http://10.10.10.199:8081/nexus

## upload maven dependencies  for articulate
```
cd /root/demo/
# git clone https://github.com/myminseok/articulate

cd /root/demo/articulate
git checkout offline
cd /root/demo/articulate && ./mvn-uploadtonexus.sh
```

# gitlab
```
docker run --detach --hostname 10.10.10.199 --publish 443:443 --publish 8082:80 --name gitlab --restart always gitlab/gitlab-ce
```

http://10.10.10.199:8082/ (wait for few minutes)

# gitlab 
## set root password 'changeme' : http://10.10.10.199:8082/
## login as root/changeme
## create a public project 'articulate' : http://10.10.10.199:8082/projects/new
## add ssh key  http://10.10.10.199:8082/profile/keys/
### cat /root/.ssh/id_rsa.pub 
```
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJNIkIFHy0hF4v4wXMmKsXv4g4JBd2hQvaN6U2ocKhxmi1BTElqVxFthwsd7Q5lgUxJx4K/BL6u9dXYkk0eEKYMlp9/Oz2UeAUb6D9hqhbATm52YzMxThYtlxXvWnvis9c3Cx+dy9pYSABGCdnkPaB9emJLaYNY7m60HTKzzCzEYE2Y1lpwMI8tWUzmyRsnWRpjXYY4KD8g++52e+cgRje43riol/4O59KOh94r3DnJL6Ja9o03Ljns9fu9DC69su/1k+A7dNQGU9wwuXxf8ycQgYNVl5iAZNVHHh2hDGtf+aTp5WbySVHfkzwWbr68gPx0xir5O7dv4wVJkgR6X9B root@ubuntu
```
## push articulate source code to git
```
cd /root/demo/articulate && git push origin offline    

...
Username for 'http://10.10.10.199:8082': root
Password for 'http://root@10.10.10.199:8082': changeme

```


# concourse ci
## clone pipeline code
```
cd /root/demo/
# git clone https://github.com/myminseok/articulate-ci-demo
cd /root/demo/articulate-ci-demo/ci-offline
```
## EDIT dns in docker-compose.yml to VM IP.
```
vi articulate-ci-demo/ci-offline/docker-compose.yml

...
    - CONCOURSE_NO_REALLY_I_DONT_WANT_ANY_AUTH=true
    - CONCOURSE_WORKER_GARDEN_NETWORK
    - CONCOURSE_LOG_LEVEL=info
    dns: 10.10.10.199    <====== change to VM IP
```
## start concourse
```
./0.setup-concourse.sh
```

http://10.10.10.199:8080

## set pipeline
```
cd /root/demo/articulate-ci-demo/ci-offline
./1.create-user.sh
./2.login.sh
./3.setpipeline.sh
```

## destroy
```

cd /root/demo/articulate-ci-demo/ci-offline
docker-compose down
docker stop registry
docker stop nexus
docker stop gitlab

docker system prune -a --volumes -f
docker system df -v
```






