#
# Cookbook Name:: RStudio
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'R'

if node['kernel']['machine'] =~ /x86_64/
  package = value_for_platform(
    %w|centos redhat amazon scientific| => {
      'default' => "rstudio-server-#{node['RStudio']['version']}-x86_64.rpm"
    },
    %w|ubuntu debian| => {
      'default' => "rstudio-server-#{node['RStudio']['version']}-amd64.deb"
    }
  )
else
  package = value_for_platform(
    %w|centos redhat amazon scientific| => {
      'default' => "rstudio-server-#{node['RStudio']['version']}-i686.rpm"
    },
    %w|ubuntu debian| => {
      'default' => "rstudio-server-#{node['RStudio']['version']}-i386.deb"
    }
  )
end

download_url = "http://download2.rstudio.org/#{package}"
rstudio_package = "#{Chef::Config[:file_cache_path]}/#{package}"

remote_file rstudio_package do
  source download_url
  mode 0644
end

case node['platform']
when 'ubuntu', 'debian'
  %w| gdebi-core libssl0.9.8 libapparmor1 apparmor-utils |.each do |pkg|
    package pkg do
      action :install
    end
  end

  dpkg_package 'rstudio-server' do
    source rstudio_package
    action :install
  end
when 'centos', 'redhat', 'amazon', 'scientific'
  yum_package 'rstudio-server' do
    source rstudio_package
    action :install
  end
end

user "rstudio" do
  comment "Application execution user"
  uid 2000
  gid "users"
  shell "/bin/false"
  home "/home/rstudio"
end

directory "/home/rstudio" do
  owner "rstudio"
  group "users"
  mode 0755
  action :create
end


