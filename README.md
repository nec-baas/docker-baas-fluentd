NECモバイルバックエンド基盤 : fluentd Dockerfile
================================================

NEC モバイルバックエンド基盤にて使用可能な、
fluentd の Docker イメージを作成するための Dockerfile です。

以下2つのイメージを含みます。

* necbaas/fluentd-plugin-mongo: fluentd に fluent-plugin-mongo を追加したもの
* necbaas/baas-fluentd: BaaSサーバ設定付き fluentd

necbaas/baas-fluentd は、BaaS関連のログを MongoDB に流し込む
ように設定されます。

fluentd のポート番号として TCP/24224 ポートが EXPOSE されます。

Docker イメージの生成
---------------------

以下手順で Docker イメージが作成されます。

    $ (cd fluentd-plugin-mongo && make image)
    $ (cd baas-fluentd && make image)

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
