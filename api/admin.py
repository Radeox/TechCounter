from django.contrib import admin
from api.models import Technology, Webpage

# Add both models to admin page
admin.site.register(Technology)
admin.site.register(Webpage)
