# Time synchronization

class ntp {
    $rootgrp = $::operatingsystem ? {
        'AIX'   => 'system',
        default => 'root',
    }
    
    $ntpfile = $::operatingsystem ? {
        'AIX'   => 'aix-ntp.conf',
        default => 'lnx-ntp.conf',
    }

    $ntpservice = $::osfamily ? {
        'Debian' => 'ntp',
        'AIX' => 'xntpd',
        default  => 'ntpd',
    }


    file { 'ntp.conf' :
        ensure  => 'file',
        path    => '/etc/ntp.conf',
        source  => "puppet:///modules/ntp/${ntpfile}",
        owner   => 'root',
        group   => $rootgrp,
        mode    => '0640',
        #require => Package[ 'ntp' ],
    }

    if $::osfamily == 'RedHat' {
        package { 'ntp' :
            ensure  => installed,
        }

        service { $ntpservice :
            ensure  => running,
            require => [ Package[ 'ntp' ], File[ 'ntp.conf' ], ],
            enable  => true,
            subscribe => File[ 'ntp.conf' ],
        }
    }elsif $::osfamily == 'AIX' {
        package { 'bos.net.tcp.client' :
            ensure  => installed,
        }

       service { $ntpservice :
            ensure  => running,
            require => [ Package[ 'bos.net.tcp.client' ], File[ 'ntp.conf' ], ],
            enable  => true,
            subscribe => File[ 'ntp.conf' ],
        } 
    }
}
