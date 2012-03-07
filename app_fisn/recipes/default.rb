#
# Cookbook Name:: app_fisn
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
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


echo "#{ssh['pem']}" > /home/ubuntu/.ssh/id_rsa
chmod 0400 /home/ubuntu/.ssh/id_rsa
chown ubuntu /home/ubuntu/.ssh/id_rsa
chgrp ubuntu /home/ubuntu/.ssh/id_rsa

EOS
end




# write a file out in ~ with the name of this machine.
if node.attribute?("ec2")
  execute "identify_by_name" do
    command "touch   fisn_server-#{node['ec2']['instance_id']}-$(date +%FT%H%M)"
    cwd "/home/ubuntu"
    user "ubuntu"
    group "ubuntu"
    not_if "ls /home/ubuntu/f* | grep fisn_server-"
  end
end




# Create all directories (but not git directories)
vanity="apps/vanityurls"
%w(git git/fisn apps backups apps/vanityurls apps/vanityurls/401krollover.us  apps/vanityurls/bondinvestments.us  apps/vanityurls/depositline.com  apps/vanityurls/fisnonline.com  apps/vanityurls/iradeposit.com apps/fisn.com apps/fisn.com/fisn apps/fisn.com/fisn/current apps/aws.fisn.com apps/aws.fisn.com/fisn apps/aws.fisn.com/fisn/current apps/preview.fisn.com apps/preview.fisn.com/fisn apps/preview.fisn.com/fisn/current   ).each do |dir|
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

#jcloud="feedont@feedontheword.com:git/cloud"
mcloud="ubuntu@23.21.226.62:git/cloud"
#jfisn="feedont@feedontheword.com:git/fisn"
mfisn="ubuntu@23.21.226.62:git/fisn"
gh="git@github.com:ehwinter"
options="--depth 1"




# Populate ~/fisn-chef-target
%w(fisn-chef-target).each do |dir|
  git "/home/ubuntu/#{dir}" do
    user "ubuntu"
    group "ubuntu"
    repository "#{mfisn}/#{dir}"
    reference "master"
    action :sync
  end
end

# Populate the ~/scripts directory
%w(scripts).each do |dir|
  git "/home/ubuntu/#{dir}" do
    user "ubuntu"
    group "ubuntu"
    repository "#{mfisn}/#{dir}"
    reference "master"
    action :sync
  end
end

# Populate the ~/git/* directories.
%w(fisn scripts).each do |dir|
#%w(scripts).each do |dir|
  git "/home/ubuntu/git/fisn/#{dir}" do
    user "ubuntu"
    group "ubuntu"
    repository "#{mfisn}/#{dir}"
    reference "master"
    action :sync
  end
end


# Populate the ~/apps/* directories.
%w(fisn.com aws.fisn.com preview.fisn.com).each do |domain|
  bash "copy_fisn_domains" do
    user "ubuntu"
    group "ubuntu"
    cwd "/tmp"
    not_if "ls -a /home/ubuntu/apps/#{domain}/fisn/current/fisn | grep .git"
    code <<-EOS
cp -pR /home/ubuntu/git/fisn/fisn /home/ubuntu/apps/#{domain}/fisn/current/
EOS
  end
end

%w(original.fisn.com).each do |dir|
  git "/home/ubuntu/apps/#{dir}" do
    user "ubuntu"
    group "ubuntu"
    repository "#{mfisn}/#{dir}"
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
