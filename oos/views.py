import datetime
from oos.models import item, work, pics, price, hidden_works
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

def check_item_level(higher, lower):
	if higher == lower:
		answer = True
	else:
		cur_lower = item.objects.filter(id=lower)
		if  cur_lower:
			parent_lower = cur_lower[0].parent_id
			if not parent_lower:
				answer = False
			else:
				answer = check_item_level(higher, cur_lower[0].parent_id.id)
		else:
			answer = False
	return answer

def get_root_parent(itemid):
	cur_item = item.objects.filter(id=itemid)
	if cur_item[0].parent_id == None:
		answer = cur_item[0].id
	else:
		parent = item.objects.filter(id=cur_item[0].parent_id.id)
		answer = get_root_parent(parent[0].id)
	return answer

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
		price_id = request.POST['price_id']
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
	all_work = work.objects.filter(client_user=request.user)
	if not all_work:
		json_data = status.objects.filter(status='WRN', MSG='EMP')
		json_dump = serializers.serialize("json", json_data)
	else:
		json_data = list(status.objects.filter(status='OK')) 
		all_works = []
		for i in all_work:
			root_parent_name = item.objects.get(id=get_root_parent(i.item.id)).name
			all_works_dict = {}
			all_works_dict['pk'] = int(i.id)
			all_works_dict['model'] = "oos.work"
			all_works_dict['fields'] = {'item': str(i.item.name), 'root_parent': str(root_parent_name)}
			all_works.append(all_works_dict)
			#json_data+= list(all_works_dict) 
		json_dump = serializers.serialize("json", list(status.objects.filter(status='OK'))) + str(list(all_works)) #serializers.serialize("json", json_data)
	return HttpResponse(json_dump.replace('\'','"').replace('][',','))

@login_required(login_url='/account/logout/', redirect_field_name=None)
def get_user(request):
	json_data = status.objects.filter(status='ERR',MSG='NE')
	json_dump = serializers.serialize("json", json_data)
	if request.method == 'POST':
		user_id = request.POST['user_id']
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
	errors=""
	if UserProfile.objects.get(user=request.user).is_client:
		if request.method == 'POST':
			cur_work = new_work(request.POST)
			if cur_work.is_valid():
				work_clean = cur_work.cleaned_data
				if item.objects.filter(parent_id=request.POST['item']) :
					json_data=list(status.objects.filter(status='ERR',MSG='PD'))
				else:
					cur_work_save = cur_work.save(commit=False)
					cur_work_save.client_user = request.user
					cur_work_save.save()
					json_data = status.objects.filter(status='OK')
			else:
				json_data = status.objects.filter(status='WRN')
				#errors = list(cur_work.errors.items())
				errors = str([(k, v[0].__str__()) for k, v in cur_work.errors.items()])
		else:
			json_data=list(status.objects.filter(status='ERR',MSG='PD'))
	else:
		json_data=list(status.objects.filter(status='ERR',MSG='PD'))
	json_dump = serializers.serialize("json", json_data)
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
					price_clean = cur_price.cleaned_data
					cur_price_save = cur_price.save(commit=False)
					cur_price_save.provider_user = request.user
					cur_price_save.is_active = True
					cur_price_save.save()
					json_data = status.objects.filter(status='OK')
				else:
					json_data=list(status.objects.filter(status='ERR',MSG='PD'))
			else:
				json_data = status.objects.filter(status='WRN')
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
			json_data = status.objects.filter(status='WRN')
			#errors = list(pic_form.errors.items())
			errors = str([(k, v[0].__str__()) for k, v in cur_form.errors.items()])
	#else:
		#pic_form = new_pic()
		#return render_to_response('oos/post_pic.html', { 'pic_form': pic_form}, context_instance=RequestContext(request))
	json_dump = serializers.serialize("json", json_data)
	json_dump += errors
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
	all_hidden = hidden_works.objects.filter(provider_user=request.user)
	all_works = work.objects.filter(is_active=1)
	returnArray = []
	for work_i in all_works:
		if check_area(user_profile[0].area_id.id, work_i.area.id) and check_item_level(user_profile[0].level, work_i.item.id):
			hidden_flag=0
			for hidden_i in all_hidden:
				if (hidden_i.work_id == work_i):
					hidden_flag=1
			if not hidden_flag:
				work_dict = {}
				work_dict['pk'] = int(work_i.id)
				work_dict['model'] = "oos.work"
				work_fields={}
				work_fields['client_user'] = str(work_i.client_user.first_name + " " + work_i.client_user.last_name)
				work_fields['item'] = str(work_i.item)
				#work_fields['text'] = str(work_i.text)
				#work_fields['area'] = str(work_i.area)
				work_fields['post_date'] = str(work_i.post_date.strftime("%d/%m/%Y"))# %H:%M"))
				#work_fields['end_date'] = str(work_i.end_date.strftime("%d-%m-%Y"))
				work_dict['fields'] = work_fields
				returnArray.append(work_dict)
	json_dump = serializers.serialize("json", list(status.objects.filter(status='OK'))) + str(list(returnArray))
	return HttpResponse(json_dump.replace('\'','"').replace('][',','))

@login_required(login_url='/account/logout/', redirect_field_name=None)
def get_work(request):
	json_data = status.objects.filter(status='ERR', MSG='NE')
	json_dump = serializers.serialize("json", json_data)
	if request.method == 'POST':
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
		elif (not user_profile[0].is_client) and check_area(user_profile[0].area_id.id,  cur_work[0].area.id) and check_item_level(user_profile[0].level, cur_work[0].item.id):
			PD_flag=False
		if PD_flag:
			json_data = status.objects.filter(status='ERR', MSG='PD')
			json_dump = serializers.serialize("json", json_data)
			return HttpResponse(json_dump)
		returnArray = []
		for work_i in cur_work:
			work_dict = {}
			work_dict['pk'] = int(work_i.id)
			work_dict['model'] = "oos.work"
			work_fields={}
			work_fields['client_user'] = str(work_i.client_user.first_name + " " + work_i.client_user.last_name)
			work_fields['item'] = str(work_i.item)
			work_fields['text'] = str(work_i.text)
			work_fields['area'] = str(work_i.area)
			work_fields['post_date'] = str(work_i.post_date.strftime("%d/%m/%Y"))# %H:%M"))
			work_fields['end_date'] = str(work_i.end_date.strftime("%d-%m-%Y"))
			work_dict['fields'] = work_fields
			returnArray.append(work_dict)
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
