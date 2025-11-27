<?php

$config = [
    'servers' => [
        [
            'name' => 'LDAP Server',
            'hosts' => [ getenv('PLA_LDAP_HOST') ?: 'ldap' ],
            'port'  => getenv('PLA_LDAP_PORT') ?: 389,
            'base'  => [ getenv('PLA_BASE_DN') ?: 'dc=example,dc=org' ],
            'auth_type' => 'config',
            'login' => getenv('PLA_LOGIN_DN') ?: 'cn=admin,dc=example,dc=org',
            'password' => getenv('PLA_LOGIN_PASS') ?: 'admin',
            'tls' => filter_var(getenv('PLA_LDAP_TLS'), FILTER_VALIDATE_BOOLEAN),
        ]
    ]
];

file_put_contents('/app/config/config.php', "<?php\n\$servers = " . var_export($config['servers'], true) . ";\n");
