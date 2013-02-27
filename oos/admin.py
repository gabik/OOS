from django.contrib import admin
from oos.models import item, opinion 
from oos.forms import items_import

class itemAdmin(admin.ModelAdmin):
	list_display = ['id', 'parent_id', 'name', 'level']


admin.site.register(item, itemAdmin)
admin.site.register(opinion)
