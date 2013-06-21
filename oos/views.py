import datetime
from django.db.models import Max
from oos.models import item, work, pics, price, hidden_works, item_cat, item_keys, item_values, items
from oos.forms import new_work, new_price, new_pic
from account.models import UserProfile, area, status
from django.utils import simplejson as json
from django.contrib.auth.decorators import login_required
from django.http import HttpResponseRedirect, HttpResponse, Http404
from django.template import RequestContext
from django.shortcuts import render_to_response, get_object_or_404, redirect
from django.contrib.auth.models import User
from django.core import serializers
from account.views import check_area
from oos import settings

#def check_item_level(higher, lower):
	#if higher == lower:
		#answer = True
	#else:
		#cur_lower = item.objects.filter(id=lower)
		#if  cur_lower:
			#parent_lower = cur_lower[0].parent_id
			#if not parent_lower:
				#answer = False
			#else:
				#answer = check_item_level(higher, cur_lower[0].parent_id.id)
		##else:
			#answer = False
	#return answer

def check_item_level(higher, lower):
	item_key1 = items.objects.filter(item_id=lower)
	if not item_key1:
		return False
	item_cat1 = item_key1[0].value.key.cat
	item_cat2 = item_cat.objects.filter(id=higher)
	if not item_cat:
		return False
	if item_cat1 == item_cat2[0]:
		return True
	return False


def get_root_parent(itemid):
	cur_item = items.objects.filter(item_id=itemid)
	if not cur_item:
		return False
	item_cat = cur_item[0].value.key.cat
	if not item_cat:
		return False
	return item_cat.id
	#if cur_item[0].parent_id == None:
		#answer = cur_item[0].id
	#else:
		#parent = item.objects.filter(id=cur_item[0].parent_id.id)
		#answer = get_root_parent(parent[0].id)
	#return answer

@login_required(login_url='/account/logout/', redirect_field_name=None)
def get_child(request):
	json_data = status.objects.filter(status='ERR')
	if request.method == 'POST':
		parent = request.POST['parent']
		if (parent == "") or (parent == "0") :
			parent = None
		items = item.objects.filter(parent_id=parent).order_by('id')
		if not items:
			json_data = status.objects.filter(status='ERR', MSG='NE')
		else:
			json_data = list(status.objects.filter(status='OK')) + list(items)
	json_dump = serializers.serialize("json", json_data)
	return HttpResponse(json_dump)

#@login_required(login_url='/account/logout/', redirect_field_name=None)
#def get_work(request):
	#json_data = status.objects.filter(status='ERR', MSG='NE')
	#json_dump = serializers.serialize("json", json_data)
	#if request.method == 'POST':
		#work_id = request.POST['work_id']
		#if work_id == "" :
			#return HttpResponse(json_dump)
		#cur_work = work.objects.filter(id=work_id)
		#if not cur_work:
			#return HttpResponse(json_dump)
		#user_profile = UserProfile.objects.get(user=request.user)
		#PD_flag=True
		#if (request.user == cur_work[0].client_user ) :
			#PD_flag=False
		#elif (not user_profile.is_client) and check_area(user_profile.area_id.id,  cur_work[0].area.id):
			#PD_flag=False
		#if PD_flag:
			#json_data = status.objects.filter(status='ERR', MSG='PD')
			#json_dump = serializers.serialize("json", json_data)
			#return HttpResponse(json_dump)
		#cur_pics = pics.objects.filter(work_id=cur_work).only("pic")
		#json_data = list(status.objects.filter(status='OK')) + list(cur_work) + list(cur_pics) 
		#json_dump = serializers.serialize("json", json_data)
	#return HttpResponse(json_dump)
