"""TechCounter URL Configuration"""

from django.contrib import admin
from django.urls import path
from django.conf.urls import url, include
from tastypie.api import Api
from api.api import TechResource, PageResource

# API configuration
v1_api = Api(api_name='v1')

# Register resources for both models
v1_api.register(TechResource())
v1_api.register(PageResource())

urlpatterns = [
    path('admin/', admin.site.urls),
    # API urls
    url('^api/', include(v1_api.urls))
]
