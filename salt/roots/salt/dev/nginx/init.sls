include:
  - log

nginx:
  pkg.latest:
    - refresh: true
  service.running:
    - enable: true
    - restart: true
    - watch:
      - file: /etc/nginx/nginx.conf
      - file: /etc/nginx/conf.d/app.conf
      - pkg: nginx
    - require:
      - sls: log

/var/www/project:
  file:
    - directory
    - user: vagrant
    - group: vagrant
    - makedirs: true

/var/www/project/web:
  file:
    - directory
    - user: vagrant
    - group: vagrant
    - makedirs: true

nginx-conf:
  file.managed:
    - name: /etc/nginx/nginx.conf
    - source: salt://_files/nginx/conf/nginx.conf
    - template: jinja
    - require:
      - file: /var/www/app
      - pkg: nginx

nginx-vhost-dev:
  file.managed:
    - name: /etc/nginx/conf.d/app.conf
    - source: salt://_files/nginx/vhosts/app.conf
    - template: jinja
    - require:
      - file: nginx-conf
      - pkg: nginx