#
@login_required(login_url='/account/logout/', redirect_field_name=None)
def get_BC(request):
	json_data = status.objects.filter(status='ERR', MSG='NE')
	json_dump = serializers.serialize("json", json_data)
	if request.method == 'POST':
		if 'price_id' in request.POST:
			price_id = request.POST['price_id']
		else:
			return HttpResponse(json_dump)
		if price_id == "" :
			return HttpResponse(json_dump)
		cur_price = price.objects.filter(id=price_id)
		if not cur_price:
			return HttpResponse(json_dump)
		user_profile = UserProfile.objects.filter(user=cur_price[0].provider_user)
		if not user_profile:
			return HttpResponse(json_dump)
		returnArray = []
		BC_dict = {}
		BC_dict['pk'] = int(cur_price[0].provider_user.id)
		BC_dict['model'] = "oos.BC"
		BC_Fields = {}
		BC_Fields['firstname'] = str(cur_price[0].provider_user.first_name)
		BC_Fields['lastname'] = str(cur_price[0].provider_user.last_name)
		BC_Fields['email'] = str(cur_price[0].provider_user.email)
		BC_Fields['phone_num1'] = str(user_profile[0].phone_num1)
		BC_Fields['phone_num2'] = str(user_profile[0].phone_num2)
		BC_Fields['address'] = str(user_profile[0].address)
		BC_Fields['price'] = str(cur_price[0].price)
		BC_Fields['text'] = str(cur_price[0].text)
		BC_Fields['post_date'] = str(cur_price[0].post_date.strftime("%d-%m-%Y %H:%M"))
		BC_dict['fields'] = BC_Fields
		returnArray.append(BC_dict)
		json_dump = serializers.serialize("json", list(status.objects.filter(status='OK'))) + str(list(returnArray))
	return HttpResponse(json_dump.replace('\'','"').replace('][',','))

@login_required(login_url='/account/logout/', redirect_field_name=None)
def get_works(request):
	json_data = status.objects.filter(status='ERR', MSG='NE')
	json_dump = serializers.serialize("json", json_data)
	all_work = work.objects.filter(client_user=request.user, is_active=True).order_by('id').reverse()
	if not all_work:
		json_data = status.objects.filter(status='WRN', MSG='EMP')
		json_dump = serializers.serialize("json", json_data)
	else:
		json_data = list(status.objects.filter(status='OK')) 
		today=datetime.date.today()
		all_works = []
		for i in all_work:
			if i.end_date >= today:
				cur_item = items.objects.filter(item_id=i.item).order_by('id').reverse()
				item_str = ""
				for vlue in cur_item:
					item_str += " " + vlue.value.value
				root_parent_name = item_cat.objects.get(id=get_root_parent(i.item)).name
				all_works_dict = {}
				all_works_dict['pk'] = int(i.id)
				all_works_dict['model'] = "oos.work"
				all_works_dict['fields'] = {'item': str(item_str), 'root_parent': str(root_parent_name)}
				all_works.append(all_works_dict)
				#json_data+= list(all_works_dict) 
		json_dump = serializers.serialize("json", list(status.objects.filter(status='OK'))) + str(list(all_works)) #serializers.serialize("json", json_data)
	return HttpResponse(json_dump.replace('\'','"').replace('][',','))

@login_required(login_url='/account/logout/', redirect_field_name=None)
def get_old_works(request):
	json_data = status.objects.filter(status='ERR', MSG='NE')
	json_dump = serializers.serialize("json", json_data)
	all_work = work.objects.filter(client_user=request.user, is_active=True).order_by('id').reverse()
	if not all_work:
		json_data = status.objects.filter(status='WRN', MSG='EMP')
		json_dump = serializers.serialize("json", json_data)
	else:
		json_data = list(status.objects.filter(status='OK'))
		today=datetime.date.today()
		all_works = []
		for i in all_work:
			if i.end_date < today:
				cur_item = items.objects.filter(item_id=i.item).order_by('id').reverse()
				item_str = ""
				for vlue in cur_item:
					item_str += " " + vlue.value.value
				root_parent_name = item_cat.objects.get(id=get_root_parent(i.item)).name
				all_works_dict = {}
				all_works_dict['pk'] = int(i.id)
				all_works_dict['model'] = "oos.work"
				all_works_dict['fields'] = {'item': str(item_str), 'root_parent': str(root_parent_name)}
				all_works.append(all_works_dict)
				#json_data+= list(all_works_dict)
		json_dump = serializers.serialize("json", list(status.objects.filter(status='OK'))) + str(list(all_works)) #serializers.serialize("json", json_data)
	return HttpResponse(json_dump.replace('\'','"').replace('][',','))

