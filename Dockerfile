############################################################
# Dockerfile to build Ansible Tower container images
# Based on Centos
############################################################

# Set the base image to Centos
FROM centos:6

# File Author / Maintainer
MAINTAINER Oskars Gavriševs <oskars.gavrisevs [.:ats:.] google mail.com >


################## BEGIN INSTALLATION ######################
# Install Ansible Tower Following the Instructions at Anible Tower site
# Ref: http://releases.ansible.com/ansible-tower/docs/tower_user_guide-latest.pdf

RUN yum install -y epel-release \
  && yum clean all \
  && yum update -y \
  && yum install -y \
     ansible \
     tar \
     openssh-clients \
     sudo

# remove tty from sudoers
RUN sed -i '/Defaults    requiretty/d' /etc/sudoers

# Tower version we will install
ENV version 2.1.3

# Get anible tower installation
RUN curl -o ansible-tower-setup-$version.tar.gz http://releases.ansible.com/ansible-tower/setup/ansible-tower-setup-$version.tar.gz \
  && tar -xzf ansible-tower-setup-$version.tar.gz -C /srv/ \
  && rm ansible-tower-setup-$version.tar.gz

WORKDIR /srv/ansible-tower-setup-$version

#provide tower config (password) file
ADD tower_setup_conf.yml tower_setup_conf.yml

# provide inventory file for tower installation
ADD inventory inventory

# first we will run only part of installation - > we will instal Django and releated packages
RUN ansible-playbook site.yml \
      --inventory-file=inventory \
      --skip-tags="migrations,postgresql,redis,awx,supervisor,httpd,iptables,misc"

# We will disble logging on Django framework level
# this is neede because awx-manage (tower) uses syslog and syslog is not started
RUN sed -i "s/LOGGING_CONFIG = 'django.utils.log.dictConfig'/LOGGING_CONFIG = None/" /usr/lib64/python2.6/site-packages/django/conf/global_settings.py

RUN cat /srv/ansible-tower-setup-$version/tower_setup_conf.yml

# We will process with full tower installation
RUN ansible-playbook site.yml \
      --inventory-file=inventory \
      -e @tower_setup_conf.yml \
      --skip-tags="iptables"

##################### INSTALLATION END #####################
# Expose the default port
EXPOSE 8080

CMD /etc/init.d/ansible-tower start && \
  tail -f /dev/null

