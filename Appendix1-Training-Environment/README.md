# 付録1 学習環境1

書籍ではMac，Windows, Vargrant仮想環境上のLinuxの手順が記載されていますが，ここではWSL2上のUbuntu 22.04で動作確認をおこなっていますので，[Kubenetes公式の手順](https://kubernetes.io/ja/docs/tasks/tools/install-kubectl-linux/)に沿って，`kubectl`をインストールします．

## kubectlのインストール

```bash
$ sudo apt update
$ sudo apt install -y apt-transport-https ca-certificates curl gnupg
$ curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
$ sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg
$ echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
$ sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list
$ sudo apt update
$ sudo apt install -y kubectl
```

## kubectlのバージョン確認

```bash
$ kubectl version --client
Client Version: v1.30.2
Kustomize Version: v5.0.4-0.20230601165947-6ce0bf390ce3
```
