# Mandatory vars

php_version variable is mandatory to be defined in the playbooks in order to prevent default version installation or worst undesired PHP update on existing installations
```yml
php_version: 7.2
```

# Default vars

```yml
php_packages_state: present
php_repository: ppa:ondrej/php
```

```yml
php_path: /etc/php/{{ php_version }}
php_cli_ini_path: '{{ php_path }}/cli/php.ini'
php_fpm_ini_path: '{{ php_path }}/fpm/php.ini'
php_fpm_conf_path: '{{ php_path }}/fpm/php-fpm.conf'
php_fpm_pool_path: '{{ php_path }}/fpm/pool.d'
php_apache_ini_path: '{{ php_path }}/apache2/php.ini'
php_fpm_daemon: php{{ php_version }}-fpm
php_fpm_service: php-fpm{{ php_version }}
```

```yml
php_cli: true
php_fpm: true
php_mysql: true
```

```yml
php_default_packages:
  - php{{ php_version }}-intl
  - php{{ php_version }}-curl
  - php{{ php_version }}-xml
  - php{{ php_version }}-zip
```

```yml
php_timezone: Europe/Bucharest
```

```yml
php_fpm_default_conf:
  - option: log_level
    value: warning
```

```yml
php_fpm_ini_default_conf:
  - section: Date
    option: date.timezone
    value: '{{ php_timezone }}'
  - section: PHP
    option: error_log
    value: /var/log/php/error.log
  - section: opcache
    option: opcache.enable
    value: 1
```

```yml
php_cli_ini_default_conf:
  - section: Date
    option: date.timezone
    value: '{{ php_timezone }}'
  - section: opcache
    option: opcache.enable
    value: 1
```

```yml
php_fpm_pool_default_conf:
  - option: listen.owner
    value: nginx
  - option: listen.group
    value: nginx
```

```yml
php_composer: false
php_composer_binary_path: /usr/local/bin/composer
php_composer_self_update: true
```

# Extra vars

Install additional packages
```yml
php_packages:
  - php{{ php_version }}-gd
  - php{{ php_version }}-mbstring
  - php-tideway
```
Section is by default: "PHP". Specify it only when it's different.
```yml
php_cli_ini_conf:
    - option: memory_limit
      value: 512M
    - section: different-than-PHP
      option: something
      value: 30
```

Section is by default: "PHP". Specify it only when it's different.
```yml
php_fpm_ini_conf:
  - option: include_path
    value: '".:/usr/local/src/ZendFramework-1.12.20/library"'
  - section: different-than-PHP
    option: something
    value: 10
```

Section is by default: "www". Specify it only when it's different.
```yml
php_fpm_pool_conf:
  - option: pm.max_children
    value: 25
  - section: different-than-www
    option: something
    value: 20
```

Section is by default: "global". Specify it only when it's different.
```yml
php_fpm_conf::
  - option: emergency_restart_threshold
    value: 1
  - section: different-than-global
    option: something
    value: 30
```

Section is by default: "PHP". Specify it only when it's different.
```yml
php_apache_ini_conf:
  - option: max_t
    value: 1
  - section: different-than-PHP
    option: something
    value: 30
```

Install Ioncube Loaders
```yml
ioncube_loader_file: true
```

Install Xdebug
```yml
php_xdebug: true
```

Custom FPM user
```yml
php_fpm_custom_user: true
# and default:
php_fpm_custom_user_options:
  user_and_group: www-data
  pid_and_sock_file_path: /run/php
  log_file_path: /var/log/php{{ php_version }}-fpm.log
# and these:
php_fpm_pool_default_conf:
  - option: listen.owner
    value: www-data
  - option: listen.group
    value: www-data
  - option: user
    value: www-data
  - option: group
    value: www-data
```