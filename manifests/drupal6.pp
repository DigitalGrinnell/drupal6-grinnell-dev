## manifests\default.pp
## This is the main manifest.

## Define some required parameters
$webroot = '/var/www'
$drupal_core = '6.31'         ## Attention!

## The list of Drupal contrib modules to download.  Note that the space following
## each module name is Important!
$drupal_modules = [
  'addanother ',
  'admin_menu ',
  'backup_migrate ',
  'ctools ',
  'date ',
  'devel ',
  'email ',
  'entity ',
  'fpa ',
  'globalredirect ',
  'login_destination ',
  'module_filter ',
  'page_title ',
  'pathauto ',
  'r4032login ',
  'remove_generator ',
  'token ',
  'transliteration ',
  'views ',
  'xmlsitemap ',
]

$drupal_path = "${webroot}/drupal6"    ## Attention!

$drupal_contrib = "${drupal_path}/sites/all/modules/contrib"
$drupal_dirs = [
  "${drupal_path}",
  "${drupal_path}/sites",
  "${drupal_path}/sites/default",
  "${drupal_path}/sites/default/files",
  "${drupal_path}/sites/all",
  "${drupal_path}/sites/all/modules",
  "${drupal_path}/sites/all/modules/contrib",
  "${drupal_path}/sites/all/modules/custom",
  "${drupal_path}/sites/all/themes",
]

## default path
Exec {
  path => ["/usr/bin", "/bin", "/usr/sbin", "/sbin", "/usr/local/bin", "/usr/local/sbin"]
}

## Credit the following to http://puppetlabs.com/blog/lamp-stacks-made-easy-vagrant-puppet
## and https://github.com/jrodriguezjr/puppet-lamp-stack.git

include bootstrap
include tools
include apache
include php
include php::pear
include php::pecl
include mysql

## MAM additions follow
##

include dynmotd
include webmin
include git
include stdlib
include apt
include java

## Set default file owner, group and mode.
File {
  owner => vagrant,
  group => www-data,
  mode  => 644,
}

## Make sure we have our webroot after Apache2 is started.
file { $webroot :
  ensure => directory,
  mode => 755,
  require => Service[ apache2 ],
}

## Make sure we have our Drupal root after the webroot is present.
#file { $drupal_path :
#  ensure => directory,
#  mode => 755,
#  require => File[ $webroot ],
#}

## More MAM addtions...
##
## Roll in Drupal's core
# include drush  ## MAM - Already included within Drupal.  Don't double up!
include drupal
drupal::core { $drupal_core :
  path => $drupal_path,
  require => Class[ drush ],     ## MAM addition to enforce dependency
}

## Ensure key Drupal directories exist...but only AFTER Drupal core is installed, otherwise
## it might be overlooked!
file { $drupal_dirs :
  ensure => directory,
  mode   => 755,
  require => Drupal::Core [ $drupal_core  ],
}

## Now roll in some "necessary" contibuted Drupal modules.
## This list largely adopted from http://www.ross.ws/content/drupal-7-essential-modules.
Drush::Exec {
  root_directory => $drupal_path,
}
drush::exec { drush-download-modules :
  command => "pm-download ${drupal_modules} --destination=${drupal_contrib}",
  require => [
    File[ "${drupal_contrib}" ],
    Drush::Exec [ "drush-drupal-core-download-${drupal_path}" ],
  ],
}

## Note: To enable the "necessary" modules use this from the command line...
#   drush en --yes addanother admin_menu* backup_migrate ctools date
#     date_all_day date_popup date_repeat date_repeat_field date_tools
#     date_views devel email entity entity_token fpa globalredirect
#     login_destination module_filter page_title pathauto r4032login
#     remove_generator token transliteration views views_ui xmlsitemap
#     xmlsitemap_engines xmlsitemap_menu xmlsitemap_node

## Set file ownership on ${drupal_path} and everything below it.
exec { set-drupal-file-permissions :
  command => "chown -R vagrant:www-data ${drupal_path}/*",
  require => Drush::Exec[ drush-download-modules ],
}

## Roll in xdebug
include xdebug
xdebug::config { 'default' :
  remote_enable => '1',
# remote_host => '132.161.216.181',   # No longer needed since remote_connect_back=1
  remote_port => '9000',              # Change default settings
}

## Roll in awstats
include awstats
awstats::awstats_vhost { "$fqdn" :
  ensure => present,
  docroot => '/var/www/',
  outputdir => '/var/www/awstats',
  user => 'www-data',
  group => 'www-data',
  domain => "${domain}",
  aliases => "${fqdn}",
  require  => Service[ apache2 ],  # MAM added
}

#
#awstats::add_vhost { "$fqdn":
#	log_file => "/var/log/${fqdn}.log",
#	port     => 80,
#	ensure   => 'present',
#  require  => Service[ apache2 ],  # MAM added
#}