@login_required(login_url='/account/logout/', redirect_field_name=None)
def get_user(request):
	json_data = status.objects.filter(status='ERR',MSG='NE')
	json_dump = serializers.serialize("json", json_data)
	if request.method == 'POST':
		if 'user_id' in request.POST:
			user_id = request.POST['user_id']
		else:
			return HttpResponse(json_dump)
		if user_id == "" :
			cur_user = request.user
		else:
			cur_user = User.objects.get(id=user_id)
		if not cur_user:
			return HttpResponse(json_dump)
		cur_profile = UserProfile.objects.filter(user=cur_user)
		if not cur_profile:
			return HttpResponse(json_dump)
		if cur_user != request.user:
			if cur_profile.is_client:
				json_data = status.objects.filter(status='ERR', MSG='PD')
				json_dump = serializers.serialize("json", json_data)
				return HttpResponse(json_dump)
		cur_user_dict=str('[{"username":"' + cur_user.username + '","email":"' + cur_user.email + '","firstname":"' + cur_user.first_name + '","lastname":"' + cur_user.last_name + '"}]')
		json_data = list(status.objects.filter(status='OK')) 
		json_dump = '['
		json_dump += serializers.serialize("json", json_data)
		json_dump += ','
		json_data = list(cur_profile)
		json_dump += serializers.serialize("json", json_data)
		json_dump += ','
		json_dump += cur_user_dict
		json_dump += ']'
	return HttpResponse(json_dump)

@login_required(login_url='/account/logout/', redirect_field_name=None)
def post_work(request):
	json_data=status.objects.filter(status='ERR',MSG=None)
	json_dump = serializers.serialize("json", json_data)
	errors=""
	if UserProfile.objects.get(user=request.user).is_client:
		if request.method == 'POST':
			cur_work = new_work(request.POST)
			if cur_work.is_valid():
				work_clean = cur_work.cleaned_data
				#if items.objects.filter(parent_id=request.POST['item']) :
					#json_data=list(status.objects.filter(status='ERR',MSG='PD'))
				#else:
				cur_work_save = cur_work.save(commit=False)
				cur_work_save.client_user = request.user
				cur_work_save.is_active = True
				cur_work_save.save()
				max_item=cur_work_save.id
				returnArray = []
				work_dict = {}
				work_dict['pk'] = int(max_item)
				work_dict['model'] = "oos.work_id"
				work_fields={}
				work_fields['id'] = int(max_item)
				work_dict['fields'] = work_fields
				returnArray.append(work_dict)
				json_dump = serializers.serialize("json", list(status.objects.filter(status='OK'))) + str(list(returnArray))
				return HttpResponse(json_dump.replace('\'','"').replace('][',',').replace('}, {','},{'))
			else:
				json_data = status.objects.filter(status='WRN',MSG="")
				json_dump = serializers.serialize("json", json_data)
				#errors = list(cur_work.errors.items())
				errors = str([(k, v[0].__str__()) for k, v in cur_work.errors.items()])
		else:
			json_data=list(status.objects.filter(status='ERR',MSG='PD'))
			json_dump = serializers.serialize("json", json_data)
	else:
		json_data=list(status.objects.filter(status='ERR',MSG='PD'))
	json_dump += errors
	return HttpResponse(json_dump)
			
