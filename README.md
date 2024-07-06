# Kubenetes Training

書籍[15Stepで習得 Dockerから入るKubernetes コンテナ開発からK8s本番運用まで](https://www.amazon.co.jp/15Step%E3%81%A7%E7%BF%92%E5%BE%97-Docker%E3%81%8B%E3%82%89%E5%85%A5%E3%82%8BKubernetes-%E3%82%B3%E3%83%B3%E3%83%86%E3%83%8A%E9%96%8B%E7%99%BA%E3%81%8B%E3%82%89K8s%E6%9C%AC%E7%95%AA%E9%81%8B%E7%94%A8%E3%81%BE%E3%81%A7-StepUp-%E9%81%B8%E6%9B%B8/dp/4865941614)をトレースしながら一部補足などを書き加えたリポジトリです．

|ディレクトリ|説明|
|:--|:--|
|[Step01-コンテナの最初の一歩](./Step01-First-Step-of-Container)|hello-worldからコンテナイメージをダウンロードして起動する|
|[付録2.4](./Appendix2.4-Private-Repository/)|プライベートリポジトリを構築する|

## 動作確認環境

- Windows 11 Home (23H2)
- Intel(R) Core(TM) i7-10700F CPU @ 2.90GHz   2.90 GHz
- RAM 32.0 GB
- WSL2 (22.04.1 LTS (Jammy Jellyfish))

## 基礎環境構築

WSL2にUbuntu 22.04をインストールし，Dockerを使用可能な状態にします．  
筆者はこのリポジトリを作成する前に環境構築を終えていたため，環境構築手順に関連するリンクを以下に示します．

- [How to install Linux on Windows with WSL2](https://learn.microsoft.com/en-us/windows/wsl/install)
- [Install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/)