# Time synchronization

class ntp {
    package { 'ntp' :
        ensure  => installed,
    }

    $ntpservice = $::osfamily ? {
        'Debian' => 'ntp',
        default  => 'ntpd',
    }

    service { $ntpservice :
        ensure  => running,
        require => Package[ 'ntp' ],
        enable  => true,
    }
}

