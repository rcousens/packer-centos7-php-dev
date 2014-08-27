php:
  display_errors: 'On'
  display_startup_errors: 'On'
  memory_limit: '512M'
  timezone: 'Australia/Brisbane'

mariadb:
  root_password: 'dbroot'
  user_password: 'dbuser'

pre:
  restart: ['nginx', 'php-fpm', 'mariadb']

post:
  restart: ['nginx', 'php-fpm', 'mariadb']
