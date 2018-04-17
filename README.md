
# setup concourse server

```
cd articulate-ci-demo
docker-compose up
```
# setup ci-credentials.yml

Note: pws-app-suffix and pws-app-hostname should be different. it is same then there will be error in pipeline.
```
---
deploy-username: 
deploy-password: 
pws-organization:  
pws-space:  
pws-api: api.run.pivotal.io
pws-app-suffix: canary-app
pws-app-domain: apps.run.pivotal.io
pws-app-hostname: canary-demo
github-private-key: |
  ---BEGIN RSA PRIVATE KEY-----
  MI
  ...
  ---END RSA PRIVATE KEY-----
git-email: test@example.com
git-name: test
git-source-repo-uri: git@github.com:myminseok/articulate.git

```

# push pipeline

```
fly -t tutorial login -c http://127.0.0.1:8080
fly -t tutorial destroy-pipeline -p blue-green
fly -t tutorial destroy-pipeline -p canary
fly -t tutorial set-pipeline -p blue-green -c ./ci/pipeline.yml -l ~/ci-credentials.yml
fly -t tutorial set-pipeline -p canary -c ./ci/pipeline-canary.yml -l ~/ci-credentials.yml
```

# push app
edit source code from 'git-source-repo-uri' in 'ci-credentials.yml' and push.
in 10 seconds, concourse pipeline will start to build
