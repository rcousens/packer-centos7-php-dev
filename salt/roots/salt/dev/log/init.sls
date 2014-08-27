/var/log/vagrant:
  file:
    - directory
    - user: vagrant
    - group: vagrant
    - mode: 777
    - makedirs: true