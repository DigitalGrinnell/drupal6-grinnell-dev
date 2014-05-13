class tools {

  # package install list
  $packages = [
    "curl",
    "vim",
    "htop",
    "nano",                # MAM added 25-Apr-2014
  ]

  # install packages
  package { $packages:
    ensure => present,
    require => Exec["apt-get update"]
  }
}
