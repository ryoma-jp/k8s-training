# Step06-Kubenetes最初の一歩

## Step06.1 クラスタ構成の確認

```
$ kubectl cluster-info
Kubernetes control plane is running at https://127.0.0.1:32769
CoreDNS is running at https://127.0.0.1:32769/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
$ kubectl get node
NAME       STATUS   ROLES           AGE   VERSION
minikube   Ready    control-plane   24m   v1.30.0
```

## Step06.2 ポッドの実行

```
$ kubectl run hello-world --image=hello-world -it --restart=Never

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```

### 終了済みポッドの表示

```
$ kubectl get pod
NAME          READY   STATUS      RESTARTS   AGE
hello-world   0/1     Completed   0          4m8s
```

### 終了済みポッドの削除

```
$ kubectl delete pod hello-world
pod "hello-world" deleted
```

### ポッドのバックグラウンド実行とログ表示

```
$ kubectl run hello-world --image=hello-world --restart=Never
pod/hello-world created
$ kubectl logs hello-world

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```

## Step06.3 コントローラによるポッドの実行

```
$ kubectl create deployment hello-world --image=hello-world
deployment.apps/hello-world created
$ kubectl get all
NAME                              READY   STATUS             RESTARTS     AGE
pod/hello-world-5f64fc8dc-xrsws   0/1     CrashLoopBackOff   1 (9s ago)   22s

NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   35m

NAME                          READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/hello-world   0/1     1            0           22s

NAME                                    DESIRED   CURRENT   READY   AGE
replicaset.apps/hello-world-5f64fc8dc   1         1         0       22s
$ kubectl logs pod/hello-world-5f64fc8dc-xrsws

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
$ kubectl get deployment
$ kubectl delete deployment hello-world
deployment.apps "hello-world" deleted
```

## Step06.4 ジョブによるポッドの実行

```
$ kubectl create job hello-world --image=hello-world
job.batch/hello-world created
$ kubectl get all
NAME                    READY   STATUS      RESTARTS   AGE
pod/hello-world-qpddv   0/1     Completed   0          19s

NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   39m

NAME                    STATUS     COMPLETIONS   DURATION   AGE
job.batch/hello-world   Complete   1/1           12s        19s
$ kubectl logs pod/hello-world-qpddv

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
$ kubectl get jobs
NAME          STATUS     COMPLETIONS   DURATION   AGE
hello-world   Complete   1/1           12s        96s
$ kubectl delete job hello-world
job.batch "hello-world" deleted
$ kubectl get all
NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   41m
```
