from django.contrib import admin
from oos.models import item, opinion 

class itemAdmin(admin.ModelAdmin):
    list_display = ['id', 'parent_id', 'name', 'level']


admin.site.register(item, itemAdmin)
admin.site.register(opinion)
