kp secret create harborapp-registry-creds --registry harborapp.shared.lab.pksdemo.net --registry-user admin

kp image save sample-convention-server \
  --tag harborapp.shared.lab.pksdemo.net/library/sample-convention-server \
  --git https://github.com/dbha/sample-convention-server.git \
  --git-revision main \
  --env BP_JVM_VERSION=17 \
  --wait

kp image list -A

kp build logs sample-convention-server -n default