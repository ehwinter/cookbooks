#
# Cookbook Name:: app_test
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


# get a file
remote_file "robots.txt" do
  path "/tmp/robots.output.txt"
  source "http://fisn.com/robots.txt"
  mode 0777
  owner "ubuntu"
end

bash "find-date" do
  code "(cd /tmp; date)"
end


#directory "#{node[:jira][:install_path]}" do
#  recursive true
#  owner "www-data"
#end

# drop a file.
cookbook_file "/tmp/junkkdkdkd.junk.app_test.txt" do
  source "junk.app_test.txt"
  mode 0755
end
  
# erb
#template "#{node[:apache][:dir]}/sites-available/jira.conf" do
#  source "apache.conf.erb"
#  mode 0644
#end

