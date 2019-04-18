#package "apache2" do
#action :install
#end

#service "apache2" do
#/action :start
#end

packages = ['apache2', 'mysql-server', 'mysql-client', 'php', 'libapache2-mod-php', 'php-mcrypt php-mysql']

packages.each do |insta|
apt_package insta do
 action :install
 end
end

service "apache2" do
action :start
end

execute 'mysqladmin' do
   command "mysqladmin -u root password rootpassword"
end

remote_file "mysqlcommand" do
 source 'https://gitlab.com/roybhaskar9/devops/raw/master/coding/chef/chefwordpress/files/default/mysqlcommands'
 path "/tmp/mysqlcommands"
end

execute 'mysqlcommand' do
   command "mysql -uroot -prootpassword < /tmp/mysqlcommands"
end

remote_file "wordpress" do
 source 'https://wordpress.org/latest.zip'  
 path "/tmp/latest.zip"
end


package "unzip" do
action :install
end

execute 'unzip' do
   command "sudo unzip /tmp/latest.zip -d /var/www/html"
end

remote_file "config-sample" do
 source 'https://gitlab.com/roybhaskar9/devops/raw/master/coding/chef/chefwordpress/files/default/wp-config-sample.php'
 path "/var/www/html/wordpress/wp-config.php"
end

file '/var/www/html/wordpress' do
  mode '755'
#  owner 'www-data:www-data'
end

service "apache2" do
action :restart
end
 