@login_required(login_url='/account/logout/', redirect_field_name=None)
def post_price(request):
	json_data=status.objects.filter(status='ERR',MSG=None)
	errors=""
	cur_user_area = UserProfile.objects.get(user=request.user).area_id.id
	if not UserProfile.objects.get(user=request.user).is_client:
		if request.method == 'POST':
			cur_price = new_price(request.POST)
			if cur_price.is_valid():
				work_area = work.objects.get(id=request.POST['work_id']).area.id
				if check_area(cur_user_area, work_area):
					old_price = price.objects.filter(work_id=request.POST['work_id'], provider_user=request.user)
					if old_price:
						if 'overwrite' in request.POST:
							if (request.POST['overwrite'] == '1'):
								price_clean = cur_price.cleaned_data
								old_price0 = old_price[0]
								old_price0.price=price_clean['price']
								old_price0.text=price_clean['text']
								old_price0.save()
								json_data = status.objects.filter(status='OK')
							else:
								json_data = status.objects.filter(status='WRN',MSG="AEX")
						else:
							json_data = status.objects.filter(status='WRN',MSG="AEX")
					else:
						price_clean = cur_price.cleaned_data
						cur_price_save = cur_price.save(commit=False)
						cur_price_save.provider_user = request.user
						cur_price_save.is_active = True
						cur_price_save.save()
						json_data = status.objects.filter(status='OK')
				else:
					json_data=list(status.objects.filter(status='ERR',MSG='PD'))
			else:
				json_data = status.objects.filter(status='WRN',MSG="")
				#errors = str(cur_price.errors)
				errors = ",[" + str(dict([(k, v[0].__str__()) for k, v in cur_price.errors.items()])) + "]"
		else:
			json_data=list(status.objects.filter(status='ERR',MSG='PD'))
	else:
		json_data=list(status.objects.filter(status='ERR',MSG='PD'))
	json_dump = serializers.serialize("json", json_data)
	json_dump += errors
	return HttpResponse(json_dump)
	#return render_to_response('oos/new_price.html', { 'new_price': cur_price}, context_instance=RequestContext(request))

@login_required(login_url='/account/logout/', redirect_field_name=None)
def get_prices(request):
	json_data=status.objects.filter(status='ERR',MSG=None)
	json_dump = serializers.serialize("json", json_data)
	if request.method == 'POST':
		if 'work_id' not in request.POST:
			return HttpResponse(json_dump)
		all_prices = price.objects.filter(work_id=request.POST['work_id'], is_active=True).order_by('price')
		if all_prices:
			return_prices = []
			for i in all_prices:
				all_price_dict = {}
				all_price_dict['pk'] = int(i.id)
				all_price_dict['model'] = "oos.price"
				all_price_dict['fields'] = {'price': str(i.price), 'provider_user': str(i.provider_user.first_name + " " + i.provider_user.last_name)}
				return_prices.append(all_price_dict)
			json_dump = serializers.serialize("json", list(status.objects.filter(status='OK'))) + str(list(return_prices)) 
		else:
			json_data=list(status.objects.filter(status='WRN',MSG='EMP'))
			json_dump = serializers.serialize("json", json_data)
	else:
		json_data=list(status.objects.filter(status='ERR',MSG='PD'))
		json_dump = serializers.serialize("json", json_data)
	return HttpResponse(json_dump.replace('\'','"').replace('][',','))

def handle_uploaded_file(file_path):
    dest = open(settings.MEDIA_ROOT + "/work_pics/" + file_path.name,"wb")
    for chunk in file_path.chunks():
        dest.write(chunk)
    dest.close()

@login_required(login_url='/account/logout/', redirect_field_name=None)
def post_pic(request):
	json_data=list(status.objects.filter(status='ERR',MSG='NE'))
	errors=""
	if request.method == 'POST': 
		pic_form = new_pic(request.POST, request.FILES)
		if pic_form.is_valid():
			work_pic = work.objects.filter(id=request.POST['work_id'])
			if work_pic:
				user_work = work_pic[0].client_user
				if user_work == request.user:
					handle_uploaded_file(request.FILES["pic"])
					pic_clean = pic_form.cleaned_data
					cur_pic = pic_form.save()
					json_data = status.objects.filter(status='OK')
				else:
					json_data=list(status.objects.filter(status='ERR',MSG='PD'))
		else:
			json_data = status.objects.filter(status='WRN',MSG="")
			#errors = list(pic_form.errors.items())
			errors = str([(k, v[0].__str__()) for k, v in pic_form.errors.items()])
	#else:
		#pic_form = new_pic()
		#return render_to_response('oos/post_pic.html', { 'pic_form': pic_form}, context_instance=RequestContext(request))
	json_dump = serializers.serialize("json", json_data)
	json_dump += errors
	return HttpResponse(json_dump)

