<?php

// ======================================================================
// LOCAL ADMIN FALLBACK
// ======================================================================
['ADMIN_USER'] = 'satcoadm';
['ADMIN_PASS'] = 'QJq7w8RN%q';

// ======================================================================
// AUTHENTICATION
// ======================================================================
['auth_mechanism'] = 'ldap';

// ======================================================================
// LDAP CONFIGURATION
// ======================================================================
['auth_ldap_server']    = 'ldap://openldap';
['auth_ldap_port']      = 389;
['auth_ldap_version']   = 3;
['auth_ldap_starttls']  = false;

['auth_ldap_binddn']    = 'cn=admin,dc=satory,dc=kz';
['auth_ldap_password']  = 'admin';

['auth_ldap_base']      = 'dc=satory,dc=kz';
['auth_ldap_groupbase'] = 'ou=Groups,dc=satory,dc=kz';

['auth_ldap_prefix'] = 'uid=';
['auth_ldap_suffix'] = ',ou=People,dc=satory,dc=kz';

// ----------------------------------------------------------------------
// LDAP GROUPS -> PERMISSION MAPPING
// ----------------------------------------------------------------------
['auth_ldap_groups']['admins']['level']    = 10;
['auth_ldap_groups']['noc']['level']       = 5;
['auth_ldap_groups']['observium']['level'] = 1;

// ======================================================================
// DATABASE CONFIGURATION
// ======================================================================
['db_extension'] = 'mysqli';
['db_host']      = 'observium-db';
['db_name']      = 'observium';
['db_user']      = 'observium';
['db_pass']      = 'J5brHrAXFLQSif0K';

// ======================================================================
// SNMP DEFAULTS
// ======================================================================
['snmp']['community'][0] = 'public';
['snmp']['community'][1] = 'cis';
['snmp']['max_rep']      = true;

// ======================================================================
// CACHE
// ======================================================================
['cache']['enable'] = true;
['cache']['driver'] = 'auto';

// ======================================================================
// MISC WEB SETTINGS
// ======================================================================
['web']['debug']['unprivileged'] = false;

