#
# Cookbook Name:: auditbeat
# Recipe:: install_windows
#
# Copyright 2017, Virender Khatri
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

package_url = node['auditbeat']['package_url'] == 'auto' ? "https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-#{node['auditbeat']['version']}-windows-#{node['auditbeat']['arch']}.zip" : node['auditbeat']['package_url']

package_file = ::File.join(Chef::Config[:file_cache_path], ::File.basename(package_url))

remote_file 'auditbeat_package_file' do
  path package_file
  source package_url
  not_if { ::File.exist?(package_file) }
end

directory node['auditbeat']['windows']['base_dir'] do
  recursive true
  action :create
end

windows_zipfile node['auditbeat']['windows']['base_dir'] do
  source package_file
  action :unzip
  not_if { ::File.exist?(node['auditbeat']['conf_dir'] + '/install-service-auditbeat.ps1') }
end
