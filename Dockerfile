ARG VERSION
FROM osism/horizon:$VERSION

LABEL maintainer="Betacloud Solutions GmbH (https://www.betacloud-solutions.de)"

COPY files/img /var/lib/kolla/venv/lib/python2.7/site-packages/openstack_dashboard/static/dashboard/img
COPY files/src /var/lib/kolla/venv/lib/python2.7/site-packages/betacloud_customization_module
