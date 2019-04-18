package "apache2" do
 action :install
 only_if { node['platform'] == 'ubuntu' }
end
