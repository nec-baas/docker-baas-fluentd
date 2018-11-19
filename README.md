NECモバイルバックエンド基盤 : fluentd Dockerfile
================================================

NEC モバイルバックエンド基盤にて使用可能な、
fluentd の Docker イメージを作成するための Dockerfile です。

以下のイメージを含みます。

* necbaas/baas-fluentd

necbaas/baas-fluentd は、BaaS関連のログを MongoDB に流し込む
ように設定されます。

fluentd のポート番号として TCP/24224 ポートが EXPOSE されます。

本 Dockerfile は [docker-fluentd-mongo](https://github.com/nec-baas/docker-fluentd-mongo) に依存しています。

Docker イメージの生成
---------------------

以下手順で Docker イメージが作成されます。

    $ make image

Docker イメージ実行時の環境変数
-------------------------------

necbaas/baas-fluentd の実行時に、以下の環境変数を指定できます。

* MONGO_HOST : MongoDB サーバアドレス (default: 127.0.0.1)
* MONGO_PORT : MongoDB ポート番号 (default: 27017)
* MONGO_USERNAME : MongoDB admin DB 認証ユーザ名 (default: "")
* MONGO_PASSWORD : MongoDB admin DB 認証パスワード (default: "")
* CAPPED_SIZE : fluentd MongoDB cappedサイズ (default：1024m)
* FLUSH_INTERVAL : fluentd MongoDB flush間隔 (default：10s)
* MONGO_SERVERS : MongoDB レプリカセット使用時、カンマで区切って指定 (default: "")