@login_required(login_url='/account/logout/', redirect_field_name=None)
def del_work(request):
	json_data=list(status.objects.filter(status='ERR',MSG='PD'))
	if request.method == 'POST':
		if 'work_id' in request.POST:
			work_id = request.POST['work_id']
			cur_work = work.objects.filter(id=work_id)
			if not cur_work:
				json_data=list(status.objects.filter(status='ERR',MSG='NE'))
				json_dump = serializers.serialize("json", json_data)
				return HttpResponse(json_dump)
			cur_work0 = cur_work[0]
			if cur_work0.client_user == request.user:
				cur_work0.is_active = False
				cur_work0.save()
				json_data = status.objects.filter(status='OK')
	json_dump = serializers.serialize("json", json_data)
	return HttpResponse(json_dump)

@login_required(login_url='/account/logout/', redirect_field_name=None)
def provider_works(request):
	json_data=status.objects.filter(status='ERR',MSG=None)
	json_dump = serializers.serialize("json", json_data)
	user_profile = UserProfile.objects.filter(user=request.user)
	if not user_profile:
		json_data=status.objects.filter(status='ERR',MSG='PD')
		json_dump = serializers.serialize("json", json_data)
		return HttpResponse(json_dump)
	if user_profile[0].is_client:
		json_data=status.objects.filter(status='ERR',MSG='PD')
		json_dump = serializers.serialize("json", json_data)
		return HttpResponse(json_dump)
	today=datetime.date.today()
	all_hidden = hidden_works.objects.filter(provider_user=request.user)
	all_works = work.objects.filter(is_active=1)
	returnArray = []
	for work_i in all_works:
		if check_area(user_profile[0].area_id.id, work_i.area.id) and check_item_level(user_profile[0].level, work_i.item) and (work_i.end_date >= today):
			hidden_flag=0
			for hidden_i in all_hidden:
				if (hidden_i.work_id == work_i):
					hidden_flag=1
			if not hidden_flag:
				cur_item = items.objects.filter(item_id=work_i.item).order_by('id').reverse()
				item_str = ""
				for vlue in cur_item:
					item_str += " " + vlue.value.value
				work_dict = {}
				work_dict['pk'] = int(work_i.id)
				work_dict['model'] = "oos.work"
				work_fields={}
				work_fields['client_user'] = str(work_i.client_user.first_name + " " + work_i.client_user.last_name)
				work_fields['item'] = str(item_str)
				#work_fields['text'] = str(work_i.text)
				#work_fields['area'] = str(work_i.area)
				work_fields['post_date'] = str(work_i.post_date.strftime("%d/%m/%Y"))# %H:%M"))
				#work_fields['end_date'] = str(work_i.end_date.strftime("%d-%m-%Y"))
				work_dict['fields'] = work_fields
				returnArray.append(work_dict)
	prov_prices = price.objects.filter(provider_user=request.user)
	json_data = list(status.objects.filter(status='OK')) + list(prov_prices)
	json_dump = serializers.serialize("json", json_data) + str(list(returnArray))
	return HttpResponse(json_dump.replace('\'','"').replace('][',','))

