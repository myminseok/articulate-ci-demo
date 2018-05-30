fly -t tutorial set-pipeline -p bluegreen -c ./ci/pipeline-bluegreen.yml -l ../ci-credentials-online.yml
fly -t tutorial set-pipeline -p canary -c ./ci/pipeline-canary.yml -l ../ci-credentials-online.yml
