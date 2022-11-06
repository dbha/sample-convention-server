# sample-convention-server



#### 1. Create Image
./kp_create_image.sh

#### 2. Deploy sample convention server
    kubectl apply -f server.yaml
    namespace/sample-conventions created
    issuer.cert-manager.io/selfsigned-issuer created
    certificate.cert-manager.io/webhook-cert created
    Warning: clusterimagepolicies.signing.apps.tanzu.vmware.com "image-policy" not found. Image policy enforcement was not applied.
    deployment.apps/webhook created
    service/webhook created
    clusterpodconvention.conventions.carto.run/sample created


#### 3. Check CR
    kubectl get clusterpodconvention.conventions.carto.run
    NAME                     AGE
    appliveview-sample       7d23h
    developer-conventions    7d23h
    sample                   70s
    spring-boot-convention   7d23h

    kubectl get all -n sample-conventions
    NAME                           READY   STATUS    RESTARTS   AGE
    pod/webhook-7566788dbf-9qzdd   1/1     Running   0          2m53s

    NAME              TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
    service/webhook   ClusterIP   100.70.137.145   <none>        443/TCP   2m53s

    NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
    deployment.apps/webhook   1/1     1            1           2m54s

    NAME                                 DESIRED   CURRENT   READY   AGE
    replicaset.apps/webhook-7566788dbf   1         1         1       2m55s
  
  
#### 4. Create Workload
    tanzu apps workload create my-rsvpapp \
      --app my-rsvpapp \
      --type web \
      --git-repo https://github.com/dbha/myrsvpapp \
      --git-branch main \
      --namespace demo-app \
      --env MONGODB_HOST=mongodb \
      --label apps.tanzu.vmware.com/has-tests=true \
      --label app.kubernetes.io/part-of=pyhton-app \
      --param-yaml testing_pipeline_matching_labels='{"apps.tanzu.vmware.com/pipeline":"test", "apps.tanzu.vmware.com/language":"python"}' \
      --annotation autoscaling.knative.dev/minScale=1 \
      --namespace demo-app \
      --tail \
      --yes
  
#### 5. Check Workload ENV
    kubectl get podintent.conventions.carto.run/my-rsvpapp -o yaml -n demo-app -o jsonpath='{.status.template.spec.containers}' | jq .
    [
      {
        "env": [
          {
            "name": "MONGODB_HOST",
            "value": "mongodb"
          },
          {
            "name": "CONVENTION_SERVER",
            "value": "HELLO FROM CONVENTION"
          }
        ],
        "image": "harborapp.shared.lab.pksdemo.net/tap/supply-chain/my-rsvpapp-demo-app@sha256:428d5f7f51fffad0dacc8c2d08a283fef33f24a4d41f3867db63b58efb95240d",
        "name": "workload",
        "resources": {},
        "securityContext": {
          "runAsUser": 1000
        }
      }
    ]  
  
