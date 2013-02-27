from django.http import HttpResponseRedirect, HttpResponse, Http404
from django.shortcuts import render_to_response, get_object_or_404, get_list_or_404
from django.contrib.auth.models import User
from django.contrib.auth import authenticate, login
from account.forms import UserForm, UserProfileForm, AgreeForm
from django.template import RequestContext
from django.utils import simplejson as json


def is_login(request):
	if request.user.is_authenticated():
		c = {}
		c['user'] = request.user
		return render_to_response('account/after_login.html', c)
	else: 
		return HttpResponse('You are not logged in, Please login')

def create_user(request):
	if request.method == 'POST': 
		agree_form = AgreeForm(request.POST)
		userprofile_form = UserProfileForm(request.POST)
		user_form = UserForm(request.POST)
		if userprofile_form.is_valid() and user_form.is_valid() and agree_form.is_valid():	
			user_clean_data = user_form.cleaned_data
			created_user = User.objects.create_user(user_clean_data['username'], user_clean_data['email'], user_clean_data['password1'])
			created_user.save()
			userprofile = userprofile_form.save(commit=False)
			userprofile.user = created_user
			userprofile.minLevel = 0
			userprofile.isCustomer = True
			userprofile.phoneNum = userprofile_form.cleaned_data['phoneNum']
			userprofile.save()
			new_user = authenticate(username=request.POST['username'], password=request.POST['password1'])
			login(request, new_user)

			return HttpResponseRedirect('/account/is_login')
	else:
		userprofile_form = UserProfileForm()
		user_form = UserForm()
		agree_form = AgreeForm()
	return render_to_response('registration/create_user.html', { 'userprofile_form': userprofile_form, 'user_form': user_form, 'agree_form': agree_form}, context_instance=RequestContext(request))

def Plogin (request):
	json_dump = json.dumps({'status': "Error"})
	if request.method == 'POST':
		new_user = authenticate(username=request.POST['username'], password=request.POST['password'])
		if new_user :
			json_dump = json.dumps({'status': "OK"})
			login(request, new_user)
	return HttpResponse(json_dump)
