
default[:app_test][:virtual_host_name]  = "jira.#{domain}"
default[:app_test][:virtual_host_alias] = "jira.#{domain}"
default[:app_test][:version]           = "enterprise-3.13.1"
default[:app_test][:install_path]      = "/srv/jira"
default[:app_test][:run_user]          = "www-data"
default[:app_test][:database]          = "mysql"
default[:app_test][:database_host]     = "localhost"
default[:app_test][:database_user]     = "jira"
default[:app_test][:database_password] = "change_me"
