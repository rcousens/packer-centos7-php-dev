{% set mariadb_root_pass = salt['pillar.get']('mariadb:root_password', 'password') %}
{% set mariadb_user_pass = salt['pillar.get']('mariadb:user_password', 'password') %}

mysql-python:
  pkg.latest:
    - name: MySQL-python

mariadb:
  pkg.latest:
    - name: mariadb-server
  service.running:
    - name: mariadb
    - enable: true
    - watch:
      - pkg: mariadb
      - file: mariadb-conf

mariadb-conf:
  file.managed:
  - name: /etc/my.cnf.d/server.cnf
  - source: salt://_files/mariadb/server.cnf
  - template: jinja
  - require:
    - pkg: mariadb

mariadb-root-password:
  cmd.run:
    - name: mysqladmin --user root password {{ mariadb_root_pass }}
    - unless: mysql --user root --password={{ mariadb_root_pass }} --execute="SELECT 1;"
    - require:
      - service: mariadb

mariadb-delete-anonymous-user:
  mysql_user:
    - absent
    - host: localhost
    - name: ''
    - connection_host: localhost
    - connection_user: root
    - connection_pass: {{ mariadb_root_pass }}
    - connection_charset: UTF8
    - require:
      - service: mariadb
      - pkg: mysql-python
      - cmd: mariadb-root-password

mariadb-default-user:
  mysql_user.present:
    - name: dbuser
    - host: '%'
    - password: {{ mariadb_user_pass }}
    - connection_host: localhost
    - connection_user: root
    - connection_pass: {{ mariadb_root_pass }}
    - connection_charset: UTF8
    - require:
      - service: mariadb
      - pkg: mysql-python
      - cmd: mariadb-root-password

mariadb-default-privileges:
  mysql_grants.present:
    - name: dbuser_all
    - grant: all privileges
    - database: '*.*'
    - user: dbuser
    - host: '%'
    - connection_host: localhost
    - connection_user: root
    - connection_pass: {{ mariadb_root_pass }}
    - connection_charset: utf8
    - require:
      - mysql_user: dbuser
      - service: mariadb
      - pkg: mysql-python
      - cmd: mariadb-root-password
      