# Step05-コンテナAPI

## Step05.1 コンテナAPIの種類と概要

（省略）

## Step05.2 環境変数のAPI実装例

### ホストPC上で動作確認

```
cd step05.2
$ ./my_daemon.sh 
09:24:43 : 0
09:24:48 : 1
09:24:53 : 2
09:24:58 : 3
09:25:03 : 4
09:25:08 : 5
$ INTERVAL=3 ./my_daemon.sh 
09:25:21 : 0
09:25:24 : 1
09:25:27 : 2
09:25:30 : 3
09:25:33 : 4
09:25:36 : 5
```

### Docker build

```
$ docker build --tag my_daemon:0.1 .
```

### Docker run

```
$ docker run --name myd my_daemon:0.2
```

### Docker stop

`docker run`とは別のTerminalを開いて，以下のコマンドを実行する．

```
$ docker stop myd
```

### Docker start

`docker stop`後に実行する．  
カウンタは初期化され，0からカウントアップする．

```
$ docker start -i myd
13:06:03 : 0
13:06:08 : 1
13:06:13 : 2
13:06:18 : 3
13:06:23 : 4
```

## Step05.3 終了要求のAPI実装例

### Docker build

```
$ cd step05.3
$ docker build --tag my_daemon:0.2 .
```
### Docker run

```
$ docker run --name myd my_daemon:0.2
13:14:02 : 0
13:14:07 : 1
13:14:12 : 2
13:14:17 : 3
13:14:22 : 4
```

### Docker stop

`docker run`とは別のTerminalを開いて，以下のコマンドを実行する．

```
$ docker stop myd
```

### Docker start

`docker stop`後に実行する．  
`save.dat`に状態を保存することにより，再開後のカウンタが継続できる．

```
$ docker start -i myd
13:14:35 : 5
13:14:40 : 6
13:14:45 : 7
13:14:50 : 8
13:14:55 : 9
```

### Docker rm

コンテナを削除してから再度実行するとカウンタは初期化される．

```
$ docker rm myd
$ docker run --name myd my_daemon:0.2
13:18:53 : 0
13:18:58 : 1
13:19:03 : 2
13:19:08 : 3
13:19:13 : 4
13:19:18 : 5
```

## Step05.4 永続ボリュームのAPI実装例

### Docker build

```
$ cd step05.4
$ docker build --tag my_daemon:0.3 .
```

### Docker run

```
$ docker run --name myd -v $(pwd)/data:/pv my_daemon:0.3
13:32:27 : 0
13:32:32 : 1
13:32:37 : 2
13:32:42 : 3
13:32:47 : 4
13:32:52 : 5
```

### Docker stop

`docker run`とは別のTerminalを開いて，以下のコマンドを実行する．

```
$ docker stop myd
myd
```

### Docker start

`docker stop`後に実行する．

```
$ docker start -i myd
13:33:05 : 6
13:33:10 : 7
13:33:15 : 8
13:33:20 : 9
```

### Docker rm

コンテナを削除してから再度実行すると，`data/save.dat`に保持された情報をもとに再度実行した際にもカウンタを継続できる．

```
$ docker rm myd
myd
$ docker run --name myd -v $(pwd)/data:/pv my_daemon:0.3
13:33:41 : 10
13:33:46 : 11
13:33:51 : 12
13:33:56 : 13
13:34:01 : 14
$ docker stop myd
$ cat data/save.dat 
15
```

## Step05.5 ログとバックグラウンド起動

（省略）
