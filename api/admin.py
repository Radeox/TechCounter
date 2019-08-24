from django.contrib import admin

from api.checker import check_page
from api.models import Technology, Webpage


def update_technologies(modeladmin, request, queryset):
    """Update the technologies through admin page"""
    for page in queryset:
        check_page(page)


update_technologies.short_description = "Update page technologies"


class WebpageAdmin(admin.ModelAdmin):
    actions = [update_technologies]


# Add both models to admin page
admin.site.register(Technology)
admin.site.register(Webpage, WebpageAdmin)
