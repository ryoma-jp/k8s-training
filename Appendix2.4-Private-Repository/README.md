# 付録2.4 プライベートリポジトリ

書籍では[著者が公開しているGitHubリポジトリ](https://github.com/takara9/registry)を利用する方法で説明されていますが，2024年6月現在ではリポジトリがなくなっている為，以下を参考にしてプライベートリポジトリを構築する．

- [第48回 Dockerプライベートレジストリにユーザー認証を付けるには（概要編）](https://www.itmedia.co.jp/enterprise/articles/1709/25/news017.html)
- [第49回 Dockerプライベートレジストリにユーザー認証を付ける（準備編）](https://www.itmedia.co.jp/enterprise/articles/1710/02/news018.html)
- [第50回 Dockerプライベートレジストリにユーザー認証を付ける（活用編）](https://www.itmedia.co.jp/enterprise/articles/1710/16/news016.html)

## (1)システム構成

以下の機能を持つプライベートリポジトリを構築します．

- dockerコマンドからレジストリへのログイン(login)，ログアウト(logout)，登録(push)，削除(rmi)，リスト取得(images)，実行(run)，ダウンロード(pull)などが可能
- ブラウザからレジストリが保有する全リポジトリのリスト表示，リポジトリの詳細表示

## (2)準備作業

### SSL証明書の作成

```
$ mkdir ssl
$ cd ssl/
$ openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout server.key -out server.crt
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:JP
State or Province Name (full name) [Some-State]:Tokyo
Locality Name (eg, city) []:
Organization Name (eg, company) [Internet Widgits Pty Ltd]:
Organizational Unit Name (eg, section) []:
Common Name (e.g. server FQDN or YOUR name) []:
Email Address []:
$ cd ..
```

### ユーザー認証ファイルの作成

[auth_config.yml](./config/auth_config.yml)を，[auth_config-sample.yml](./config/auth_config-sample.yml)を参考に作成する．  
下記の手順で生成するハッシュをユーザ名とともに追記する．

```
$ apt install -y apache2-utils
$ htpasswd -nbB <user name> <password> | cut -d: -f2
```

### 環境設定ファイルの作成

`/etc/docker/daemon.json`に以下を追記する．

```
"insecure-registries":["172.18.0.2:5000"]
```

## (3)レジストリの起動と停止

### 起動
```
$ docker pull registry:2.8.3
$ docker pull cesanta/docker_auth:1.12
$ docker pull konradkleine/docker-registry-frontend:v2
$ docker network create --subnet 172.18.0.0/24 fixed_container_network
$ docker run --network fixed_container_network -d \
-v $PWD/config:/config:ro \
-v $PWD/log/docker_auth:/logs \
-v $PWD/ssl:/ssl \
-p 5001:5001 \
--restart=always \
--name docker_auth \
--ip 172.18.0.3 \
cesanta/docker_auth:1.12 /config/auth_config.yml
$ docker run --network fixed_container_network -d -p 5000:5000 \
-e REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY=/var/lib/registry \
-e REGISTRY_AUTH=token \
-e REGISTRY_AUTH_TOKEN_REALM=https://172.18.0.3:5001/auth \
-e REGISTRY_AUTH_TOKEN_SERVICE="Docker registry" \
-e REGISTRY_AUTH_TOKEN_ISSUER="Auth Service" \
-e REGISTRY_AUTH_TOKEN_ROOTCERTBUNDLE=/ssl/server.crt \
-v $PWD/ssl:/ssl \
-v $PWD/docker_registry/data:/var/lib/registry \
--restart=always \
--ip 172.18.0.2 \
--name registry registry:2.8.3
# --- T.B.D ---
#$ docker run --network fixed_container_network -d \
#-e ENV_DOCKER_REGISTRY_HOST=172.18.0.2 \
#-e ENV_DOCKER_REGISTRY_PORT=5000 \
#-e ENV_USE_SSL=yes \
#-v $PWD/ssl/server.crt:/etc/apache2/server.crt:ro \
#-v $PWD/ssl/server.key:/etc/apache2/server.key:ro \
#--ip 172.18.0.5 \
#-p 443:443 \
#--name frontend konradkleine/docker-registry-frontend:v2
```

### 停止

```
$ docker stop registry docker_auth
$ docker rm registry docker_auth
```

## (4)Dockerコマンドからのアクセス手順

### ログイン

```
$ docker login 172.18.0.2:5000
```

### ログアウト

```
$ docker logout
```

### イメージの登録

```
$ docker tag centos:7-git 172.18.0.2:5000/centos:7-git
$ docker push 172.18.0.2:5000/centos:7-git
The push refers to repository [172.18.0.2:5000/centos]
14aa6be18d2e: Pushed
174f56854903: Pushed
7-git: digest: sha256:9e6c89cf020e96cb89627f63d234f0da5c3b3dcc313ba1b3552fe01a8a7a04ea size: 742
```
