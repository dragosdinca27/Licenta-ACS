concurrent = {{ gitlab_runner_config.concurrent }}
check_interval = 0

[session_server]
  session_timeout = 1800

[[runners]]
  name = "{{ gitlab_runner_name }}"
  url = "{{ gitlab_runner_url }}"
  token = "{{ gitlab_runner_token }}"
  executor = "docker"
  [runners.custom_build_dir]
  [runners.cache]
    [runners.cache.s3]
    [runners.cache.gcs]
    [runners.cache.azure]
  [runners.docker]
    tls_verify = false
    image = "alpine:latest"
    privileged = false
    disable_entrypoint_overwrite = false
    oom_kill_disable = false
    disable_cache = false
    volumes = ["/cache"]
    shm_size = 0