@login_required(login_url='/account/logout/', redirect_field_name=None)
def get_work(request):
	json_data = status.objects.filter(status='ERR', MSG='NE')
	json_dump = serializers.serialize("json", json_data)
	if request.method == 'POST':
		if 'work_id' not in request.POST:
			return HttpResponse(json_dump)
		work_id = request.POST['work_id']
		if work_id == "" :
			return HttpResponse(json_dump)
		cur_work = work.objects.filter(id=work_id)
		if not cur_work:
			return HttpResponse(json_dump)
		user_profile = UserProfile.objects.filter(user=request.user)
		if not user_profile:
			return HttpResponse(json_dump)
		PD_flag=True
		if (request.user == cur_work[0].client_user ): 
			PD_flag=False
		elif (not user_profile[0].is_client) and check_area(user_profile[0].area_id.id,  cur_work[0].area.id) and check_item_level(user_profile[0].level, cur_work[0].item):
			PD_flag=False
		if PD_flag:
			json_data = status.objects.filter(status='ERR', MSG='PD')
			json_dump = serializers.serialize("json", json_data)
			return HttpResponse(json_dump)
		returnArray = []
		work_i = cur_work[0]
		work_dict = {}
		work_dict['pk'] = int(work_i.id)
		work_dict['model'] = "oos.work"
		work_fields={}
		work_fields['client_user'] = str(work_i.client_user.first_name + " " + work_i.client_user.last_name)
		#work_fields['item'] = str(work_i.item)
		work_fields['text'] = str(work_i.text)
		work_fields['area'] = str(work_i.area)
		work_fields['post_date'] = str(work_i.post_date.strftime("%d/%m/%Y"))# %H:%M"))
		work_fields['end_date'] = str(work_i.end_date.strftime("%d-%m-%Y"))
		work_dict['fields'] = work_fields
		returnArray.append(work_dict)

		cur_item = items.objects.filter(item_id=work_i.item)
		if not cur_item:
			return HttpResponse(json_dump)
		for i in cur_item:
			item_dict={}
			item_dict['pk'] = int(i.value.key.id)
			item_dict['model'] = "oos.itemKV"
			item_fields = {}
			item_fields[str(i.value.key.name)] = str(i.value.value)
			item_dict['fields'] = item_fields
			returnArray.append(item_dict)
		
		cur_pics = pics.objects.filter(work_id=cur_work).only("pic")
		for pic_i in cur_pics:
			pic_dict = {}
			pic_dict['pk'] = int(pic_i.id)
			pic_dict['model'] = "oos.workPic"
			pic_fields = {}
			pic_fields['pic_url'] = "http://" + request.META['HTTP_HOST'] + "/static/" + str(pic_i.pic)
			pic_dict['fields'] = pic_fields
			returnArray.append(pic_dict)
		json_dump = serializers.serialize("json", list(status.objects.filter(status='OK'))) + str(list(returnArray))
	return HttpResponse(json_dump.replace('\'','"').replace('][',',').replace('}, {','},{'))

@login_required(login_url='/account/logout/', redirect_field_name=None)
def get_cats(request):
	json_data = status.objects.filter(status='ERR', MSG='NE')
	json_dump = serializers.serialize("json", json_data)
	all_cats = item_cat.objects.all().order_by('id')
	if not all_cats:
		return HttpResponse(json_dump)
	json_data = list(status.objects.filter(status='OK')) + list(all_cats)
	json_dump = serializers.serialize("json", json_data)
	return HttpResponse(json_dump.replace('\'','"').replace('][',',').replace('}, {','},{'))

@login_required(login_url='/account/logout/', redirect_field_name=None)
def get_keys_for_cat(request):
	json_data = status.objects.filter(status='ERR', MSG='NE')
	json_dump = serializers.serialize("json", json_data)
	if request.method == 'POST':
		if 'cat_id' in request.POST:
			cat_id = request.POST['cat_id']
		else:
			return get_cats(request)
		if cat_id == "" :
			return HttpResponse(json_dump)
		cur_cat = item_cat.objects.filter(id=cat_id)
		if not cur_cat:
			return HttpResponse(json_dump)
		items = item_keys.objects.filter(cat=cur_cat[0]).order_by('id')
		if not items:
			return HttpResponse(json_dump)
		UserProf = UserProfile.objects.filter(user=request.user)
		if not UserProf:
			return HttpResponse(json_dump)
		UserArea = area.objects.filter(id=UserProf[0].area_id.id)
		json_data = list(status.objects.filter(status='OK')) + list(items) + list(UserArea)
		json_dump = serializers.serialize("json", json_data)
	else:
		return get_cats(request)
	return HttpResponse(json_dump.replace('\'','"').replace('][',',').replace('}, {','},{'))

@login_required(login_url='/account/logout/', redirect_field_name=None)
def get_values(request):
	json_data = status.objects.filter(status='ERR', MSG='NE')
	json_dump = serializers.serialize("json", json_data)
	if request.method == 'POST':
		if 'key' in request.POST:
			key_id = request.POST['key']
		else:
			return HttpResponse(json_dump)
		cur_key = item_keys.objects.filter(id=key_id)
		if cur_key[0].parent == None:
			values = item_values.objects.filter(key=cur_key)
		else:
			if 'parent' in request.POST:
				parent_id = request.POST['parent']
				values = item_values.objects.filter(key=cur_key,parent=parent_id)
			else:
				json_data = status.objects.filter(status='ERR', MSG='PD')
				json_dump = serializers.serialize("json", json_data)
				return HttpResponse(json_dump)
		if not values:
			return HttpResponse(json_dump)
		json_data = list(status.objects.filter(status='OK')) + list(values)
		json_dump = serializers.serialize("json", json_data)
	return HttpResponse(json_dump.replace('\'','"').replace('][',',').replace('}, {','},{'))

