from django.contrib import admin
from oos.models import item, opinion, work, pics, price , hidden_works, item_cat, item_keys, item_values, items

class itemAdmin(admin.ModelAdmin):
	list_display = ['id', 'parent_id', 'name', 'level']

class priceAdmin(admin.ModelAdmin):
	list_display = ['id', 'work_id', 'provider_user', 'price']

class workAdmin(admin.ModelAdmin):
	list_display = ['id', 'client_user', 'item']

class hiddenAdmin(admin.ModelAdmin):
	list_display = ['id', 'work_id', 'provider_user']

class item_catAdmin(admin.ModelAdmin):
	list_display = ['id', 'name']

class item_keysAdmin(admin.ModelAdmin):
	list_display = ['id', 'cat', 'name', 'parent']

class item_valuesAdmin(admin.ModelAdmin):
	list_display = ['id', 'key', 'value', 'parent']

class itemsAdmin(admin.ModelAdmin):
	list_display = ['id', 'item_id', 'value']

admin.site.register(item, itemAdmin)
admin.site.register(opinion)
admin.site.register(work, workAdmin)
admin.site.register(pics)
admin.site.register(price, priceAdmin)
admin.site.register(hidden_works, hiddenAdmin)
admin.site.register(item_cat, item_catAdmin)
admin.site.register(item_keys, item_keysAdmin)
admin.site.register(item_values, item_valuesAdmin)
admin.site.register(items, itemsAdmin)
