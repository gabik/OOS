from django.contrib import admin
from oos.models import item, opinion, work, pics, price , hidden_works

class itemAdmin(admin.ModelAdmin):
	list_display = ['id', 'parent_id', 'name', 'level']

class priceAdmin(admin.ModelAdmin):
	list_display = ['id', 'work_id', 'provider_user', 'price']

class workAdmin(admin.ModelAdmin):
	list_display = ['id', 'client_user', 'item']

class hiddenAdmin(admin.ModelAdmin):
	list_display = ['id', 'work_id', 'provider_user']

admin.site.register(item, itemAdmin)
admin.site.register(opinion)
admin.site.register(work, workAdmin)
admin.site.register(pics)
admin.site.register(price, priceAdmin)
admin.site.register(hidden_works, hiddenAdmin)
