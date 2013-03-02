from oos.models import item, work, pics
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
		user_profile = UserProfile.objects.get(user=request.user)
		PD_flag=True
		if (request.user == cur_work[0].client_user ) :
			PD_flag=False
		elif (not user_profile.is_client) and check_area(user_profile.area_id.id,  cur_work[0].area.id):
			PD_flag=False
		if PD_flag:
			json_data = status.objects.filter(status='ERR', MSG='PD')
			json_dump = serializers.serialize("json", json_data)
			return HttpResponse(json_dump)
		cur_pics = pics.objects.filter(work_id=cur_work).only("pic")
		json_data = list(status.objects.filter(status='OK')) + list(cur_work) + list(cur_pics) 
		json_dump = serializers.serialize("json", json_data)
	return HttpResponse(json_dump)

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
				errors = list(cur_work.errors.items())
		else:
			json_data=list(status.objects.filter(status='ERR',MSG='PD'))
	else:
		json_data=list(status.objects.filter(status='ERR',MSG='PD'))
	json_dump = serializers.serialize("json", json_data)
	json_dump += str(errors)
	return HttpResponse(json_dump)
			
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
				errors = list(cur_price.errors.items())
		else:
			json_data=list(status.objects.filter(status='ERR',MSG='PD'))
	else:
		json_data=list(status.objects.filter(status='ERR',MSG='PD'))
	json_dump = serializers.serialize("json", json_data)
	json_dump += str(errors)
	return HttpResponse(json_dump)
	#return render_to_response('oos/new_price.html', { 'new_price': cur_price}, context_instance=RequestContext(request))
			
def handle_uploaded_file(file_path):
    dest = open(settings.MEDIA_ROOT + "/work_pics/" + file_path.name,"wb")
    for chunk in file_path.chunks():
        dest.write(chunk)
    dest.close()

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
			errors = list(pic_form.errors.items())
	#else:
		#pic_form = new_pic()
		#return render_to_response('oos/post_pic.html', { 'pic_form': pic_form}, context_instance=RequestContext(request))
	json_dump = serializers.serialize("json", json_data)
	json_dump += str(errors)
	return HttpResponse(json_dump)

