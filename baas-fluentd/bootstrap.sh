#!/bin/sh

# 環境変数
MONGO_HOST=${MONGO_HOST:-127.0.0.1}
MONGO_PORT=${MONGO_PORT:-27017}
MONGO_USERNAME=${MONGO_USERNAME:-}
MONGO_PASSWORD=${MONGO_PASSWORD:-}
CAPPED_SIZE=${CAPPED_SIZE:-1024m}
FLUSH_INTERVAL=${FLUSH_INTERVAL:-10s}
MONGO_SERVERS=${MONGO_SERVERS:-}

# MongoDB 1台構成用設定
setNotReplset() {
# script設定 (MongoDB認証なしの場合は不要な処理だが、分岐を減らすためにここで設定)
    sed -e "5i\client_host = ['%MONGO_HOST%:%MONGO_PORT%']" -i /fluentd/prepare.template.rb
    cat /fluentd/prepare.template.rb \
        | sed "s/%MONGO_HOST%/$MONGO_HOST/" \
        | sed "s/%MONGO_PORT%/$MONGO_PORT/" \
        > /tmp/prepare.template2.rb

# baas.conf設定
    cat /fluentd/baas.template.conf \
        | sed "s/%MONGO_HOST%/$MONGO_HOST/" \
        | sed "s/%MONGO_PORT%/$MONGO_PORT/" \
        > /tmp/baas.template2.conf

    return 0
}

# MongoDB レプリカセット構成用設定
setReplset() {
    echo "Set ReplicaSet"
# script設定 (MongoDB認証なしの場合は不要な処理だが、分岐を減らすためにここで設定)
    sed -e "5i\client_host = ['%MONGO_SERVERS%']" -i /fluentd/prepare.template.rb
    cat /fluentd/prepare.template.rb \
        | sed "s/%MONGO_SERVERS%/$MONGO_SERVERS/" \
        > /tmp/prepare.template2.rb

# baas.conf設定
    cat /fluentd/baas-replset.template.conf \
        | sed "s/%MONGO_SERVERS%/$MONGO_SERVERS/" \
        > /tmp/baas.template2.conf

    return 0
}

# 認証設定
setAuth() {
    echo "Set Auth"
# script設定
    cat /tmp/prepare.template2.rb \
        | sed "s/%MONGO_USERNAME%/$MONGO_USERNAME/" \
        | sed "s/%MONGO_PASSWORD%/$MONGO_PASSWORD/" \
        > /tmp/prepare.rb

# baas.conf設定
    cat /tmp/baas.template3.conf \
        | sed "s/#  user %MONGO_USERNAME%/  user %MONGO_USERNAME%/" \
        | sed "s/#  password %MONGO_PASSWORD%/  password %MONGO_PASSWORD%/" \
        > /fluentd/baas.conf
    cat /fluentd/baas.conf \
        | sed "s/%MONGO_USERNAME%/$MONGO_USERNAME/" \
        | sed "s/%MONGO_PASSWORD%/$MONGO_PASSWORD/" \
        > /fluentd/etc/conf.d/baas.conf

    echo "prepare.rb"
    ruby /tmp/prepare.rb

    return 0
}

if [ ! -n "$MONGO_SERVERS" ]; then
    setNotReplset
else
    setReplset
fi

# baas.conf共通設定
cat /tmp/baas.template2.conf \
    | sed "s/%CAPPED_SIZE%/$CAPPED_SIZE/" \
    | sed "s/%FLUSH_INTERVAL%/$FLUSH_INTERVAL/" \
    > /tmp/baas.template3.conf

# 認証設定 (MONGO_PASSWORDで判定)
if [ ! -n "$MONGO_PASSWORD" ]; then
    cat /tmp/baas.template3.conf > /fluentd/etc/conf.d/baas.conf
else
    setAuth
fi

# Start fluentd
exec fluentd -c /fluentd/etc/${FLUENTD_CONF} -p /fluentd/plugins $FLUENTD_OPT
