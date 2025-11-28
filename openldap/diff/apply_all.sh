#!/bin/bash
#
# OpenLDAP LDIF bulk loader for Osixia/openldap
# Applies both cn=config schema and dc=* data entries.
#

set -e

CONTAINER="openldap"
ADMIN_DN="cn=admin,dc=satory,dc=kz"
ADMIN_PW="admin"

echo "=== [1] Loading ppolicy schema into cn=config ==="
docker exec -i "$CONTAINER" bash -c \
    "ldapadd -Y EXTERNAL -H ldapi:/// -f /dev/stdin" < 00_load_ppolicy_schema.ldif \
  || echo "[WARN] Schema may already be loaded. Continuing."


echo "=== [2] Applying 01_base_structure.ldif ==="
docker exec -i "$CONTAINER" ldapadd -x -c -D "$ADMIN_DN" -w "$ADMIN_PW" \
    -f /dev/stdin < 01_base_structure.ldif


echo "=== [3] Applying 02_posix_groups.ldif ==="
docker exec -i "$CONTAINER" ldapadd -x -c -D "$ADMIN_DN" -w "$ADMIN_PW" \
    -f /dev/stdin < 02_posix_groups.ldif


echo "=== [4] Applying 03_people_posix.ldif ==="
docker exec -i "$CONTAINER" ldapadd -x -c -D "$ADMIN_DN" -w "$ADMIN_PW" \
    -f /dev/stdin < 03_people_posix.ldif


echo "=== [5] Applying 04_service_accounts_posix.ldif ==="
docker exec -i "$CONTAINER" ldapadd -x -c -D "$ADMIN_DN" -w "$ADMIN_PW" \
    -f /dev/stdin < 04_service_accounts_posix.ldif


echo "=== [6] Applying 05_radius_base.ldif ==="
docker exec -i "$CONTAINER" ldapadd -x -c -D "$ADMIN_DN" -w "$ADMIN_PW" \
    -f /dev/stdin < 05_radius_base.ldif


echo "=== [7] Applying 06_acl_enterprise.ldif ==="
# По умолчанию загружаем в обычное дерево.
# Если ACL относится к cn=config — скажи, сделаю корректный вариант.
docker exec -i "$CONTAINER" ldapadd -x -c -D "$ADMIN_DN" -w "$ADMIN_PW" \
    -f /dev/stdin < 06_acl_enterprise.ldif


echo "=== [8] Applying 07_ppolicy.ldif ==="
docker exec -i "$CONTAINER" ldapadd -x -c -D "$ADMIN_DN" -w "$ADMIN_PW" \
    -f /dev/stdin < 07_ppolicy.ldif


echo "======================================================="
echo "All LDIF files applied. Verify via:"
echo "docker exec -it openldap ldapsearch -x -b 'dc=satory,dc=kz'"
echo "======================================================="
