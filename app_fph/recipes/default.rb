#
# Cookbook Name:: app_fph
# Recipe:: default
#
# Copyright 2012, webicus, llc
#
# All rights reserved - Do Not Redistribute
#

# Pull rsa-key-20110128 Wallkull Chef Server ssh key from the databag.
# this key is autorized for git usage 
# ------------------------------------------------------------

db=data_bag('target')
ssh=data_bag_item('target', 'ssh')
bash "write_pem" do
  user "root"
  group "root"
  cwd "/tmp"
  code <<-EOS
echo "#{ssh['pem']}" > /root/.ssh/id_rsa
chmod 0400 /root/.ssh/id_rsa
echo "#{ssh['pub']}" > /root/.ssh/id_rsa.pub
chmod 0400 /root/.ssh/id_rsa.pub


echo "#{ssh['pem']}" > /home/ubuntu/.ssh/id_rsa
echo "#{ssh['pub']}" > /root/.ssh/id_rsa.pub
chmod 0400 /home/ubuntu/.ssh/id_rsa*
chown ubuntu /home/ubuntu/.ssh/id_rsa*
chgrp ubuntu /home/ubuntu/.ssh/id_rsa*

EOS
end




# write a file out in ~ with the name of this machine.
if node.attribute?("ec2")
  execute "identify_by_name" do
    command "touch   fph_server-#{node['ec2']['instance_id']}-$(date +%FT%H%M)"
    cwd "/home/ubuntu"
    user "ubuntu"
    group "ubuntu"
    not_if "ls /home/ubuntu/f* | grep fisn_server-"
  end
end




# Create all directories. Do not create git repo dirs i.e. one w/ .git in them.
%w(git apps backups apps/fountainpenheaven.com apps/fountainpenheaven.com/fph apps/fountainpenheaven.com/fph/current   ).each do |dir|
  directory "/home/ubuntu/#{dir}/" do
  owner "ubuntu"
  group "ubuntu"
  mode 0755
  action :create
  end
end



# ------------------------------
# Clone git repos
# ------------------------------

#m for  makalu
mrepo="ubuntu@23.21.226.62:git"
mcloud="#{mrepo}/cloud"
mfisn="#{mrepo}/fisn"
mfph="#{mrepo}/fph"
gh="git@github.com:ehwinter"
options="--depth 1"


# Populate ~ directory fisn-chef-target , scripts
%w(fisn-chef-target scripts).each do |dir|
  git "/home/ubuntu/#{dir}" do
    user "ubuntu"
    group "ubuntu"
    repository "#{mfisn}/#{dir}"
    reference "master"
    action :sync
  end
end

# Populate the ~/git/* directories.
%w(fph).each do |dir|
#%w(scripts).each do |dir|
  git "/home/ubuntu/git/#{dir}" do
    user "ubuntu"
    group "ubuntu"
    repository "#{mrepo}/#{dir}"
    reference "master"
    action :sync
  end
end


# Populate the ~/apps/* directories.
%w(fountainpenheaven.com).each do |domain|
  bash "seed_cap_deploy_directories" do
    user "ubuntu"
    group "ubuntu"
    cwd "/tmp"
    not_if "ls -a /home/ubuntu/apps/#{domain}/fph/current | grep .git"
    code <<-EOS
cp -pR /home/ubuntu/git/fph /home/ubuntu/apps/#{domain}/fph/current/
EOS
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
