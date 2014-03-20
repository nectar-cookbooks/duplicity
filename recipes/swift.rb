#
# Cookbook Name:: duplicity
# Recipe:: swift
#
# Copyright (c) 2014, The University of Queensland
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# * Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
# * Redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the distribution.
# * Neither the name of the The University of Queensland nor the
# names of its contributors may be used to endorse or promote products
# derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE UNIVERSITY OF QUEENSLAND BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

duplicity_dir = node[:duplicity][:configs]

include_recipe "duplicity::common"
include_recipe "setup::openstack-clients"


os_container = node[:duplicity][:swift][:container] ||
  node[:setup][:openstack_container]
os_username = node[:duplicity][:swift][:os_username] ||
  node[:setup][:openstack_username]
os_password = node[:duplicity][:swift][:os_password] ||
  node[:setup][:openstack_password]
os_tenant_name = node[:duplicity][:swift][:os_tenant_name] ||
  node[:setup][:openstack_tenant_name]
os_auth_url = node[:duplicity][:swift][:os_auth_url] ||
  node[:setup][:openstack_auth_url]
os_auth_version = node[:duplicity][:swift][:os_auth_version] ||
  node[:setup][:openstack_auth_version]
 
template "#{duplicity_dir}/config.sh" do
  source "swift-config.sh.erb"
  variables ({ :os_container => os_container,
               :full_backups_to_keep => node[:duplicity][:full_backups_to_keep],
               :duplicity_dir => duplicity_dir
             })
  mode "0644"
end

template "#{duplicity_dir}/keys.sh" do
  source "swift-keys.sh.erb"
  variables ({ :passphrase => node[:duplicity][:passphrase],
               :os_username => os_username,
               :os_password => os_password,
               :os_tenant_name => os_tenant_name,
               :os_auth_url => os_auth_url,
               :os_auth_version => os_auth_version
             })
  mode "0600"
end
