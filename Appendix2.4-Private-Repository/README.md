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
"insecure-registries":["192.168.100.2:5000"]
```

## (3)レジストリの起動と停止

### 起動
```
$ docker pull registry:2.8.3
$ docker pull cesanta/docker_auth:1.12
$ docker pull konradkleine/docker-registry-frontend:v2
$ docker-compose up -d
```

### 停止

```
$ docker-compose down
```

## (4)Dockerコマンドからのアクセス手順

### ログイン

```
$ docker login -u <username> 192.168.100.2:5000
```

### ログアウト

```
$ docker logout 192.168.100.2:5000
```

### イメージの登録

```
$ docker tag centos:7-git 192.168.100.2:5000/centos:7-git
$ $ docker push 192.168.100.2:5000/centos:7-git
The push refers to repository [192.168.100.2:5000/centos]
14aa6be18d2e: Pushed
174f56854903: Pushed
7-git: digest: sha256:9e6c89cf020e96cb89627f63d234f0da5c3b3dcc313ba1b3552fe01a8a7a04ea size: 742
```
