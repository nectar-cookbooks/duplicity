Overview
========

This cookbook contains recipes for installing and creating configurations
for the Duplicity.

The main recipes are

* "duplicity::default" - installs a suitable version of duplicity
* "duplicity::swift" - builds a backend configuration for Swift
* "duplicity::cloudfiles" - builds a backend configuration for CloudFiles
* "duplicity::s3" - builds a backend configuration for Amazon S3

The backend configuration recipes currently just create shell scripts to
set environment variables required by the backends, and install extra
packages required for the backends.

The current pattern is that two files are generated:

* The "/etc/duplicity/keys.sh" file defines the private (secret) parameters
  used for authentication, etcetera.
* The "/etc/duplicity/keys.shconfig.sh" file defines other parameters such 
  as the (duplicity-specific) URL for the backup destination.

I will probably change this so that we can support backing up of multiple trees
to multiple backends.

In the case of the "swift" recipe, we use "setup::openstack_clients"
and can take the duplicity backend parameters from the attributes for
that recipe; see https://github.com/nectar-cookbooks/setup for details.


Attribution / Licensing
=======================

This cookbook includes files copied from Marcel M. Cary's original (2011) 
OpsCode "duplicity" cookook.  Original copyright notices have been preserved.