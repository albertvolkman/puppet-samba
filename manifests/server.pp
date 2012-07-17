# Class: samba::server
#
# server specific
#
# Requires:
#   class samba
#   class generic
#
class samba::server inherits samba {

  package { "samba": }

  file { "/usr/bin/smbsync":
    owner   => root,
    group   => root,
    mode    => 755,
    source  => "puppet:///modules/samba/smbsync",
    require => Package["samba"]
  }

  file { "/etc/samba/smb.conf":
     owner    => root,
     group    => root,
     mode     => 644,
     content  => template('samba/smb.conf.erb'),
     require  => Package["samba"],
     notify   => Service["smbd"],
  }

  exec {"samba-user-sync":
    command => "/usr/bin/smbsync",
    path    => "/usr/bin:/usr/sbin:/bin:/usr/local/bin:/sbin",
    require => File["/usr/bin/smbsync"],
  }

  service { "smbd":
    enable  => true,
    ensure  => running,
    require => Package["samba"],
    notify  => Service["nmbd"],
  }

  service { "nmbd":
    enable  => true,
    ensure  => running,
  }

} # class samba
