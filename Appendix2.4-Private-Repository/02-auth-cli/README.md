# 付録2.4 プライベートリポジトリ

書籍では[著者が公開しているGitHubリポジトリ](https://github.com/takara9/registry)を利用する方法で説明されているが，2024年6月現在ではリポジトリがなくなっている為，以下を参考にしてプライベートリポジトリを構築する．

Kubenetesでは認証付きのリポジトリが必要であるが，認証機能に対応したフロントエンドを見つけられず(2024.7.20現在)，コマンドラインで操作可能な環境を構築する

- [第48回 Dockerプライベートレジストリにユーザー認証を付けるには（概要編）](https://www.itmedia.co.jp/enterprise/articles/1709/25/news017.html)
- [第49回 Dockerプライベートレジストリにユーザー認証を付ける（準備編）](https://www.itmedia.co.jp/enterprise/articles/1710/02/news018.html)
- [第50回 Dockerプライベートレジストリにユーザー認証を付ける（活用編）](https://www.itmedia.co.jp/enterprise/articles/1710/16/news016.html)

## (1)OpenSSL 証明書の作成

```
$ openssl req -x509 \
-nodes \
-days 365 \
-newkey rsa:2048 \
-keyout ./ssl/server.key \
-out    ./ssl/server.pem

(中略)

-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:
State or Province Name (full name) [Some-State]:
Locality Name (eg, city) []:
Organization Name (eg, company) [Internet Widgits Pty Ltd]:
Organizational Unit Name (eg, section) []:
Common Name (e.g. server FQDN or YOUR name) []:
Email Address []:
```

## (2) パスワードの生成とconfigファイルの作成

```
$ cd config
$ wget https://raw.githubusercontent.com/cesanta/docker_auth/main/examples/simple.yml
$ mv simple.yml config.yml
```

[準備編](https://www.itmedia.co.jp/enterprise/articles/1710/02/news018.html)を参考に，`config.yml`を編集する．

## (3) Dockerコンテナの起動

```
$ docker-compose up -d
$ docker-compose ps
       Name                      Command               State                    Ports
-------------------------------------------------------------------------------------------------------
cesanta-docker_auth   /docker_auth/auth_server / ...   Up      0.0.0.0:5001->5001/tcp,:::5001->5001/tcp
docker-registry       /entrypoint.sh /etc/docker ...   Up      0.0.0.0:5000->5000/tcp,:::5000->5000/tcp
```

## (4) レジストリへのログイン

```
$ docker login https://192.168.100.2:5000
```

以後，`docker push`や`docker pull`を行うことができる．

## 補足

### レジストリからのログアウト

```
$ docker logout https://192.168.100.2:5000
```

### ログアウトした状態の操作

認証機能が正しく動作していれば，Dockerイメージを`pull`することができない．

```
$ docker pull 192.168.100.2:5000/ubuntu:23.04
Error response from daemon: Head "http://192.168.100.2:5000/v2/ubuntu/manifests/23.04": unauthorized: authentication required
```

### `curl`でレジストリにアクセスする為のトークンの取得

以下の(1)～(3)は`catalog`を取得する例であるが，取得する情報ごとにトークンを生成する必要がある．

#### (1) アクセス情報の取得

トークンを取得する為の`service`，`scope`，`account`の情報を取得する．

```
$ curl -k -IL http://192.168.100.2:5000/v2/_catalog
HTTP/1.1 401 Unauthorized
Content-Type: application/json; charset=utf-8
Docker-Distribution-Api-Version: registry/2.0
Www-Authenticate: Bearer realm="https://192.168.100.3:5001/auth",service="Docker registry",scope="registry:catalog:*"
X-Content-Type-Options: nosniff
Date: Sat, 20 Jul 2024 11:55:32 GMT
Content-Length: 145
```

#### (2) トークンの取得

```
$ export CMD=`curl -k -u <username>:<password> -d "service=Docker registry" -d "scope=registry:catalog:*" -d "account=ryoma" https://192.168.100.3:5001/auth`
$ export ID_TOKEN=$(echo $CMD | python3 -c 'import sys,json; print(json.load(sys.stdin)["token"])')
```

#### (3) トークンを利用したアクセス

```
$ curl -k -H "Authorization: Bearer $ID_TOKEN" http://192.168.100.2:5000/v2/_catalog
{"repositories":["ubuntu"]}
```

### レジストリに登録したイメージの確認

```
$ export CMD=`curl -k -u <username>:<password> -d "service=Docker registry" -d "scope=registry:catalog:*" -d "account=ryoma" https://192.168.100.3:5001/auth`
$ export ID_TOKEN=$(echo $CMD | python3 -c 'import sys,json; print(json.load(sys.stdin)["token"])')
$ curl -k -H "Authorization: Bearer $ID_TOKEN" http://192.168.100.2:5000/v2/_catalog
{"repositories":["ubuntu"]}
$ export CMD=`curl -k -u <username>:<password> -d "service=Docker registry" -d "scope=repository:ubuntu:pull" -d "account=ryoma" https://192.168.100.3:5001/auth`
$ export ID_TOKEN=$(echo $CMD | python3 -c 'import sys,json; print(json.load(sys.stdin)["token"])')
$ curl -k -H "Authorization: Bearer $ID_TOKEN" http://192.168.100.2:5000/v2/ubuntu/tags/list
{"name":"ubuntu","tags":["23.04"]}
```

### タグの削除

タグは`curl`で`DELETE`を送信することで削除できる．

```
$ export CMD=`curl -k -u <username>:<password> -d "service=Docker registry" -d "scope=repository:ubuntu:pull" -d "account=ryoma" https://192.168.100.3:5001/auth`
$ export ID_TOKEN=$(echo $CMD | python3 -c 'import sys,json; print(json.load(sys.stdin)["token"])')
$ curl -i -k -H "Authorization: Bearer $ID_TOKEN" -H "Accept: application/vnd.docker.distribution.manifest.v2+json" 192.168.100.2:5000/v2/ubuntu/manifest.v2+json" 192.168.100.2:5000/v2/ubuntu/manifests/23.04
HTTP/1.1 200 OK
Content-Length: 529
Content-Type: application/vnd.docker.distribution.manifest.v2+json
Docker-Content-Digest: sha256:ce495421d6f75f940e0006d2ee2b89d1149fb5de4160e140e1dede4d1bfbd5b2
Docker-Distribution-Api-Version: registry/2.0
Etag: "sha256:ce495421d6f75f940e0006d2ee2b89d1149fb5de4160e140e1dede4d1bfbd5b2"
X-Content-Type-Options: nosniff
Date: Sat, 20 Jul 2024 12:05:41 GMT

{
   "schemaVersion": 2,
   "mediaType": "application/vnd.docker.distribution.manifest.v2+json",
   "config": {
      "mediaType": "application/vnd.docker.container.image.v1+json",
      "size": 2298,
      "digest": "sha256:f4cdeba72b994748f5eb1f525a70a9cc553b66037ec37e23645fbf3f0f5c160d"
   },
   "layers": [
      {
         "mediaType": "application/vnd.docker.image.rootfs.diff.tar.gzip",
         "size": 27663335,
         "digest": "sha256:efcc827fbbb39a149bce1b1b0951eccfa438d1d84153744033dd253856da8a08"
      }
   ]
}$ curl -v -k -H "Authorization: Bearer $ID_TOKEN" -X DELETE 192.168.100.2:5000/v2/ubuntu/manifests/sha256:ce495421d6f75f940e0006d2ee2b89d1149fb5de4160e140e1dede4d1bfbd5b2
$ export CMD=`curl -k -u <username>:<password> -d "service=Docker registry" -d "scope=repository:ubuntu:delete" -d "account=ryoma" https://192.168.100.3:5001/auth`
$ export ID_TOKEN=$(echo $CMD | python3 -c 'import sys,json; print(json.load(sys.stdin)["token"])')
$ curl -v -k -H "Authorization: Bearer $ID_TOKEN" -X DELETE 192.168.100.2:5000/v2/ubuntu/manifests/sha256:ce495421d6f75f940e0006d2ee2b89d1149fb5de4160e140e1dede4d1bfbd5b2
$ export CMD=`curl -k -u <username>:<password> -d "service=Docker registry" -d "scope=repository:ubuntu:pull" -d "account=ryoma" https://192.168.100.3:5001/auth`
$ export ID_TOKEN=$(echo $CMD | python3 -c 'import sys,json; print(json.load(sys.stdin)["token"])')
$ curl -k -H "Authorization: Bearer $ID_TOKEN" http://192.168.100.2:5000/v2/ubuntu/tags/list
{"name":"ubuntu","tags":null}
```

### リポジトリの削除

リポジトリはサーバ上のディレクトリを削除するしかない模様．

```
$ docker-compose exec docker-registry sh
/ # cd /var/lib/registry/docker/registry/v2/repositories
/var/lib/registry/docker/registry/v2/repositories # ls
ubuntu
/var/lib/registry/docker/registry/v2/repositories # rm -rf ubuntu/
/var/lib/registry/docker/registry/v2/repositories # 
$ export CMD=`curl -k -u <username>:<password> -d "service=Docker registry" -d "scope=registry:catalog:*" -d "account=ryoma" https://192.168.100.3:5001/auth`
$ export ID_TOKEN=$(echo $CMD | python3 -c 'import sys,json; print(json.load(sys.stdin)["token"])')
$ curl -k -H "Authorization: Bearer $ID_TOKEN" http://192.168.100.2:5000/v2/_catalog
{"repositories":[]}
```
