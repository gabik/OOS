from oos.models import item, work, pics
from account.models import UserProfile, area, status
from django.utils import simplejson as json
from django.contrib.auth.decorators import login_required
from django.http import HttpResponseRedirect, HttpResponse, Http404
from django.template import RequestContext
from django.shortcuts import render_to_response, get_object_or_404, redirect
from django.contrib.auth.models import User
from django.core import serializers

@login_required(login_url='/account/logout/', redirect_field_name=None)
def get_child(request):
	json_data = status.objects.filter(status='ERR')
	if request.method == 'POST':
		parent = request.POST['parent']
		if (parent == "") or (parent == "0") :
			parent = None
		items = list(item.objects.filter(parent_id=parent))
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
		elif (not user_profile.is_client) and (user_profile.area_id == cur_work[0].area):
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
		cur_user_dict={'username':cur_user.username,'email':cur_user.email,'firstname':cur_user.first_name,'lastname':cur_user.last_name}
		json_data = list(status.objects.filter(status='OK')) + list(cur_profile)
		json_dump = serializers.serialize("json", json_data)
		json_dump += str([cur_user_dict])
	return HttpResponse(json_dump)

			
