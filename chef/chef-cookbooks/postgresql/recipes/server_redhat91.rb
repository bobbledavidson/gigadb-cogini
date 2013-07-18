#
# Cookbook Name:: postgresql
# Recipe:: server
#
# Author:: Joshua Timberman (<joshua@opscode.com>)
# Author:: Lamont Granquist (<lamont@opscode.com>)
# Copyright 2009-2011, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "postgresql::client91"

# Create a group and user like the package will.
# Otherwise the templates fail.

group "postgres" do
  gid 26
end

user "postgres" do
  shell "/bin/bash"
  comment "PostgreSQL Server"
  home "/var/lib/pgsql"
  gid "postgres"
  system true
  uid 26
  supports :manage_home => false
end

package "postgresql" do
  case node.platform
  when "redhat","centos","scientific"
    case
    when node.platform_version.to_f >= 6.0
      package_name "postgresql"
    else
      package_name "postgresql#{node['postgresql']['version'].split('.').join}"
    end
  else
    package_name "postgresql"
  end
end

case node.platform
when "redhat","centos","scientific"
  case
  when node.platform_version.to_f >= 6.0
    package "postgresql-server"
  else
    package "postgresql#{node['postgresql']['version'].split('.').join}-server"
  end
when "fedora","suse"
  package "postgresql-server"
end

template "/etc/init.d/postgresql-9.1" do
  source "_etc_init.d_postgresql-9.1.erb"
  mode "0755"
end

execute "/sbin/service postgresql-9.1 initdb" do
  not_if { ::FileTest.exist?(File.join(node.postgresql.dir, "PG_VERSION")) }
end

template "#{node[:postgresql][:dir]}/postgresql.conf" do
  source "redhat.postgresql.conf.erb"
  owner "postgres"
  group "postgres"
  mode 0600
end


archive_dir = node.postgresql.config.archive_dir

if node.postgresql.is_slave
    template "#{node.postgresql.dir}/recovery.conf" do
      source "recovery.conf.erb"
      owner "postgres"
      group "postgres"
      mode 0600
      variables({
          :master_host => node.postgresql.master_host,
          :archive_dir => archive_dir,
      })
    end
end

cron 'postgresql-clear-old-wal' do
    hour node.cron_time.postgresql_clear_wal
    minute '0'
    command "find #{archive_dir} -type f -ctime +0 -delete"
    if node[:postgresql][:config][:archive_mode] == 'on'
        action :create
    else
        action :delete
    end
end


service "postgresql-9.1" do
  supports :restart => true, :status => true, :reload => true
  action [:enable, :start]
end
