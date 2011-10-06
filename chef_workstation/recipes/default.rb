#
# Cookbook Name:: chef_workstation
# Recipe:: default
#
# Copyright 2011, webicus, llc
#
# All rights reserved - Do Not Redistribute
#



# Pull rsa-key-20110128 Wallkull Chef Server ssh key from the databag.
# this key is autorized for git usage 
# ------------------------------------------------------------

db=data_bag('walkull')
ssh=data_bag_item('walkull', 'ssh')
bash "write_pem" do
  user "root"
  group "root"
  cwd "/tmp"
  code <<-EOS
echo "#{ssh['pem']}" > /root/.ssh/id_rsa
chmod 0400 /root/.ssh/id_rsa


echo "#{ssh['pem']}" > /home/ubuntu/.ssh/id_rsa
chmod 0400 /home/ubuntu/.ssh/id_rsa
chown ubuntu /home/ubuntu/.ssh/id_rsa
chgrp ubuntu /home/ubuntu/.ssh/id_rsa

EOS
end




# write a file out in ~ with the name of this machine.
if node.attribute?("ec2")
  execute "identify_by_name" do
    command "touch   walkull-#{node['ec2']['instance_id']}-$(date +%F%H%M)"
    cwd "/home/ubuntu"
    user "ubuntu"
    group "ubuntu"
    not_if "ls /home/ubuntu/w* | grep walkull-"
  end
end





# ------------------------------
# Clone git repos
# ------------------------------

jcloud="feedont@feedontheword.com:git/cloud"
jfisn="feedont@feedontheword.com:git/fisn"
options="--depth 1"



# Clone the fisn resources
git "/home/ubuntu/walkull" do
  user "ubuntu"
  group "ubuntu"
  repository "#{jcloud}/walkull"
  reference "master"
  action :sync
end

git "/home/ubuntu/chef-repo" do
  user "ubuntu"
  group "ubuntu"
  repository "#{jcloud}/chef-repo.git"
  reference "master"
  action :sync
end



# Clone the fisn resources
%w(fisn-chef-target).each do |dir|
  git "/home/ubuntu/#{dir}" do
    user "ubuntu"
    group "ubuntu"
    repository "#{jfisn}/#{dir}"
    reference "master"
    action :sync
  end
end




# ------------------------------
# Copy files as appropriate
# ------------------------------



# refernce .bashrc - this is needed to setup aws_keys
template "/home/ubuntu/.bashrc" do
  source "bashrc.erb"
  owner "ubuntu"
  group  "ubuntu"
  mode "0750"
end


# create bin directory via copy
execute "copy_walkull_bin_files" do
  command "cp -pR  /home/ubuntu/walkull/config/bin /home/ubuntu"
  cwd "/home/ubuntu"
  user "ubuntu"
  group "ubuntu"
  creates "/home/ubuntu/bin"
end



# Copy other useful pem files (came in via git clone)
ref_ssh="/home/ubuntu/walkull/config/ref/.ssh"
to="/home/ubuntu/.ssh"
%w("fisn-aws-key.pem" "fisn-aws-west.pem" "walkull-chef-server.pem" "webicus-validator.pem" "ehwinter.pem" ).each do |file|
  execute "#{file}" do
    command "cp -f #{ref_ssh}/#{file} #{to}"
    cwd "/home/ubuntu"
    user "ubuntu"
    group "ubuntu"
  end
end

# Copy .aws_keys used by .bashrc to switch AWS keys.
ref="/home/ubuntu/walkull/config/ref"
to="/home/ubuntu/"
%w(".aws_keys").each do |file|
  execute "#{file}" do
    command "cp -f #{ref}/#{file} #{to}"
    cwd "/home/ubuntu"
    user "ubuntu"
    group "ubuntu"
  end
end

execute "chmods" do
  command "chmod 0700  .ssh .ssh/* .aws_keys"
  cwd "/home/ubuntu"
  user "ubuntu"
  group "ubuntu"
end
