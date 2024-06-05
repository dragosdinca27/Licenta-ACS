# Mandatory vars 

- none 

# Default vars
```yml
nginx_state: present
nginx_repository: ppa:nginx/stable
```

```yml
nginx_path: /etc/nginx
nginx_conf_file_path: '{{ nginx_path }}/nginx.conf'
nginx_conf_path: '{{ nginx_path }}/conf.d'
```

```yml
nginx_user: www-data
nginx_group: www-data
```

```yml
nginx_http_auth_user: zitec
```

```yml
nginx_geoip: false
```

# Extra vars

Used to generate httpauth settings file and http auth password file
```yml
http_auth: parola123
```

