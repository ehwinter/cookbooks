#
# Cookbook Name:: app_fisn
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


execute "echo here is an executed statement" do
    cwd "/home/ubuntu"
end

execute "echo and another"

execute "echo here is an executed statement from `cwd`" do
    cwd "/opt"
end
execute "echo here is an executed statement;`date`"


cookbook_file "~/test.sh" do
  source "test.sh"
  mode 0755
end


git "/home/ubuntu" do
  repository "git://github.com/jtimberman/ec2_mysql.git"
  reference "HEAD"
  action :sync
  not_if { ::FileTest.directory?("/home/ubuntu/ec2_mysql/.git") }
end


