fly -t tutorial set-pipeline -p bluegreen -c ./ci/pipeline-bluegreen.yml -l ../ci-credentials-brother3.yml
fly -t tutorial set-pipeline -p canary -c ./ci/pipeline-canary.yml -l ../ci-credentials-brother3.yml
