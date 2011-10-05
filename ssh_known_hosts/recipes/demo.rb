#
# Cookbook Name:: ssh_known_hosts
# Recipe:: demo
#
# this demonstrates:
#  running a bash script
#  echoing to stdout
sleep 2

# Run a bash script to output stuff.
bash "stdout test" do
  code <<-EOS
echo "from bash: print 1"
sleep 5
echo "print 2"
EOS
end

execute "stdout test2" do
  command "bash -c 'echo \"print 1\"; sleep 5; echo \"print 2\"'"
end

script "stdout test3" do
  interpreter "bash"
  code "echo 'print 1'; sleep 5; echo 'print 2'"
end







