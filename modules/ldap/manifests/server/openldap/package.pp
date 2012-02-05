# Class: ldap::server::openldap::package
#
# This module manages package installation of OpenLDAP, based on 
# operating system. 
#
# Parameters:
#
# There are no default parameters for this class.
#
# Actions:puppet/
	martian/
		configpuppet
		ldap/
			ldap.conf
		manifests/
			site.pp
		modules/
			ldap/
				files/
					README.markdown
					schema/
						websages.schema
				lib/
					facter/
						ldapserver.rb
						README.markdown
					puppet/
						parser/
							functions/
								README.markdown
								ssha.rb
						provider/
							domain/
								openldap.rb
							README.markdown
						type/
							domain.rb
							README.markdown
				manifests/
					client/
						base/
							debian.pp
							redhat.pp
							suse.pp
						base.pp
						config/
							debian.pp
							redhat.pp
							suse.pp
						config.pp
						package/
							debian.pp
							redhat.pp
							suse.pp
						package.pp
						service.pp
					client.pp
					define/
						acl.pp
						domain.pp
						schema.pp
					init.pp
					params.pp
					README.markdown
					server/
						389/
							base.pp
							config.pp
							define/
								domain.pp
							package/
								debian.pp
								redhat.pp
								suse.pp
							package.pp
							service.pp
						389.pp
						fds/
							base.pp
							config.pp
							define/
								domain.pp
							package/
								debian.pp
								redhat.pp
								suse.pp
							package.pp
							service.pp
						fds.pp
						openldap/
							base.pp
							define/
								acl.pp
								domain.pp
								replication.pp
								schema.pp
							package/
								common.pp
								debian.pp
								redhat.pp
								suse.pp
							package.pp
							rebuild.pp
							service.pp
						openldap.pp
					server.pp
				Modulefile
				README
				schema/
					websages.schema
				spec/
					README.markdown
					spec.opts
					spec_helper.rb
					unit/
						puppet/
							provider/
								README.markdown
							type/
								README.markdown
				templates/
					client/
						common/
							ldap.conf.erb
							nss_pam_ldap.conf.erb
						debian/
							common-account.erb
							common-auth.erb
							common-password.erb
							common-session.erb
							libnss-ldap.conf.erb
							nsswitch.conf.erb
							pam-nss-base.conf.erb
							pam_ldap.conf.erb
						redhat/
							nsswitch.conf.erb
							system-auth.erb
						suse/
							common-account.erb
							common-auth.erb
							common-password.erb
							common-session.erb
							nsswitch.conf.erb
					README.markdown
					server/
						openldap/
							acl_template.erb
							base.ldif.erb
							DB_CONFIG.erb
							domain_template.erb
							openldap_acl_rebuild.erb
							replica_template.erb
							slapd.conf.erb
							slapd_default.erb
				tests/
					client.pp
					init.pp
		puppetent.answers
		randomscripts/
			ks1.kx
	puppet-textmate-bundle/
		COPYING
		LICENSE
		Puppet.tmbundle/
			Commands/
				Validate Syntax (puppetparse).tmCommand
			info.plist
			Preferences/
				Comments.tmPreferences
				Completions.tmPreferences
				SymbolList (class|node|define).tmPreferences
				SymbolList (resource).tmPreferences
			Snippets/
				case.tmSnippet
				class.tmSnippet
				cron.tmSnippet
				define.tmSnippet
				else.tmSnippet
				exec.tmSnippet
				file.tmSnippet
				group.tmSnippet
				if.tmSnippet
				package.tmSnippet
				Parameter.tmSnippet
				selector.tmSnippet
				user.tmSnippet
				yumrepo.tmSnippet
			Syntaxes/
				Puppet.tmLanguage
			Templates/
				module.tmTemplate/
					info.plist
					init.pp
		README

#
# Requires:
#
# Sample Usage:
#
# This class file is not called directly
class ldap::server::openldap::package(
  $ssl
) {
  
  # Manage the User and Group
  user { $ldap::params::lp_daemon_user:
    ensure  => 'present',
    uid     => $ldap::params::lp_daemon_uid,
    gid     => $ldap::params::lp_daemon_gid,
    comment => 'LDAP User',
    home    => $ldap::params::lp_openldap_var_dir,
    shell   => '/bin/false',
    before  => Package[$ldap::params::openldap_packages],
  }
  group { $ldap::params::lp_daemon_user:
    ensure => 'present',
    gid    => $ldap::params::lp_daemon_gid,
    before  => Package[$ldap::params::openldap_packages],
  }
  
  package { $ldap::params::openldap_packages: 
    ensure => present,
  }
  
  ## This section modifies the /etc/default file to allow for
  ## slapd.conf configuration as opposed to the cn=config 
  ## configuration and setup. This section will be removed once
  ## configuration is migrated to cn=config
  if $operatingsystem == 'Ubuntu' {
    file {'/etc/default/slapd':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('ldap/server/openldap/slapd_default.erb'),
      require => Package[$openldap_packages],
    }
  }
}