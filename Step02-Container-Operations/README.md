# Step02-コンテナの操作

## Step02.1 対話型による起動と停止

### (1)対話モードでのコンテナ起動(docker run -it)

```
$ docker run -it ubuntu bash
Unable to find image 'ubuntu:latest' locally
latest: Pulling from library/ubuntu
9c704ecd0c69: Pull complete
Digest: sha256:2e863c44b718727c860746568e1d54afd13b2fa71b160f5cd9058fc436217b30
Status: Downloaded newer image for ubuntu:latest
root@9c13b9dc28f5:/# 
```

### (2)対話モードでのコンテナ停止(exit)

```
root@9c13b9dc28f5:/# exit
exit
$ 
```
## Step02.2 カスタムコンテナの作成

### Ubuntuにネットワーク関連のパッケージをインストール

```
$ docker run -it ubuntu:23.04 bash
root@5696b570aba2:/# apt update && apt install -y iputils-ping net-tools iproute2 dnsutils curl
Get:1 http://security.ubuntu.com/ubuntu noble-security InRelease [126 kB]
Get:2 http://archive.ubuntu.com/ubuntu noble InRelease [256 kB]

(中略)

Updating certificates in /etc/ssl/certs...
0 added, 0 removed; done.
Running hooks in /etc/ca-certificates/update.d...
done.
root@5696b570aba2:/# ifconfig eth0
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 172.17.0.2  netmask 255.255.0.0  broadcast 172.17.255.255
        ether 02:42:ac:11:00:02  txqueuelen 0  (Ethernet)
        RX packets 8099  bytes 42671831 (42.6 MB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 5151  bytes 350803 (350.8 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

root@5696b570aba2:/#

(デタッチ)

$ docker ps
CONTAINER ID   IMAGE            COMMAND    CREATED         STATUS         PORTS    NAMES
5696b570aba2   ubuntu:23.04     "bash"     5 minutes ago   Up 5 minutes            unruffled_solomon
$ docker commit 5696b570aba2 my-ubuntu:0.1
sha256:0622b27a6d302cc8379b9018d47fe1918debcf30cb2eda0ed761a2ca4a276283
$ docker images
REPOSITORY     TAG              IMAGE ID       CREATED          SIZE
my-ubuntu      0.1              0622b27a6d30   18 seconds ago   174MB
ubuntu         23.04-git        7399d06d535c   31 minutes ago   197MB
$ docker inspect --format='{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' 5696b570aba2
172.17.0.2
```

## Step02.3 複数ターミナルからの操作

(省略)

## Step02.4 コンテナホストとコンテナの関係

(省略)
