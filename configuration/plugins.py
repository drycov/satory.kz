PLUGINS = [
    "netbox_routing",
    "netbox_topology_views",
    "netbox_ipcalculator",
    "netbox_interface_synchronization",
    "netbox_inventory",
    "netbox_oxidized_config_viewer",
    "netbox_lifecycle",
    "netbox_config_diff",
    # "netbox_path",
        'netbox_healthcheck_plugin',
    
]

PLUGINS_CONFIG = {
    # ------------------------------------------------------------------
    # NETBOX ROUTING
    # Плагин для PrefixLists, RouteMaps, BGP/OSPF policy-objects
    # Специальных параметров не требует.
    # ------------------------------------------------------------------
    "netbox_routing": {},

    # ------------------------------------------------------------------
    # NETBOX TOPOLOGY VIEWS
    # Расширенная визуализация и работа с координатами
    # ------------------------------------------------------------------
    "netbox_topology_views": {
        "static_image_directory": "netbox_topology_views/img",
        "allow_coordinates_saving": True,
        "always_save_coordinates": True,
        "default_device_image": None,          # По умолчанию картинка не подменяется
        "default_cable_color": "#9ca3af",      # Серый (default)
        "render_file_as_base64": False,        # True = тяжелее, но автономный экспорт
        "add_circuit_types": False,            # Не добавляем custom circuit types
        "cache_timeout": 60,                   # Кэш в секундах
    },

    # ------------------------------------------------------------------
    # NETBOX IP CALCULATOR
    # Калькулятор префиксов. Не требует настроек.
    # ------------------------------------------------------------------
    "netbox_ipcalculator": {},

    # ------------------------------------------------------------------
    # NETBOX INTERFACE SYNCHRONIZATION
    # Автосинхронизация интерфейсов (поле MAC/MTU/Description)
    # ------------------------------------------------------------------
    "netbox_interface_synchronization": {
        "allow_updating_descriptions": True,        # Синхронизация Description с оборудованием
        "allow_updating_mtu": True,
        "allow_updating_mac_address": True,
        "allow_empty_description": False,
        "device_filter_tags": [],                   # Можно ограничить по тегам устройств
        "interface_type_whitelist": [],             # Пусто = разрешены все типы
        "append_mode": False,                       # True → не перезаписывает описание
    },

    # ------------------------------------------------------------------
    # NETBOX INVENTORY
    # Плагин учёта модулей, запчастей и аксессуаров.
    # ------------------------------------------------------------------
    "netbox_inventory": {
        "default_currency": "USD",                  # Можешь поставить "KZT"
        "asset_tag_prefix": "INV",                  # Префикс для авто-генерации тегов
        "enable_asset_tag_auto": True,
        "show_device_relationships": True,
        "show_module_inventory": True,
    },

    # ------------------------------------------------------------------
    # NETBOX OXIDIZED CONFIG VIEWER
    # Интеграция с Oxidized API
    # ------------------------------------------------------------------
    "netbox_oxidized_config_viewer": {
        "oxidized_api_url": "http://oxidized:8888",    # Тот самый URL внутри docker network
        "timeout": 5,                                   # Таймаут запросов в Oxidized
        "verify_ssl": False,                            # Внутренний HTTP — SSL не нужен
        "default_depth": 5,                             # Кол-во версий для отображения
    },
        "netbox_config_diff": {
        "USERNAME": "foo",
        "PASSWORD": "bar",
        "AUTH_SECONDARY": "foobar",  # define here password for accessing Privileged EXEC mode, this variable is optional
        "PATH_TO_SSH_CONFIG_FILE": "/home/.ssh/config",  # define here PATH to SSH config file, it will be used for device connections, this variable is optional
    },
    "netbox_lifecycle": {
    "default_eol_warning_days": 180,
},
        "netbox_healthcheck_plugin": {},

}
