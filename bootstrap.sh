#!/bin/sh

# 環境変数
export MONGO_SERVERS=${MONGO_SERVERS:-}
export MONGO_HOST=${MONGO_HOST:-127.0.0.1}
export MONGO_PORT=${MONGO_PORT:-27017}
export MONGO_USERNAME=${MONGO_USERNAME:-}
export MONGO_PASSWORD=${MONGO_PASSWORD:-}
export CAPPED_SIZE=${CAPPED_SIZE:-1024m}
export FLUSH_INTERVAL=${FLUSH_INTERVAL:-10s}

if [ -z "$MONGO_SERVERS" ]; then
    echo "Not ReplicaSet"
    export CLIENT_HOST=${MONGO_HOST}:${MONGO_PORT}  # for create_user.rb
    TEMPLATE=baas.template.conf
else
    echo "Use ReplicaSet"
    export CLIENT_HOST=${MONGO_SERVERS}  # for create_user.rb
    TEMPLATE=baas-replset.template.conf
fi

# baas.conf設定
envsubst < /fluentd/${TEMPLATE} > /fluentd/etc/conf.d/baas.conf

# 認証設定 (MONGO_PASSWORDで判定)
if [ -n "$MONGO_PASSWORD" ]; then
    echo "Enable Auth"
    mv /fluentd/etc/conf.d/baas.conf /tmp/baas.conf
    cat /tmp/baas.conf \
        | sed "s/#  user/  user/" \
        | sed "s/#  password/  password/" \
        > /fluentd/etc/conf.d/baas.conf

    echo "Run create_user.rb"
    envsubst < /fluentd/create_user.template.rb > /tmp/create_user.rb
    ruby /tmp/create_user.rb
fi

# Start fluentd
exec fluentd -c /fluentd/etc/${FLUENTD_CONF} -p /fluentd/plugins $FLUENTD_OPT
