redis:
  pkg.latest:
    - refresh: true
  service.running:
    - enable: true
