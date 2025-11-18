#!/usr/bin/env bash
set -e

# Выполняем логику ОРИГИНАЛЬНОГО entrypoint до запуска сервера
/opt/netbox/docker-entrypoint.sh migrate
/opt/netbox/docker-entrypoint.sh collectstatic
/opt/netbox/docker-entrypoint.sh remove_stale_contenttypes
/opt/netbox/docker-entrypoint.sh clear_cache

# One-time superuser creation
if [ ! -f "/opt/netbox/.superuser_created" ]; then
    echo "▶ Creating NetBox superuser (one-time)..."

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
    echo "✓ Superuser creation marked as complete."
fi

echo "▶ Starting NetBox…"

# Запускаем штатный NetBox запускатель
exec /opt/netbox/docker-entrypoint.sh "$@"
