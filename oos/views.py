from oos.models import item, work, pics
from django.utils import simplejson as json
from django.contrib.auth.decorators import login_required
from django.http import HttpResponseRedirect, HttpResponse, Http404
from django.template import RequestContext
from django.shortcuts import render_to_response, get_object_or_404, redirect
from django.contrib.auth.models import User
from django.core import serializers

@login_required(login_url='/account/logout/', redirect_field_name=None)
def get_child(request):
	json_dump = json.dumps({'status': "ERR"})
	if request.method == 'POST':
		parent = request.POST['parent']
		if parent == "" :
			parent = None
		items = item.objects.filter(parent_id=parent)
		json_dump = serializers.serialize("json", items)
	return HttpResponse(json_dump)

@login_required(login_url='/account/logout/', redirect_field_name=None)
def get_work(request):
	json_dump = json.dumps({'status': "ERR"})
	if request.method == 'POST':
		work_id = request.POST['work_id']
		if work_id == "" :
			return HttpResponse(json_dump)
		cur_work = work.objects.filter(id=work_id)
		if not cur_work:
			return HttpResponse(json_dump)
		cur_pics = pics.objects.filter(work_id=cur_work).only("pic")
		json_data = list(cur_work) + list(cur_pics)
		json_dump = serializers.serialize("json", json_data)
	return HttpResponse(json_dump)

