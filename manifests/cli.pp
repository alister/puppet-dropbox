class dropbox::cli {
  include stdlib
  include dropbox::config

  Exec {
    path   => '/bin:/sbin:/usr/bin:/usr/sbin',
  }

  user { $dropbox::config::dx_uid:
    ensure     => present,
    gid        => $dropbox::config::dx_gid,
    managehome => true,
    system     => true,
    home       => $dropbox::config::dx_home,
    comment    => 'Dropbox Service Account',
  }
  group { $dropbox::config::dx_gid:
    ensure => present,
    system => true
  }

  exec { 'download-dropbox-cli':
    command => 'wget -O /tmp/dropbox.py "https://www.dropbox.com/download?dl=packages/dropbox.py"',
    unless  => 'test -f /tmp/dropbox.py',
    require => User[$dropbox::config::dx_uid],
  }
  file { '/usr/local/bin/dropbox':
    source  => '/tmp/dropbox.py',
    mode    => '0755',
    require => Exec['download-dropbox-cli']
  }

}
