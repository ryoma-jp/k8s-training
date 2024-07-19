# 付録2.4 プライベートリポジトリ

書籍では[著者が公開しているGitHubリポジトリ](https://github.com/takara9/registry)を利用する方法で説明されているが，2024年6月現在ではリポジトリがなくなっている為，以下を参考にしてプライベートリポジトリを構築する．

- [PortusでプライベートDockerレジストリを作ってみよう](https://speakerdeck.com/hashimotosyuta/portusdepuraibetodockerrezisutoriwozuo-tutemiyou)

## Portusの取得と環境設定

[Portus](https://github.com/SUSE/Portus.git)がメンテナンスされておらず，`docker-compose build`に失敗する．  
パスを変更するなど試したが解決困難であり，Portusの利用は見送ることとする．

```
$ git clone https://github.com/SUSE/Portus.git
$ cd Portus
$ docker-compose build
webpack uses an image, skipping
db uses an image, skipping
background uses an image, skipping
postgres uses an image, skipping
clair uses an image, skipping
registry uses an image, skipping
Building portus
[+] Building 14.0s (8/9)
 => [internal] load build definition from Dockerfile                                                                                                                     1.1s
 => => transferring dockerfile: 1.87kB                                                                                                                                   0.2s 
 => [internal] load .dockerignore                                                                                                                                        0.7s
 => => transferring context: 122B                                                                                                                                        0.0s
 => [internal] load metadata for docker.io/opensuse/ruby:2.6                                                                                                             2.8s
 => [1/5] FROM docker.io/opensuse/ruby:2.6@sha256:a442b46c8be4aeec39bbb93a2cea2273f8eb0832707d64834b89edf6e175e66f                                                       0.0s
 => [internal] load build context                                                                                                                                        2.1s 
 => => transferring context: 71.31kB                                                                                                                                     1.7s
 => CACHED [2/5] WORKDIR /srv/Portus                                                                                                                                     0.0s
 => CACHED [3/5] COPY Gemfile* ./                                                                                                                                        0.0s 
 => ERROR [4/5] RUN zypper addrepo https://download.opensuse.org/repositories/devel:languages:go/openSUSE_Leap_15.0/devel:languages:go.repo &&     zypper addrepo https  7.6s
------
 > [4/5] RUN zypper addrepo https://download.opensuse.org/repositories/devel:languages:go/openSUSE_Leap_15.0/devel:languages:go.repo &&     zypper addrepo https://download.opensuse.org/repositories/devel:/tools/openSUSE_Leap_15.0/ devel:tools &&     zypper --gpg-auto-import-keys ref &&     zypper -n in --no-recommends ruby2.6-devel            libmariadb-devel postgresql-devel            nodejs libxml2-devel libxslt1 git-core            go1.10 phantomjs gcc-c++ &&     zypper -n in --no-recommends -t pattern devel_basis &&     gem install bundler --no-document -v 1.17.3 &&     update-alternatives --install /usr/bin/bundle bundle /usr/bin/bundle.ruby2.6 3 &&     update-alternatives --install /usr/bin/bundler bundler /usr/bin/bundler.ruby2.6 3 &&     bundle install --retry=3 &&     go get -u github.com/vbatts/git-validation &&     go get -u github.com/openSUSE/portusctl &&     mv /root/go/bin/git-validation /usr/local/bin/ &&     mv /root/go/bin/portusctl /usr/local/bin/ &&     zypper -n rm wicked wicked-service autoconf automake            binutils bison cpp flex gdbm-devel gettext-tools            libtool m4 make makeinfo &&     zypper clean -a:
#0 7.031 File '/repositories/devel:languages:go/openSUSE_Leap_15.0/devel:languages:go.repo' not found on medium 'https://download.opensuse.org/'
#0 7.031 Abort, retry, ignore? [a/r/i/...? shows all options] (a): Cannot read input: bad stream or EOF.
#0 7.031 If you run zypper without a terminal, use '--non-interactive' global
#0 7.031 option to make zypper use default answers to prompts.
#0 7.032 Problem encountered while trying to read the file at the specified URI:
#0 7.032 Cannot read input. Bad stream or EOF.
------
Dockerfile:17
--------------------
  16 |     #      installed with the devel_basis pattern, and finally we zypper clean -a.
  17 | >>> RUN zypper addrepo https://download.opensuse.org/repositories/devel:languages:go/openSUSE_Leap_15.0/devel:languages:go.repo && \
  18 | >>>     zypper addrepo https://download.opensuse.org/repositories/devel:/tools/openSUSE_Leap_15.0/ devel:tools && \
  19 | >>>     zypper --gpg-auto-import-keys ref && \
  20 | >>>     zypper -n in --no-recommends ruby2.6-devel \
  21 | >>>            libmariadb-devel postgresql-devel \
  22 | >>>            nodejs libxml2-devel libxslt1 git-core \
  23 | >>>            go1.10 phantomjs gcc-c++ && \
  24 | >>>     zypper -n in --no-recommends -t pattern devel_basis && \
  25 | >>>     gem install bundler --no-document -v 1.17.3 && \
  26 | >>>     update-alternatives --install /usr/bin/bundle bundle /usr/bin/bundle.ruby2.6 3 && \
  27 | >>>     update-alternatives --install /usr/bin/bundler bundler /usr/bin/bundler.ruby2.6 3 && \
  28 | >>>     bundle install --retry=3 && \
  29 | >>>     go get -u github.com/vbatts/git-validation && \
  30 | >>>     go get -u github.com/openSUSE/portusctl && \
  31 | >>>     mv /root/go/bin/git-validation /usr/local/bin/ && \
  32 | >>>     mv /root/go/bin/portusctl /usr/local/bin/ && \
  33 | >>>     zypper -n rm wicked wicked-service autoconf automake \
  34 | >>>            binutils bison cpp flex gdbm-devel gettext-tools \
  35 | >>>            libtool m4 make makeinfo && \
  36 | >>>     zypper clean -a
  37 |
--------------------
ERROR: failed to solve: process "/bin/sh -c zypper addrepo https://download.opensuse.org/repositories/devel:languages:go/openSUSE_Leap_15.0/devel:languages:go.repo &&     zypper addrepo https://download.opensuse.org/repositories/devel:/tools/openSUSE_Leap_15.0/ devel:tools &&     zypper --gpg-auto-import-keys ref &&     zypper -n in --no-recommends ruby2.6-devel            libmariadb-devel postgresql-devel            nodejs libxml2-devel libxslt1 git-core            go1.10 phantomjs gcc-c++ &&     zypper -n in --no-recommends -t pattern devel_basis &&     gem install bundler --no-document -v 1.17.3 &&     update-alternatives --install /usr/bin/bundle bundle /usr/bin/bundle.ruby2.6 3 &&     update-alternatives --install /usr/bin/bundler bundler /usr/bin/bundler.ruby2.6 3 &&     bundle install --retry=3 &&     go get -u github.com/vbatts/git-validation &&     go get -u github.com/openSUSE/portusctl &&     mv /root/go/bin/git-validation /usr/local/bin/ &&     mv /root/go/bin/portusctl /usr/local/bin/ &&     zypper -n rm wicked wicked-service autoconf automake            binutils bison cpp flex gdbm-devel gettext-tools            libtool m4 make makeinfo &&     zypper clean -a" did not complete successfully: exit code: 4
ERROR: Service 'portus' failed to build : Build failed
```