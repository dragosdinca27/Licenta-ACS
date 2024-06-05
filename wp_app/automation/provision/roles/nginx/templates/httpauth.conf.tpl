satisfy any;

# Allow local connections.
allow 127.0.0.1/32;

# Allow from Zitec Bucharest HQ.
allow 89.38.134.100/32;
allow 86.125.12.103/32;
# Allow from Zitec Brasov.
allow 86.123.166.32/32;

# Allow from Zitec Bucharest HQ - GTS
allow 212.146.66.99/32;
allow 212.146.66.65/32;
# Allow from Zitec Brasov - GTS
allow 212.146.102.125/32;

# Allow jenkins slave - GTS
allow 212.146.66.67/32;

# Allow jenkins.zitec.ro (54.195.246.87).
allow 54.195.246.87/32;

# Allow GitLab Runners
allow 35.246.129.139/32;

# Allow ips explicitly defined.
{% for ip in item.value.http_auth_allowed_ips|default([]) %}
allow {{ ip }};
{% endfor %}

deny all;

auth_basic           "Restricted web site";
auth_basic_user_file conf.d/passwdfile;
