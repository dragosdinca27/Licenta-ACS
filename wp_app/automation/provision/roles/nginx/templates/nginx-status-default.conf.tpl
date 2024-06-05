server {
  listen {{ nginx_status_listen_port }};
  server_name {{ nginx_status_server_name }};

  access_log off;

  satisfy any;
{% for ip in nginx_status_allowed_ips %}
  allow {{ ip }};
{% endfor %}
  deny all;

  location /nginx_status {
    stub_status on;
  }
}