@login_required(login_url='/account/logout/', redirect_field_name=None)
def post_item(request):
	json_data=list(status.objects.filter(status='ERR',MSG='PD'))
	json_dump = serializers.serialize("json", json_data)
	if UserProfile.objects.get(user=request.user).is_client:
		if request.method == 'POST':
			max_item = int(items.objects.all().aggregate(Max('item_id'))['item_id__max'])+1
			new_max_item = items(item_id=max_item, value=None)
			new_max_item.save()
			for k,v in request.POST.iteritems():
				if k.find("value") == 0:
					cur_value = item_values.objects.filter(id=v)
					if not cur_value:
						return HttpResponse(json_dump)
					new_max_item = items(item_id=max_item, value=cur_value[0])
					new_max_item.save()
			new_max_item = items.objects.filter(item_id=max_item, value=None)
			if not new_max_item:
				json_data=status.objects.filter(status='ERR',MSG=None)
				json_dump = serializers.serialize("json", json_data)
				return HttpResponse(json_dump)
			new_max_item.delete()
			returnArray = []
			work_dict = {}
			work_dict['pk'] = int(max_item)
			work_dict['model'] = "oos.item_id"
			work_fields={}
			work_fields['id'] = int(max_item)
			work_dict['fields'] = work_fields
			returnArray.append(work_dict)
			json_dump = serializers.serialize("json", list(status.objects.filter(status='OK'))) + str(list(returnArray))
		else:
			return HttpResponse(json_dump)
	else:
		return HttpResponse(json_dump)
	return HttpResponse(json_dump.replace('\'','"').replace('][',',').replace('}, {','},{'))

@login_required(login_url='/account/logout/', redirect_field_name=None)
def old_provider_works(request):
	json_data=status.objects.filter(status='ERR',MSG='NE')
	json_dump = serializers.serialize("json", json_data)
	user_profile = UserProfile.objects.filter(user=request.user)
	if not user_profile:
		json_data=status.objects.filter(status='ERR',MSG='PD')
		json_dump = serializers.serialize("json", json_data)
		return HttpResponse(json_dump)
	if user_profile[0].is_client:
		json_data=status.objects.filter(status='ERR',MSG='PD')
		json_dump = serializers.serialize("json", json_data)
		return HttpResponse(json_dump)
	today=datetime.date.today()
	all_hidden = hidden_works.objects.filter(provider_user=request.user)
	all_works = work.objects.filter(is_active=1)
	returnArray = []
	for work_i in all_works:
		if check_area(user_profile[0].area_id.id, work_i.area.id) and check_item_level(user_profile[0].level, work_i.item) and (work_i.end_date < today):
			hidden_flag=0
			for hidden_i in all_hidden:
				if (hidden_i.work_id == work_i):
					hidden_flag=1
			if not hidden_flag:
				cur_item = items.objects.filter(item_id=work_i.item).order_by('id').reverse()
				item_str = ""
				for vlue in cur_item:
					item_str += " " + vlue.value.value
				work_dict = {}
				work_dict['pk'] = int(work_i.id)
				work_dict['model'] = "oos.work"
				work_fields={}
				work_fields['client_user'] = str(work_i.client_user.first_name + " " + work_i.client_user.last_name)
				work_fields['item'] = str(item_str)
				work_fields['post_date'] = str(work_i.post_date.strftime("%d/%m/%Y"))# %H:%M"))
				work_dict['fields'] = work_fields
				returnArray.append(work_dict)
	prov_prices = price.objects.filter(provider_user=request.user)
	json_data = list(status.objects.filter(status='OK')) + list(prov_prices)
	json_dump = serializers.serialize("json", json_data) + str(list(returnArray))
	return HttpResponse(json_dump.replace('\'','"').replace('][',','))

