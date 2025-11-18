#!/usr/bin/env bash
set -e

# Вызов оригинального entrypoint init-процедуры
/opt/netbox/docker-entrypoint.sh initialize

# Создание суперпользователя (только один раз)
if [ ! -f "/opt/netbox/.superuser_created" ]; then
    echo "▶ Running one-time superuser creation..."

    NB_SUPERUSER_USERNAME="${NB_SUPERUSER_USERNAME:-admin}"
    NB_SUPERUSER_PASSWORD="${NB_SUPERUSER_PASSWORD:-admin}"
    NB_SUPERUSER_EMAIL="${NB_SUPERUSER_EMAIL:-admin@example.com}"

    python3 /opt/netbox/netbox/manage.py shell << EOF
from django.contrib.auth import get_user_model
User = get_user_model()

username = "${NB_SUPERUSER_USERNAME}"
password = "${NB_SUPERUSER_PASSWORD}"
email = "${NB_SUPERUSER_EMAIL}"

if not User.objects.filter(username=username).exists():
    User.objects.create_superuser(username, email, password)
    print(f"✓ Created superuser '{username}'")
else:
    print(f"✓ Superuser '{username}' already exists")
EOF

    touch /opt/netbox/.superuser_created
    echo "✓ Marked superuser as created."
fi

echo "▶ Proceeding to NetBox startup..."

# Запуск NetBox как в оригинале
exec /opt/netbox/docker-entrypoint.sh "$@"
