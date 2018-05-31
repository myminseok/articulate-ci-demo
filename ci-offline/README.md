
# VM 
pivotal/changeme

# DNS to VM IP
change 10.10.10.199 to VM IP
```
10.10.10.199 localdockerrepo.pcfdemo.net 
10.10.10.199 localci.pcfdemo.net 
```

# docker repo
```
docker run -d -p 5000:5000 --restart=always --name registry registry:2
```

## upload docker image for articulate
```
cd /root/demo/docker-image-save

# docker pull pivotalservices/docker-concourse-cf-tools:latest
# docker image save pivotalservices/docker-concourse-cf-tools -o pivotalservices__docker-concourse-cf-tools
docker image load -i pivotalservices__docker-concourse-cf-tools
docker tag pivotalservices/docker-concourse-cf-tools localhost:5000/pivotalservices/docker-concourse-cf-tools
docker push localhost:5000/pivotalservices/docker-concourse-cf-tools
docker image remove pivotalservices/docker-concourse-cf-tools:latest
docker image remove  localhost:5000/pivotalservices/docker-concourse-cf-tools


# docker pull myminseok/java8_git_mvn:v1
# docker image save myminseok/java8_git_mvn:v1 -o myminseok__java8_git_mvn__v1
docker image load -i myminseok__java8_git_mvn__v1
docker tag myminseok/java8_git_mvn:v1 localhost:5000/myminseok/java8_git_mvn:v1
docker push localhost:5000/myminseok/java8_git_mvn:v1
docker image remove myminseok/java8_git_mvn:v1
docker image remove localhost:5000/myminseok/java8_git_mvn:v1

```



# nexus
```
docker run -d -p 8081:8081 --restart=always  --name nexus  sonatype/nexus:oss
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
check if artifacts are loaded.
http://10.10.10.199:8081/nexus/content/repositories/releases/



# gitlab
```
docker run --detach --hostname 10.10.10.199 --publish 443:443 --publish 8082:80 --name gitlab --restart always gitlab/gitlab-ce
```
http://10.10.10.199:8082/ (wait for few minutes)

## set root password 'changeme' : http://10.10.10.199:8082/
## login as root/changeme

## add ssh key  http://10.10.10.199:8082/profile/keys/
### cat /root/.ssh/id_rsa.pub 
```
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJNIkIFHy0hF4v4wXMmKsXv4g4JBd2hQvaN6U2ocKhxmi1BTElqVxFthwsd7Q5lgUxJx4K/BL6u9dXYkk0eEKYMlp9/Oz2UeAUb6D9hqhbATm52YzMxThYtlxXvWnvis9c3Cx+dy9pYSABGCdnkPaB9emJLaYNY7m60HTKzzCzEYE2Y1lpwMI8tWUzmyRsnWRpjXYY4KD8g++52e+cgRje43riol/4O59KOh94r3DnJL6Ja9o03Ljns9fu9DC69su/1k+A7dNQGU9wwuXxf8ycQgYNVl5iAZNVHHh2hDGtf+aTp5WbySVHfkzwWbr68gPx0xir5O7dv4wVJkgR6X9B root@ubuntu
```
## push articulate source code to git
## create a public project 'articulate' : http://10.10.10.199:8082/projects/new

```
cd /root/demo/articulate
git remote add local http://10.10.10.199:8082/root/articulate
git push local offline   

...
Username for 'http://10.10.10.199:8082': root
Password for 'http://root@10.10.10.199:8082': changeme

```
## create a public project 'articulate-ci-demo' : http://10.10.10.199:8082/projects/new
## push articulate-ci-demo source code to git
```
cd /root/demo/articulate-ci-demo 
git remote add local http://10.10.10.199:8082/root/articulate-ci-demo
git push local master    

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
## check  dns(host VM) in docker-compose.yml 

```

export HOST_IP=`ip -4 addr show scope global dev docker0 | grep inet | awk '{print \$2}' | cut -d / -f 1`
echo $HOST_IP # 172.17.0.1 

vi articulate-ci-demo/ci-offline/docker-compose.yml

...
    - CONCOURSE_NO_REALLY_I_DONT_WANT_ANY_AUTH=true
    - CONCOURSE_WORKER_GARDEN_NETWORK
    - CONCOURSE_LOG_LEVEL=info
    dns: ${HOST_IP} 
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

## start docker after rebooting VM.
```

cd /root/demo/articulate-ci-demo/ci-offline
docker-compose up -d
docker start registry
docker start nexus
docker start gitlab

```




## destroy docker
```

cd /root/demo/articulate-ci-demo/ci-offline
docker-compose down
docker stop registry
docker stop nexus
docker stop gitlab

docker system prune -a --volumes -f
docker system df -v
```









