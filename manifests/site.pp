## Active Configurations ##

# PRIMARY FILEBUCKET
# This configures puppet agent and puppet inspect to back up file contents when
# they run. The Puppet Enterprise console needs this to display file contents
# and differences.

# Define filebucket 'main':
filebucket { 'main':
  server => 'bigmarv.loganspencer.com',
  path   => false,
}

# Make filebucket 'main' the default backup location for all File resources:
File { backup => 'main' }

# DEFAULT NODE
# Node definitions in this file are merged with node data from the console. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.

# The default node definition matches any node lacking a more specific node
# definition. If there are no other nodes in this file, classes declared here
# will be included in every node's catalog, *in addition* to any classes
# specified in the console for that node.

node default {
}

node 'bigmarv.loganspencer.com' {
	class { 'ldap':
		server => 'true',
		server_type => 'openldap',
		ssl => 'false',
	}

# Server Configuration:
 ldap::define::domain {'loganspencer.com':
   basedn   => 'dc=loganspencer,dc=com',
   rootdn   => 'cn=admin',
   rootpw   => 'admin',
 }

 ldap::define::schema { 'websages':
   ensure => 'present',
   source => 'puppet:///modules/ldap/schema/websages.schema',
 }
}

