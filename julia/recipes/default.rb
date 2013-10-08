#
# Cookbook Name:: julia
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

apt_repository "julia-ppa" do
  uri "http://ppa.launchpad.net/staticfloat/julianightlies/ubuntu"
  distribution "precise"
  components ["main"]
  keyserver "keyserver.ubuntu.com"
  key "C0061A4A"
  action :add
  notifies :run, "execute[apt-get update]", :immediately
end

apt_repository "julia-deps-ppa" do
  uri "http://ppa.launchpad.net/staticfloat/julia-deps/ubuntu"
  distribution "precise"
  components ["main"]
  keyserver "keyserver.ubuntu.com"
  key "C0061A4A"
  action :add
  notifies :run, "execute[apt-get update]", :immediately
end

package "julia" do
  options("--force-yes")
  action :install
end

