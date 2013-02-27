from oos.models import item
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

