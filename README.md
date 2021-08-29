# MariaDB ColumnStore Single Node on Docker

MariaDB ColumnStoreシングルノードをDockerfile化したものです。

バージョンは`1.2.5`を使用しています。MariaDBパッケージに統合される前の最新バージョンです。

# データ永続化

必要に応じて、以下のディレクトリを永続化してください。

|          | ディレクトリ                    |
| :------- | :------------------------------ |
| DBデータ | /usr/local/mariadb/columnstore/ |
| ログ     | /var/log/                       |

# 起動

`docker run -d --restart always -v mcs-data:/usr/local/mariadb/columnstore/ -v mcs-log:/var/log/ mariadb-columnstore-single-node`

# ビルド

`docker build -t mariadb-columnstore-single-node .`