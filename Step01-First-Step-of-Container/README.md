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

書籍では`centos:7`を使用しているが，[2024年6月30日にEOLとなった](https://www.redhat.com/ja/topics/linux/centos-linux-eol)ことに伴い，`Ubuntu:23.04`を使用して動作確認を行う．

```
$ docker pull ubuntu:23.04
23.04: Pulling from library/ubuntu
6360b3717211: Already exists
Digest: sha256:5a828e28de105c3d7821c4442f0f5d1c52dc16acf4999d5f31a3bc0f03f06edd
Status: Downloaded newer image for ubuntu:23.04
docker.io/library/ubuntu:23.04
```

### (2)コンテナの実行(docker run)

```
$ docker run -it --name test1 ubuntu:23.04 bash
root@b48b94ed5b5c:/# 
```

ターミナルにコンテナを制御するプロンプトが表示されるが，コンテナとホストOSとの間で制御を切り替えるために，デタッチとアタッチを行う．  
デタッチとアタッチの方法は書籍には記載されてないが，以下の手順で実行することが可能である．

#### (2-1)デタッチ(Ctrl+P, Ctrl+Q)

`Ctrl+P`を押した後，`Ctrl+Q`を押すとコンテナの制御をホストOSに戻すことができる．

```
[root@b48b94ed5b5c /]# (Host prompt)$ 
```

#### (2-2)アタッチ(docker attach)

```
$ docker attach test1
[root@b48b94ed5b5c /]#
```

### (3)コンテナの状態の確認表示(docker ps)

```
$ docker ps -a
CONTAINER ID   IMAGE            COMMAND    CREATED          STATUS                        PORTS   NAMES
b48b94ed5b5c   ubuntu:23.04     "bash"     33 seconds ago   Up 30 seconds                         test1
343615ae1149   hello-world      "/hello"   32 minutes ago   Exited (0) 32 minutes ago             sleepy_montalcini
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
CONTAINER ID   IMAGE            COMMAND    CREATED          STATUS              PORTS   NAMES
b48b94ed5b5c   ubuntu:23.04     "bash"     33 seconds ago   Up 30 seconds               test1
$ docker stop test1
test1
$ docker ps -a
CONTAINER ID   IMAGE            COMMAND    CREATED          STATUS              PORTS                                 NAMES
b48b94ed5b5c   ubuntu:23.04     "bash"                      4 minutes ago       Exited (137) 5 seconds ago            test1
```

### (6)コンテナの再スタート(docker start)

```
$ docker start test1
test1
$ docker ps
CONTAINER ID   IMAGE           COMMAND   CREATED          STATUS         PORTS     NAMES
b48b94ed5b5c   ubuntu:23.04    "bash"    6 minutes ago    Up 2 seconds             test1
```

### (7)実行中コンテナの変更をリポジトリへ保存(docker commit)

```
root@b48b94ed5b5c:/# apt update -y
Get:1 http://archive.ubuntu.com/ubuntu lunar InRelease [267 kB]
Get:2 http://security.ubuntu.com/ubuntu lunar-security InRelease [109 kB]
Get:3 http://security.ubuntu.com/ubuntu lunar-security/main amd64 Packages [429 kB]

(中略)

Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
9 packages can be upgraded. Run 'apt list --upgradable' to see them.
root@b48b94ed5b5c:/# apt install -y git
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done

(中略)

rocessing triggers for ca-certificates (20230311ubuntu0.23.04.1) ...
Updating certificates in /etc/ssl/certs...
0 added, 0 removed; done.
Running hooks in /etc/ca-certificates/update.d...
done.
root@b48b94ed5b5c:/#

(デタッチ)

$ docker ps
CONTAINER ID   IMAGE          COMMAND    CREATED         STATUS         PORTS      NAMES
b48b94ed5b5c   ubuntu:23.04   "bash"     9 minutes ago   Up 3 minutes              test1
$ docker commit b48b94ed5b5c ubuntu:23.04-git
sha256:7399d06d535c5c10ec149a3311d3178814f4606879f98b29229eea2ac1ececf0
$ docker images
REPOSITORY     TAG             IMAGE ID       CREATED          SIZE
ubuntu         23.04-git       7399d06d535c   13 seconds ago   197MB
```

### (8)イメージをリモートリポジトリへ保存(docker push)

書籍ではクラウドへの保存を想定しているが，ここではプライベートリポジトリへ保存する手順を示す．

```
$ docker tag ubuntu:23.04-git 192.168.100.2:5000/ubuntu:23.04-git
$ docker push 192.168.100.2:5000/ubuntu:23.04-git
$ docker push 192.168.100.2:5000/ubuntu:23.04-git
The push refers to repository [192.168.100.2:5000/ubuntu]
5ce3706d57b0: Pushed
48143ecdba52: Pushed
23.04-git: digest: sha256:c37ddcb5093a3054deb976dfa4c050f306b46cf7fa4da311eee0288b9551e077 size: 741
```

### (9)終了済みコンテナの削除(docker rm)

コンテナIDを指定して終了済みコンテナを削除すると，コンテナのログ表示ができなくなる．

```
$ docker rm 343615ae1149
$ docker logs 343615ae1149
Error response from daemon: No such container: 343615ae1149
```

### (10)イメージの削除(docker rmi)

```
$ docker images
REPOSITORY                  TAG         IMAGE ID       CREATED         SIZE
192.168.100.2:5000/ubuntu   23.04-git   7399d06d535c   3 minutes ago   197MB
ubuntu                      23.04-git   7399d06d535c   3 minutes ago   197MB
$ docker rmi 192.168.100.2:5000/ubuntu:23.04-git
$ docker images
REPOSITORY                  TAG         IMAGE ID       CREATED         SIZE
ubuntu                      23.04-git   7399d06d535c   3 minutes ago   197MB
```
