#
# Cookbook Name:: duplicity
# Recipe:: common
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

directory duplicity_dir do
  owner "root"
  mode 0700
end

package "python" do
end

min_version = '0.6.22'
force_version = false
if platform?('ubuntu') and node['platform_version'].to_f < 14.04 then
  apt_repository "duplicity-team-ppa" do
    uri 'http://ppa.launchpad.net/duplicity-team/ppa/ubuntu/'
    distribution 'saucy'
    components ['main']
  end
  force_version = true
  # This is the version supplied by the PPA ....
  version = '0.6.23'
end

if platform_family?('redhat', 'fedora') then
  package "duplicity >= #{min_version}" do
  end
elsif force_version then
  package "duplicity" do
    version version
  end
else
  package "duplicity" do
  end
end

template "#{duplicity_dir}/run_duplicity.sh" do
  mode 0755
  owner 'root'
  source 'run_duplicity.sh.erb'
  variables ({:full_backups_to_keep => node[:duplicity][:full_backups_to_keep],
               :duplicity_dir => duplicity_dir
             })
end

