FROM necbaas/fluentd-plugin-mongo

RUN mkdir -p /fluentd/etc/conf.d /fluentd/plugins

COPY prepare.template.rb /fluentd/

COPY bootstrap.sh /fluentd/
RUN chmod +x /fluentd/bootstrap.sh

COPY fluent.conf /fluentd/etc/
COPY baas.template.conf /fluentd/
COPY baas-replset.template.conf /fluentd/

# for OpenShift
RUN chmod -R ugo+rw /fluentd /tmp

ENTRYPOINT ["/fluentd/bootstrap.sh"]

CMD [""]

