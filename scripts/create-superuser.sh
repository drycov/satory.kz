#!/usr/bin/env bash
set -e

echo "▶ Checking NetBox superuser using ENV variables..."

# Поддержка ENV с дефолтами
NB_SUPERUSER_USERNAME="${NB_SUPERUSER_USERNAME:-admin}"
NB_SUPERUSER_PASSWORD="${NB_SUPERUSER_PASSWORD:-admin}"
NB_SUPERUSER_EMAIL="${NB_SUPERUSER_EMAIL:-admin@example.com}"

echo "→ Username: ${NB_SUPERUSER_USERNAME}"
echo "→ Email: ${NB_SUPERUSER_EMAIL}"

python3 /opt/netbox/netbox/manage.py shell << EOF
from django.contrib.auth import get_user_model
User = get_user_model()

username = "${NB_SUPERUSER_USERNAME}"
password = "${NB_SUPERUSER_PASSWORD}"
email = "${NB_SUPERUSER_EMAIL}"

if not User.objects.filter(username=username).exists():
    User.objects.create_superuser(username=username, email=email, password=password)
    print(f"✓ Superuser '{username}' created")
else:
    print(f"✓ Superuser '{username}' already exists — skipping")
EOF

echo "▶ Admin check complete."
echo "✓ Script finished successfully."
