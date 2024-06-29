# 付録2.4 プライベートリポジトリ

書籍では[著者が公開しているGitHubリポジトリ](https://github.com/takara9/registry)を利用する方法で説明されていますが，2024年6月現在ではリポジトリがなくなっている為，以下を参考にしてプライベートリポジトリを構築する．

- [第48回 Dockerプライベートレジストリにユーザー認証を付けるには（概要編）](https://www.itmedia.co.jp/enterprise/articles/1709/25/news017.html)
- [第49回 Dockerプライベートレジストリにユーザー認証を付ける（準備編）](https://www.itmedia.co.jp/enterprise/articles/1710/02/news018.html)
- [第50回 Dockerプライベートレジストリにユーザー認証を付ける（活用編）](https://www.itmedia.co.jp/enterprise/articles/1710/16/news016.html)

## (1)システム構成

以下の機能を持つプライベートレジストリを構築する．  
認証機能付きのレジストリを構築する予定であったが，docker-registry-frontendが認証に対応していない為，認証機能は省略する．

- dockerコマンドからレジストリへの登録(push)，ダウンロード(pull)が可能
- ブラウザからレジストリが保有する全リポジトリのリスト表示，リポジトリの詳細表示が可能

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

### イメージの登録

```
$ docker tag centos:7-git 192.168.100.2:5000/centos:7-git
$ $ docker push 192.168.100.2:5000/centos:7-git
The push refers to repository [192.168.100.2:5000/centos]
14aa6be18d2e: Pushed
174f56854903: Pushed
7-git: digest: sha256:9e6c89cf020e96cb89627f63d234f0da5c3b3dcc313ba1b3552fe01a8a7a04ea size: 742
```
