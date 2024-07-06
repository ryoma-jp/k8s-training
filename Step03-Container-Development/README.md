# Step03-コンテナ開発

## Step03.1 イメージのビルドの概要

(省略)

## Step03.2 ビルドの実行手順

ファイル`message`に書き込んだテキストを`figlet`で表示するDockerイメージをビルドする．

### `message`ファイルの作成

```
$ echo "Hello World" > message
```

### Dockerfileの作成

```
FROM    alpine:3.20.1
RUN     apk update && apk add figlet
add     ./message /message
CMD     cat /message | figlet
```

### イメージのビルド

```
$ docker build -t hello:1.0 .
[+] Building 20.0s (8/8) FINISHED
 => [internal] load .dockerignore                                                                                          1.8s
 => => transferring context: 2B                                                                                            0.0s 
 => [internal] load build definition from Dockerfile                                                                       1.5s
 => => transferring dockerfile: 157B                                                                                       0.1s
 => [internal] load metadata for docker.io/library/alpine:3.20.1                                                           4.5s
 => [1/3] FROM docker.io/library/alpine:3.20.1@sha256:b89d9c93e9ed3597455c90a0b88a8bbb5cb7188438f70953fede212a0c4394e0     4.6s
 => => resolve docker.io/library/alpine:3.20.1@sha256:b89d9c93e9ed3597455c90a0b88a8bbb5cb7188438f70953fede212a0c4394e0     1.3s
 => => sha256:b89d9c93e9ed3597455c90a0b88a8bbb5cb7188438f70953fede212a0c4394e0 1.85kB / 1.85kB                             0.0s 
 => => sha256:a606584aa9aa875552092ec9e1d62cb98d486f51f389609914039aabd9414687 1.47kB / 1.47kB                             0.0s 
 => => sha256:dabf91b69c191a1a0a1628fd6bdd029c0c4018041c7f052870bb13c5a222ae76 528B / 528B                                 0.0s 
 => => sha256:ec99f8b99825a742d50fb3ce173d291378a46ab54b8ef7dd75e5654e2a296e99 3.62MB / 3.62MB                             0.6s 
 => => extracting sha256:ec99f8b99825a742d50fb3ce173d291378a46ab54b8ef7dd75e5654e2a296e99                                  0.4s 
 => [internal] load build context                                                                                          1.4s 
 => => transferring context: 46B                                                                                           0.0s 
 => [2/3] RUN     apk update && apk add figlet                                                                             5.7s 
 => [3/3] ADD     ./message /message                                                                                       1.4s 
 => exporting to image                                                                                                     1.7s 
 => => exporting layers                                                                                                    1.5s 
 => => writing image sha256:4ab07ecc22f14e9ffd57b0f66db0ba42692ad82bca32c3bddff2744eaddea97e                               0.1s 
 => => naming to docker.io/library/hello:1.0                                        
$ docker images
REPOSITORY                                                TAG                       IMAGE ID       CREATED              SIZE
hello                                                     1.0                       4ab07ecc22f1   About a minute ago   10.8MB
my-ubuntu                                                 0.1                       0622b27a6d30   31 minutes ago       174MB
```

### イメージの実行

```
$ docker run hello:1.0
 _   _      _ _        __        __         _     _ 
| | | | ___| | | ___   \ \      / /__  _ __| | __| |
| |_| |/ _ \ | |/ _ \   \ \ /\ / / _ \| '__| |/ _` |
|  _  |  __/ | | (_) |   \ V  V / (_) | |  | | (_| |
|_| |_|\___|_|_|\___/     \_/\_/ \___/|_|  |_|\__,_|

```
## Step03.3 Dockerfileの書き方

(省略)

## Step03.4 Dockerfileの書き方のベストプラクティス

(省略)
