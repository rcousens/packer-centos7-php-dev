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

upgrade-packages:
  module.run:
    - name: pkg.upgrade
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

apache:
  user.present:
    - groups:
      - apache
      - vagrant
    - order: last

{{ service_restart(pre_services, '2') }}
{{ service_restart(post_services, 'last') }}