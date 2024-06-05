user  {{ nginx.user.name }};
worker_processes  {{ ansible_processor_vcpus }};

{% if nginx_geoip == true %}
    load_module modules/ngx_http_geoip_module.so;
{% endif %}

error_log  /var/log/nginx/error.log;
pid        /var/run/nginx.pid;

events {
    worker_connections  1024;
}

http {
    include       /etc/nginx/mime.types;	
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

	client_max_body_size {{ nginx_client_max_body_size | default(8) }}m;
	server_tokens off;
	
    # Include performance settings
    include conf.d/performance.conf;

    # Activate the GZIP settings
    include conf.d/gzip.conf;
	
	# Include the defined applications
    include /etc/nginx/sites-enabled/*;
}
