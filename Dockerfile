ARG SOURCE
ARG VERSION
FROM $SOURCE:$VERSION

COPY files/img /var/lib/kolla/venv/lib/python2.7/site-packages/openstack_dashboard/static/dashboard/img
COPY files/src /var/lib/kolla/venv/lib/python2.7/site-packages/betacloud_customization_module

LABEL "org.opencontainers.image.documentation"="https://docs.betacloud.io" \
      "org.opencontainers.image.licenses"="ASL 2.0" \
      "org.opencontainers.image.source"="https://github.com/betacloud/docker-horizon" \
      "org.opencontainers.image.url"="https://www.osism.de" \
      "org.opencontainers.image.vendor"="Betacloud Solutions GmbH"
