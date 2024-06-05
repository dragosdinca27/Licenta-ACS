# Disable letsencrypt
letsencrypt['enable'] = false

# Disable the built-in Postgres
postgresql['enable'] = false

# PostgreSQL connection details
gitlab_rails['db_adapter'] = 'postgresql'
gitlab_rails['db_encoding'] = 'unicode'
gitlab_rails['db_host'] = '10.201.0.5' # IP/hostname of database server
gitlab_rails['db_username'] = 'gitlab-prod'
gitlab_rails['db_password'] = '{{ postgresql_password }}'

### GitLab email server settings
###! Docs: https://docs.gitlab.com/omnibus/settings/smtp.html
gitlab_rails['smtp_enable'] = true
gitlab_rails['smtp_address'] = "smtp.sendgrid.net"
gitlab_rails['smtp_port'] = 587
gitlab_rails['smtp_user_name'] = "apikey"
gitlab_rails['smtp_password'] = "{{ sendgrid_password }}"
gitlab_rails['smtp_domain'] = "smtp.sendgrid.net"
gitlab_rails['smtp_authentication'] = "login"
gitlab_rails['smtp_enable_starttls_auto'] = true
gitlab_rails['smtp_tls'] = false

### Email Settings
gitlab_rails['gitlab_email_enabled'] = true
gitlab_rails['gitlab_email_from'] = 'notifications@gitlab.zitec.com'

# Omniauth Settings
gitlab_rails['omniauth_enabled'] = true
gitlab_rails['omniauth_allow_single_sign_on'] = ['google_oauth2']
gitlab_rails['omniauth_block_auto_created_users'] = false
gitlab_rails['omniauth_allow_bypass_two_factor'] = ['google_oauth2']

# Omniauth Providers
gitlab_rails['omniauth_providers'] = [
  {
    "name" => "google_oauth2",
    "app_id" => "188106535757-ur3gipc2fthot6647s1l56jpqkttbbo2.apps.googleusercontent.com",
    "app_secret" => "{{ google_oauth2_app_secret }}",
    "args" => { "access_type" => "offline", "approval_prompt" => '' }
  }
]

# Ldap Settings
gitlab_rails['ldap_enabled'] = false
