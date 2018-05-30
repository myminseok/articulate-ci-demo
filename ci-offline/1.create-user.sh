fly -t tutorial login -c http://127.0.0.1:8080 -n main --username=admin --password=changeme
fly -t tutorial set-team -n ci-offline  --basic-auth-username user1 --basic-auth-password password1 --non-interactive  

