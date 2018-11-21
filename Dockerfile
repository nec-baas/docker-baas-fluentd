FROM necbaas/fluentd-plugin-mongo

# install envsubst
RUN apk --no-cache add libintl \
    && apk --no-cache add --virtual .gettext gettext \
    && cp /usr/bin/envsubst /usr/local/bin/envsubst \
    && apk del .gettext

RUN mkdir -p /fluentd/etc/conf.d /fluentd/plugins

COPY create_user.template.rb /fluentd/

COPY bootstrap.sh /fluentd/
RUN chmod +x /fluentd/bootstrap.sh

COPY fluent.conf /fluentd/etc/
COPY baas.template.conf /fluentd/
COPY baas-replset.template.conf /fluentd/

# for OpenShift
RUN chmod -R ugo+rw /fluentd /tmp

ENTRYPOINT ["/fluentd/bootstrap.sh"]

CMD [""]

