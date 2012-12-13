{# Nagios NRPE Agent #}

include:
  - pip
  - mercurial

nagiosplugin:
  hg:
    - latest
    - name: https://bitbucket.org/gocept/nagiosplugin
    - rev: e19416f378f72de7acd6d88068562cef2b4f7119
    - target: /usr/local/nagiosplugin
    - require:
      - pkg: mercurial
  module:
    - wait
    - name: pip.install
    - pkgs: /usr/local/nagiosplugin
    - upgrade: True
    - require:
      - pkg: python-pip
    - watch:
      - hg: nagiosplugin

nagios-nrpe-server:
  pkg:
    - latest
    - names:
      - nagios-nrpe-server
      - nagios-plugins-standard
      - nagios-plugins-basic
  file:
    - managed
    - name: /etc/nagios/nrpe.d/000-nagios-servers.cfg
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://nrpe/config.jinja2
    - require:
      - pkg: nagios-nrpe-server
  service:
    - running
    - enable: True
    - watch:
      - pkg: nagios-nrpe-server
      - file: nagios-nrpe-server
