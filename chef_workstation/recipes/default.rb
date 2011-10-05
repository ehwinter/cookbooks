#
# Cookbook Name:: chef_workstation
# Recipe:: default
#
# Copyright 2011, webicus, llc
#
# All rights reserved - Do Not Redistribute
#

db=data_bag('walkull')
ssh=data_bag_item('walkull', 'ssh')

# write the pem file to .ssh
# ------------------------------
bash "write_pem" do
  code <<-EOS
echo "#{ssh['pem']}" > /root/.ssh/id_rsa
chmod 0400 /root/.ssh/id_rsa
chgrp root /root/.ssh/id_rsa
chown root /root/.ssh/id_rsa


echo "#{ssh['pem']}" > /home/ubuntu/.ssh/id_rsa
chmod 0400 /home/ubuntu/.ssh/id_rsa
chgrp ubuntu /home/ubuntu/.ssh/id_rsa
chown ubuntu /home/ubuntu/.ssh/id_rsa


EOS
end


# write a file out in ~ with the name of this machine.
if node.attribute?("ec2")
  execute "identify_by_name" do
    command "touch   walkull-#{node['ec2']['instance_id']}"
    cwd "/home/ubuntu"
    user "ubuntu"
    group "ubuntu"
  end
end



# ------------------------------
# Clone git repos
# ------------------------------

jcloud="feedont@feedontheword.com:git/cloud"
jfisn="feedont@feedontheword.com:git/fisn"
options="--depth 1"

# Clone the fisn resources
execute "clone_walkull" do
  command "git clone  #{options}  #{jcloud}/walkull"
  cwd "/home/ubuntu"
  user "ubuntu"
  group "ubuntu"
  creates "/home/ubuntu/walkull/.git"
end


execute "clone_chef_repo" do
  command "git clone #{options}  #{jcloud}/chef-repo.git"
  cwd "/home/ubuntu"
  user "ubuntu"
  group "ubuntu"
  creates "/home/ubuntu/chef-repo/.git"
end


# Clone the fisn resources
%w{fisn-chef-target}.each do |dir|
  execute "clone_#{dir}" do
    command "git clone #{options}  #{jfisn}/#{dir}"
    cwd "/home/ubuntu"
    user "ubuntu"
    group "ubuntu"
    creates "/home/ubuntu/#{dir}/.git"
  end
end


# ------------------------------
# Copy files as appropriate
# ------------------------------


# Clone the fisn resources
execute "copy_walkull_bin_files" do
  command "cp -pR  /home/ubuntu/walkull/config/bin /home/ubuntu"
  cwd "/home/ubuntu"
  user "ubuntu"
  group "ubuntu"
  creates "/home/ubuntu/bin"
end


