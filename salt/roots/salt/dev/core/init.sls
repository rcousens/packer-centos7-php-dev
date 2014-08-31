include:
  - mariadb
  - nginx
  - php
  - redis

{% macro service_restart(services, order) %}
  {%- for service in services %}
restart-{{ service }}-{{ order }}:
  module.run:
    - name: service.restart
    - m_name: {{ service }}
    - order: {{ order }}
  {%- endfor -%}
{% endmacro %}

{% set pre_services = salt['pillar.get']('pre:restart', []) %}
{% set post_services = salt['pillar.get']('post:restart', []) %}
{% set update = salt['pillar.get']('update:on_provision', false) %}

{% if update == true %}
upgrade-packages:
  module.run:
    - name: pkg.upgrade
    - order: 1
{% endif %}

/var/log/vagrant:
  file:
    - directory
    - user: vagrant
    - group: vagrant
    - mode: 775
    - makedirs: true
    - order: 1

sudoers:
  file.managed:
    - name: /etc/sudoers
    - source: salt://_files/sudo/sudoers
    - template: jinja
    - order: last

vagrant:
  file.managed:
    - name: /etc/sudoers.d/vagrant
    - source: salt://_files/sudo/vagrant
    - template: jinja
    - order: last

{% for service-user in ['apache','mysql','nginx','redis'] %}
{{ service-user }}-user:
  user.present:
    - name: {{ service-user }}
    - groups:
      - {{ service-user }}
      - vagrant
    - require:
      - sls: mariadb
      - sls: nginx      
      - sls: php
      - sls: redis
{% endfor %}

{{ service_restart(pre_services, '2') }}
{{ service_restart(post_services, 'last') }}