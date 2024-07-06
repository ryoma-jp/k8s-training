# Step01-コンテナの最初の一歩

## Step01.1 hello-world

```
$ docker run hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
c1ec31eb5944: Pull complete
Digest: sha256:266b191e926f65542fa8daaec01a192c4d292bff79426f47300a046e1bc576fd
Status: Downloaded newer image for hello-world:latest

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

## Step01.2 コンテナのライフサイクルとdockerコマンド

書籍ではDockerイメージの保存をDocker HubやIBM Cloudへ登録することが説明されているが，ここではクラウドではなくオンプレミス環境を想定し，プライベートリポジトリへ登録する手順を示す．

プライベートリポジトリの構築方法は[付録2.4 プライベートリポジトリ](./Appendix2.4-Private-Repository/README.md)を参照．

### (1)コンテナ実行前の事前ダウンロード(docker pull)

```
$ docker pull centos:7
7: Pulling from library/centos
2d473b07cdd5: Pull complete
Digest: sha256:be65f488b7764ad3638f236b7b515b3678369a5124c47b8d32916d6487418ea4
Status: Downloaded newer image for centos:7
docker.io/library/centos:7
```

### (2)コンテナの実行(docker run)

```
$ docker run -it --name test1 centos:7 bash
[root@c26163e9b668 /]# 
```

ターミナルにコンテナを制御するプロンプトが表示されるが，コンテナとホストOSとの間で制御を切り替えるために，デタッチとアタッチを行う．  
デタッチとアタッチの方法は書籍には記載されてないが，以下の手順で実行することが可能である．

#### (2-1)デタッチ(Ctrl+P, Ctrl+Q)

`Ctrl+P`を押した後，`Ctrl+Q`を押すとコンテナの制御をホストOSに戻すことができる．

```
[root@c26163e9b668 /]# (Host prompt)$ 
```

#### (2-2)アタッチ(docker attach)

```
$ docker attach test1
[root@c26163e9b668 /]#
```

### (3)コンテナの状態の確認表示(docker ps)

```
$ docker ps -a
CONTAINER ID   IMAGE            COMMAND       CREATED          STATUS                      PORTS          NAMES
c26163e9b668   centos:7         "bash"        19 minutes ago   Up 19 minutes                              test1
343615ae1149   hello-world      "/hello"      32 minutes ago   Exited (0) 32 minutes ago                  sleepy_montalcini
```

### (4)ログ表示(docker logs)

終了状態にあるコンテナ(343615ae1149)のログを表示する．

```
$ docker logs 343615ae1149

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

### コンテナの停止(docker stop, docker kill)

```
$ docker ps
CONTAINER ID   IMAGE      COMMAND   CREATED          STATUS          PORTS     NAMES
c26163e9b668   centos:7   "bash"    26 minutes ago   Up 26 minutes             test1
$ docker stop test1
test1
$ docker ps -a
CONTAINER ID   IMAGE      COMMAND   CREATED          STATUS                        PORTS     NAMES
c26163e9b668   centos:7   "bash"    26 minutes ago   Exited (137) 13 seconds ago             test1
```

### (6)コンテナの再スタート(docker start)

```
$ docker start test1
test1
$ docker ps
CONTAINER ID   IMAGE      COMMAND   CREATED          STATUS         PORTS     NAMES
c26163e9b668   centos:7   "bash"    33 minutes ago   Up 2 seconds             test1
```

### (7)実行中コンテナの変更をリポジトリへ保存(docker commit)

```
[root@07af1decb255 /]# yum update -y
Loaded plugins: fastestmirror, ovl
Determining fastest mirrors
 * base: ftp.jaist.ac.jp
 * extras: ftp.jaist.ac.jp

(以下省略)

[root@07af1decb255 /]# yum install -y git
Loaded plugins: fastestmirror, ovl
Loading mirror speeds from cached hostfile
 * base: ftp.jaist.ac.jp
 * extras: ftp.jaist.ac.jp

(以下省略)

(デタッチ)

$ docker ps
CONTAINER ID   IMAGE      COMMAND   CREATED       STATUS       PORTS     NAMES
07af1decb255   centos:7   "bash"    2 hours ago   Up 2 hours             frosty_dirac

$ docker commit 07af1decb255 centos:7-git
sha256:6ee9bb14ce23eefc6f2cc61b080ec8ea1b0839e4497e7c9ef6e8ceaae97f3f86

$ docker images
REPOSITORY    TAG      IMAGE ID       CREATED         SIZE
centos        7-git    6ee9bb14ce23   7 minutes ago   647MB
```
### (8)イメージをリモートリポジトリへ保存(docker push)

書籍ではクラウドへの保存を想定しているが，ここではプライベートリポジトリへ保存する手順を示す．

```
$ docker tag centos:7-git 192.168.100.2:5000/centos:7-git
$ docker push 192.168.100.2:5000/centos:7-git
The push refers to repository [192.168.100.2:5000/centos]
14aa6be18d2e: Pushed
174f56854903: Pushed
7-git: digest: sha256:9e6c89cf020e96cb89627f63d234f0da5c3b3dcc313ba1b3552fe01a8a7a04ea size: 742
```

### (9)終了済みコンテナの削除(docker rm)

コンテナIDを指定して終了済みコンテナを削除すると，コンテナのログ表示ができなくなる．

```
$ docker rm 9e52e187af2e
$ docker logs 9e52e187af2e
Error response from daemon: No such container: 9e52e187af2e
```

### (10)イメージの削除(docker rmi)

```
$ docker images
REPOSITORY                  TAG     IMAGE ID       CREATED         SIZE
192.168.100.2:5000/centos   7-git   6ee9bb14ce23   2 weeks ago     647MB
centos                      7-git   6ee9bb14ce23   2 weeks ago     647MB
$ docker rmi 192.168.100.2:5000/centos:7-git
$ docker images
REPOSITORY                  TAG     IMAGE ID       CREATED         SIZE
centos                      7-git   6ee9bb14ce23   2 weeks ago     647MB
```
