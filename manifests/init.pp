# Time synchronization

class ntp {

    case $::osfamily {
        'AIX': {
            $rootgrp='system'
            $ntpfile='aix-ntp.conf'
            $ntpservice='xntpd'
            $ntppkg='bos.net.tcp.client'
        }
        'Debian': {
            $rootgrp='root'
            $ntpfile='lnx-ntp.conf'
            $ntpservice='ntp'
            $ntppkg='ntp'
        }
        default : {
            $rootgrp='root'
            $ntpfile='lnx-ntp.conf'
            $ntpservice='ntpd'
            $ntppkg='ntp'
        }
    }

    file { 'ntp.conf' :
        ensure  => 'file',
        path    => '/etc/ntp.conf',
        source  => "puppet:///modules/ntp/${ntpfile}",
        owner   => 'root',
        group   => $rootgrp,
        mode    => '0640',
        require => Package[ $ntppkg ],
    }
    
    package { $ntppkg :
        ensure  => installed,
    }

    service { $ntpservice :
         ensure  => running,
         require => [ Package[ $ntppkg ], File[ 'ntp.conf' ], ],
         enable  => true,
         subscribe => File[ 'ntp.conf' ],
    } 

}
