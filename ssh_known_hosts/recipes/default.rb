#
# Cookbook Name:: ssh_known_hosts
# Recipe:: default
#
# Copyright 2009, Adapp, Inc.

sleep 2

template "/etc/ssh/ssh_known_hosts" do
  source "known_hosts_git_origin.erb"
  mode 0440
  owner "root"
  group "root"
  backup false
#  variables(
#    :nodes => nodes
#  )
end
template "/root/.ssh/known_hosts" do
  source "known_hosts_git_origin.erb"
  mode 0440
  owner "root"
  group "root"
  backup false
end
template "/home/ubuntu/.ssh/known_hosts" do
  source "known_hosts_git_origin.erb"
  mode 0440
  owner "ubuntu"
  group "ubuntu"
  backup false
end
