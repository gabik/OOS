from django.contrib import admin
from oos.models import item, opinion, work, pics, price 
from oos.forms import items_import

class itemAdmin(admin.ModelAdmin):
	list_display = ['id', 'parent_id', 'name', 'level']


admin.site.register(item, itemAdmin)
admin.site.register(opinion)
admin.site.register(work)
admin.site.register(pics)
admin.site.register(price)
