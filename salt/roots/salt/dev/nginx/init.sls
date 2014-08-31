nginx:
  pkg.latest:
    - refresh: true
  service.running:
    - enable: true
    - restart: true
    - watch:
      - file: /etc/nginx/nginx.conf
      - file: /etc/nginx/conf.d/project.conf
      - pkg: nginx

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
    - require:
      - file: /var/www/project

nginx-conf:
  file.managed:
    - name: /etc/nginx/nginx.conf
    - source: salt://_files/nginx/conf/nginx.conf
    - template: jinja
    - require:
      - file: /var/www/project/web
      - pkg: nginx

nginx-vhost-dev:
  file.managed:
    - name: /etc/nginx/conf.d/project.conf
    - source: salt://_files/nginx/vhosts/project.conf
    - template: jinja
    - require:
      - file: nginx-conf
      - pkg: nginx
