# RStudioでPostgreSQLを使用する

## 環境構築の流れ
以下のようなcsvファイルをDBのテーブルに挿入し、RStudioからアクセスしたい。
|id|name|
|--|--|
|1|Taro|
|2|Jiro|
|3|Hanako|
|4|Pochi|

### リポジトリのクローン
はじめに、リポジトリをローカル環境にクローンする。
```bash
$ git clone https://github.com/Aconitum3/R_DB
```

### プロジェクトの起動
次のコマンドを実行してコンテナに接続する。
```bash
$ cd R_DB/PostgreSQL/project
$ docker-compose up
```
DBの起動を少し待った後、`myproject`ディレクトリ下の`main.R`を順に実行すれば、データを呼び出せる。

## 各要素の説明

本節では`Dockerfile`と`docker-compose.yml`の詳しい内容を説明する。
### ディレクトリ構成
```
project/
　├ DB/
　│ 　├ Dockerfile
　│ 　├ init.sh
　│ 　└ mytable.csv
　├ Rstudio/
　│ 　├ Dockerfile
　│ 　└ packages.R
　├ docker-compose.yml
　└ mountpoint/
```

### `DB/Dockerfile`

```Dockerfile
FROM postgres:14

COPY init.sql /docker-entrypoint-initdb.d/
COPY mytable.csv /home/
```
PostgreSQLイメージでは、`docker-entrypoint-init.d`下に`.sql`ファイルをおくと、コンテナ作成時に自動実行される。init.sqlは次のようになっている。

```sql
-- init.sql

CREATE TABLE mytable 
( 
    id int, 
    name char(20)
);

\COPY mytable FROM '/home/mytable.csv' DELIMITER ',' CSV HEADER;
```
テーブル`mytable`を作成し、`mytable.csv`のデータを取り込んでいる。

### `RStudio/Dockerfile`

```Dockerfile
FROM rocker/rstudio:4

RUN apt-get update \
  && apt-get install libpq-dev -y

COPY packages.R ./

EXPOSE 8787

RUN Rscript packages.R
```
M1チップのMacOSでは`rocker/rstudio:4`が利用できないため、別のイメージを使う必要がある。例えば、`amoselb/rstudio-m1`などがある。

PostgreSQLを利用するには、`libpq-dev`をインストールする必要がある。

packages.Rでは、RでPostgreSQLを扱うためのパッケージ`RPostgreSQL`をインストールしている。
```R
# packages.R

install.packages("RPostgreSQL")
```

### `docker-compose.yml`
```yaml
version: "2"
services:
  r:
    build:
      context: RStudio
      dockerfile: Dockerfile
    volumes:
      - ./mountpoint:/home/rstudio/myproject
    ports:
     - "8787:8787"
    depends_on:
      db:
        condition: service_started
  db:
    build:
      context: DB
      dockerfile: Dockerfile
    environment:
      - POSTGRES_USER=root
      - POSTGRES_PASSWORD=root
      - POSTGRES_DB=db
```
作業ディレクトリ`/home/rstudio`下の`myproject`ディレクトリをローカルディレクトリ`./mountpoint`にマウントしている。

`r`は`db`起動後に起動させたいため、`depends_on`で`condition: service_started`の設定をしている。

`POSTGRES_DB`は初期化時に作成されるデータベースの名前を指定している。`POSTGRES_USER`, `POSTGRES_PASSWORD`はそれぞれ権限ユーザーのユーザー名
とパスワードである。