# Используем официальный образ NetBox
FROM netboxcommunity/netbox:latest

# Переходим в root для установки пакетов
USER root

# Устанавливаем git (нужно для установки плагинов через git+)
RUN apt-get update && \
    apt-get install -y --no-install-recommends git && \
    rm -rf /var/lib/apt/lists/*

# Копируем requirements для плагинов
COPY ./plugin_requirements.txt /opt/netbox/

# Устанавливаем плагины через uv/pip
RUN /usr/local/bin/uv pip install -r /opt/netbox/plugin_requirements.txt

# Копируем конфиги NetBox
COPY configuration/configuration.py /etc/netbox/config/configuration.py
COPY configuration/plugins.py /etc/netbox/config/plugins.py

# --- Новый функционал: добавляем скрипт автосоздания админа ---
COPY ./scripts/create-superuser.sh /opt/netbox/create-superuser.sh
RUN chmod +x /opt/netbox/create-superuser.sh

# Возвращаемся в unit:root — иначе NetBox не поднимется
USER unit:root

# Запускаем NetBox и создаём админа при старте
ENTRYPOINT ["/bin/bash", "-c", "/opt/netbox/create-superuser.sh && /opt/netbox/docker-entrypoint.sh"]
