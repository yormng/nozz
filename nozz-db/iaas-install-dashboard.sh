#!/bin/bash
# 加载环境变量
source /etc/nozz/openrc.sh
# 安装软件包
yum -y install openstack-dashboard
# 主配置文件设置
sed -i "/^OPENSTACK_HOST =/cOPENSTACK_HOST = \"$HOST_NAME\"" /etc/openstack-dashboard/local_settings
sed -i "/^ALLOWED_HOSTS =/cALLOWED_HOSTS = ['*','localhost']" /etc/openstack-dashboard/local_settings
sed -i "/^#SESSION_ENGINE =/cSESSION_ENGINE = 'django.contrib.sessions.backends.cache'" /etc/openstack-dashboard/local_settings
sed -i "/#CACHES = {/i\CACHES = {\n    'default': {\n        'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',\n        'LOCATION': '$HOST_NAME:11211',\n    },\n}" /etc/openstack-dashboard/local_settings
sed -i "/^#OPENSTACK_KEYSTONE_MULTIDOMAIN_SUPPORT =/cOPENSTACK_KEYSTONE_MULTIDOMAIN_SUPPORT = True" /etc/openstack-dashboard/local_settings
sed -i "/#OPENSTACK_API_VERSIONS = {/i\OPENSTACK_API_VERSIONS = {\n    \"identity\": 3,\n    \"image\": 2,\n    \"volume\": 3,\n}" /etc/openstack-dashboard/local_settings
sed -i "/^#OPENSTACK_KEYSTONE_DEFAULT_DOMAIN =/cOPENSTACK_KEYSTONE_DEFAULT_DOMAIN = 'Default'" /etc/openstack-dashboard/local_settings
sed -i "/^OPENSTACK_KEYSTONE_DEFAULT_ROLE =/cOPENSTACK_KEYSTONE_DEFAULT_ROLE = \"user\"" /etc/openstack-dashboard/local_settings
sed -i "/WSGISocketPrefix run\/wsgi/a\WSGIApplicationGroup %{GLOBAL}" /etc/httpd/conf.d/openstack-dashboard.conf
# 重启服务
systemctl restart httpd.service memcached.service
