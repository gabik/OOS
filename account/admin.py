from django.contrib import admin
from account.models import UserProfile, area , status

class areaAdmin(admin.ModelAdmin):
        list_display = ['id', 'parent', 'name']

admin.site.register(UserProfile)
admin.site.register(area, areaAdmin)
admin.site.register(status)
