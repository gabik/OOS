from django.http import HttpResponseRedirect, HttpResponse, Http404
from django.shortcuts import render_to_response, get_object_or_404, get_list_or_404
from django.contrib.auth.models import User
from django.contrib.auth import authenticate, login
from account.forms import UserForm, UserProfileForm, AgreeForm, ProvProfileForm, UpdateUserForm
from django.contrib.auth.decorators import login_required
from django.template import RequestContext
from django.utils import simplejson as json
from account.models import status, area, UserProfile
from django.core import serializers
from django.core.mail import EmailMultiAlternatives
import hashlib


def is_login(request):
	if request.user.is_authenticated():
		json_data = status.objects.filter(status='OK')
	else: 
		json_data = status.objects.filter(status='ERR', MSG='LGN')
	json_dump = serializers.serialize("json", json_data)
	return HttpResponse(json_dump)

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

def create_P_user(request):
	json_data=status.objects.filter(status='ERR',MSG=None)
	errors=""
	if request.method == 'POST': 
		userprofile_form = UserProfileForm(request.POST)
		user_form = UserForm(request.POST)
		if userprofile_form.is_valid() and user_form.is_valid():
			user_clean_data = user_form.cleaned_data
			created_user = User.objects.create_user(user_clean_data['username'], user_clean_data['email'], user_clean_data['password1'])
			created_user.first_name=request.POST['firstname']
			created_user.last_name=request.POST['lastname']
			created_user.save()
			userprofile = userprofile_form.save(commit=False)
			userprofile.user = created_user
			userprofile.level = 0
			userprofile.is_client = True
			userprofile.phone_num1 = userprofile_form.cleaned_data['phone_num1']
			userprofile.phone_num2 = userprofile_form.cleaned_data['phone_num2']
			userprofile.address = userprofile_form.cleaned_data['address']
			userprofile.birthday = userprofile_form.cleaned_data['birthday']
			userprofile.area_id = userprofile_form.cleaned_data['area_id']
			userprofile.save()
			new_user = authenticate(username=request.POST['username'], password=request.POST['password1'])
			login(request, new_user)
			json_data = status.objects.filter(status='OK')
		else:
			json_data = status.objects.filter(status='WRN')
			if user_form.errors.items() : 
				errors = ",[" + str(dict([(k, v[0].__str__()) for k, v in user_form.errors.items()])) + "]"
			if userprofile_form.errors.items():
				errors += ",[" + str(dict([(k, v[0].__str__()) for k, v in userprofile_form.errors.items()])) + "]"
	else:
		json_data=list(status.objects.filter(status='ERR',MSG='PD')) 
	json_dump = "[" + serializers.serialize("json", json_data)
	json_dump += errors + "]"
	return HttpResponse(json_dump.replace('\'','"'))

@login_required(login_url='/account/logout/', redirect_field_name=None)
def get_P_email(request):
	json_data=status.objects.filter(status='ERR',MSG=None)
	userdata = {}
	userdata['email'] = str(request.user.email)
	userdump = str(userdata)
	json_data = status.objects.filter(status='OK')
	json_dump = "[" + serializers.serialize("json", json_data)
	json_dump += ",[" + userdump + "]]"
	return HttpResponse(json_dump.replace('\'','"'))

@login_required(login_url='/account/logout/', redirect_field_name=None)
def get_P_profile(request):
	json_data=status.objects.filter(status='ERR',MSG=None)
	userprofile = UserProfile.objects.get(user=request.user)
	userdata = {}
	userdata['first_name'] = str(request.user.first_name)
	userdata['last_name'] = str(request.user.last_name)
	userdata['email'] = str(request.user.email)
	userdata['phone_num1'] = str(userprofile.phone_num1)
	userdata['phone_num2'] = str(userprofile.phone_num2)
	userdata['address'] = str(userprofile.address)
	if userprofile.birthday : 
		userdata['birthday'] = str(userprofile.birthday)
	else : 
		userdata['birthday'] = ""
	userdata['area_id'] = str(userprofile.area_id.id)
	userdump = str(userdata)
	json_data = status.objects.filter(status='OK')
	json_dump = "[" + serializers.serialize("json", json_data)
	json_dump += ",[" + userdump + "]]"
	return HttpResponse(json_dump.replace('\'','"'))

def create_P_user2(request):
	json_dump = json.dumps({'status': "ERR"})
	if request.method == 'POST':
		username=request.POST['username']
		email=request.POST['email']
		password=request.POST['password']
		firstname=request.POST['first_name']
		lastname=request.POST['last_name']
		created_user = User.objects.create_user(username,email,password)
		created_user.first_name=firstname
		created_user.last_name=lastname
		created_user.save()

		phone_num1=request.POST['phoneNum1']
		phone_num2=request.POST['phoneNum2']
		address=request.POST['address']
		birthday=request.POST['birthday']
		area_id=request.POST['area_id']
		userprofile = userprofile_form.save(commit=False)
		userprofile.user = created_user
		userprofile.Level = 0
		userprofile.isCustomer = True
		userprofile.phone_num1 = phone_num1
		userprofile.phone_num2 = phone_num2
		userprofile.address = address
		userprofile.birthday = birthday
		userprofile.area_id = area.objects.get(id=area_id)
		userprofile.save()

		new_user = authenticate(username=request.POST['username'], password=request.POST['password1'])
		login(request, new_user)
		
		json_dump = json.dumps({'status': "OK"})
	else:
		json_dump = json.dumps({'status': "ERR", "MSG": "NoData"})
	return HttpResponse(json_dump)
	

def Plogin (request):
	json_data=list(status.objects.filter(status='ERR',MSG='NE')) 
	if request.method == 'POST':
		json_data=list(status.objects.filter(status='ERR',MSG='NE'))
		new_user = authenticate(username=request.POST['username'], password=request.POST['password'])
		if new_user :
			json_data = status.objects.filter(status='OK')
			if new_user.is_active:
				login(request, new_user)
			else:
				json_data=list(status.objects.filter(status='ERR',MSG='PD'))
	json_dump = serializers.serialize("json", json_data)
	return HttpResponse(json_dump)

def create_P_provider(request):
	json_data=status.objects.filter(status='ERR',MSG=None)
	errors=""
	if request.method == 'POST':
		userprofile_form = ProvProfileForm(request.POST)
		user_form = UserForm(request.POST)
		if userprofile_form.is_valid() and user_form.is_valid():
			user_clean_data = user_form.cleaned_data
			created_user = User.objects.create_user(user_clean_data['username'], user_clean_data['email'], user_clean_data['password1'])
			created_user.first_name=request.POST['firstname']
			created_user.last_name=request.POST['lastname']
			created_user.is_active = False
			created_user.save()
			userprofile = userprofile_form.save(commit=False)
			userprofile.user = created_user
			userprofile.level = userprofile_form.cleaned_data['level']
			userprofile.is_client = False
			userprofile.phone_num1 = userprofile_form.cleaned_data['phone_num1']
			userprofile.phone_num2 = userprofile_form.cleaned_data['phone_num2']
			userprofile.address = userprofile_form.cleaned_data['address']
			userprofile.birthday = userprofile_form.cleaned_data['birthday']
			userprofile.area_id = userprofile_form.cleaned_data['area_id']
			userprofile.hash = hashlib.sha224("OOS" + created_user.username + created_user.email).hexdigest()
			userprofile.save()
			subject = "new provider notice"
			accept_link = 'http://ws.kazav.net/account/accept_prov/' + str(created_user.id) + '/' + userprofile.hash + '/'
			reject_link = 'http://ws.kazav.net/account/reject_prov/' + str(created_user.id) + '/' + userprofile.hash + '/'
			html_message = '<meta http-equiv="Content-Type" content="text/html; charset=utf-8">New provider want access.<BR> Name: ' + created_user.first_name + ' ' + created_user.last_name + '<BR> <a href="' + accept_link + '"> ACCEPT </a> or <a href="' + reject_link + '"> REJECT </a>'
			text_message = 'New provider want access. Name: ' + created_user.first_name + ' ' + created_user.last_name + '      ACCEPT it at: ' + accept_link + '   or   REJECT it ati: ' + reject_link
			user_mail="ohad@kazav.net"
			msg = EmailMultiAlternatives(subject, text_message, 'OOS Server<contact@oos.com>', [user_mail])
			msg.attach_alternative(html_message,"text/html")
			msg.send()

			json_data = status.objects.filter(status='OK')
		else:
			json_data = status.objects.filter(status='WRN')
			errors = ",[" + str(dict([(k, v[0].__str__()) for k, v in user_form.errors.items()])) + "]"
			errors += ",[" + str(dict([(k, v[0].__str__()) for k, v in userprofile_form.errors.items()])) + "]"
	else:
		json_data=list(status.objects.filter(status='ERR',MSG='PD'))
	json_dump = "[" + serializers.serialize("json", json_data)
	json_dump += errors + "]"
	return HttpResponse(json_dump.replace('\'','"'))

@login_required(login_url='/account/logout/', redirect_field_name=None)
def update_P_profile(request):
	json_data=status.objects.filter(status='ERR',MSG=None)
	errors=""
	if request.method == 'POST':
		user_form = UpdateUserForm(request.POST, instance=request.user)
		userprofile_form = UserProfileForm(request.POST, instance=request.user)
		userprofile_old = UserProfile.objects.get(user=request.user)
		user_old = request.user
		if userprofile_form.is_valid() and user_form.is_valid() :
			userprofile_old.phone_num1 = userprofile_form.cleaned_data['phone_num1']
			userprofile_old.phone_num2 = userprofile_form.cleaned_data['phone_num2']
			userprofile_old.address = userprofile_form.cleaned_data['address']
			userprofile_old.birthday = userprofile_form.cleaned_data['birthday']
			userprofile_old.area_id = userprofile_form.cleaned_data['area_id']
			userprofile_old.save()
			user_old.first_name = user_form.cleaned_data['first_name']
			user_old.last_name = user_form.cleaned_data['last_name']
			user_old.email = user_form.cleaned_data['email']
			user_old.save()
			json_data = status.objects.filter(status='OK')
		else:
			json_data = status.objects.filter(status='WRN')
			errors = ",[" + str(dict([(k, v[0].__str__()) for k, v in user_form.errors.items()])) + "]"
			errors += ",[" + str(dict([(k, v[0].__str__()) for k, v in userprofile_form.errors.items()])) + "]"
	else:
		json_data=list(status.objects.filter(status='ERR',MSG='PD'))
	json_dump = "[" + serializers.serialize("json", json_data)
	json_dump += errors + "]"
	return HttpResponse(json_dump.replace('\'','"'))

@login_required(login_url='/account/logout/', redirect_field_name=None)
def change_P_pass(request):
	json_data=status.objects.filter(status='ERR',MSG=None)
	errors={}
	if request.method == 'POST':
		if request.POST['password1'] == request.POST['password2'] : 
			if len(request.POST['password1']) >= 6 :
				user_old = request.user
				user_old.set_password(request.POST['password1'])
				user_old.save()
				json_data = status.objects.filter(status='OK')
			else:
				json_data = status.objects.filter(status='WRN')
				errors['password'] = ["min 6 chars"]
		else:
			json_data = status.objects.filter(status='WRN')
			errors['password'] = ["no match"]
	else:
		json_data=list(status.objects.filter(status='ERR',MSG='PD'))
	if errors.items():
		errors = ",[" + str(dict([(k, v[0].__str__()) for k, v in errors.items()])) + "]"
	else:
		errors = ""	
	json_dump = "[" + serializers.serialize("json", json_data)
	json_dump += errors + "]"
	return HttpResponse(json_dump.replace('\'','"'))

def accept_prov(requesti, UserId, UserHash):
	msg = "Error... unknowd.. Shit.."
	cur_user = User.objects.filter(id=UserId)
	if cur_user:
		cur_profile = UserProfile.objects.filter(user=cur_user[0])
		if cur_profile:
			cur_hash = cur_profile[0].hash
			if UserHash == cur_hash:
				if cur_hash == 'LK' or cur_hash == 'OK':
					msg = "Cannot accept rejected provider (or viseversa)"
				else:
					cur_profile[0].hash="OK"
					cur_profile[0].save()
					cur_user[0].is_active=True
					cur_user[0].save()
					msg = cur_user[0].username + " Has been activated. i sent him a mail."
					subject = "Account activated"
					html_message = '<meta http-equiv="Content-Type" content="text/html; charset=utf-8">Your Account has activated!<BR>You can login with the username ' + cur_user[0].username
					text_message = 'Your Account has activated!<BR>You can login with the username ' + cur_user[0].username
					user_mail = cur_user[0].email
					emsg = EmailMultiAlternatives(subject, text_message, 'OOS Server<contact@oos.com>', [user_mail])
					emsg.attach_alternative(html_message,"text/html")
					emsg.send()
			else:
				msg = "Hash do not match... do not fool me!"
		else:
			msg = "User has no profile.. check Admin"
	else:
		msg = "Unknown User ID.. not exist"
	return HttpResponse(msg)

def reject_prov(requesti, UserId, UserHash):
	msg = "Error... unknowd.. Shit.."
	cur_user = User.objects.filter(id=UserId)
	if cur_user:
		cur_profile = UserProfile.objects.filter(user=cur_user[0])
		if cur_profile:
			cur_hash = cur_profile[0].hash
			if UserHash == cur_hash:
				if cur_hash == 'LK' or cur_hash == 'OK':
					msg = "Cannot reject accepted provider (or viseversa)"
				else:
					cur_user[0].username += ".LK"
					cur_user[0].email += ".LK"
					cur_user[0].save()
					cur_profile[0].hash = "LK"
					cur_profile[0].save()
					msg = cur_user[0].username + " Has been Deactivated. No mail was sent to provider"
					#subject = "Account activated"
					#html_message = '<meta http-equiv="Content-Type" content="text/html; charset=utf-8">Your Account has activated!<BR>You can login with the username ' + cur_user.username
					#text_message = 'Your Account has activated!<BR>You can login with the username ' + cur_user.username
					#user_mail = cur_user.email
					#emsg = EmailMultiAlternatives(subject, text_message, 'OOS Server<contact@oos.com>', [user_mail])
					#emsg.attach_alternative(html_message,"text/html")
					#emsg.send()
			else:
				msg = "Hash do not match... do not fool me!"
		else:
			msg = "User has no profile.. check Admin"
	else:
		msg = "Unknown User ID.. not exist"
	return HttpResponse(msg)

def check_area(higher, lower):
	if higher == lower:
		answer = True
	else:
		cur_lower = area.objects.filter(id=lower)
		if  cur_lower:
			parent_lower = cur_lower[0].parent
			if not parent_lower:
				answer = False
			else:
				answer = check_area(higher, cur_lower[0].parent.id)
		else:
			answer = False
	return answer

def reset_P_password(request):
	json_data=status.objects.filter(status='ERR',MSG=None)
	errors=""
	if request.method == 'POST':
		user_mail = request.POST['email']
		user = User.objects.filter(email=user_mail)
		if user : 
			userprof = UserProfile.objects.get(user=user[0])
			userprof.hash = hashlib.sha224("PWD" + user[0].username + user[0].email).hexdigest()
			userprof.save()
			subject = "Reset Password"
			accept_link = 'http://ws.kazav.net/account/resetaccept/' + str(request.user.id) + '/' + userprof.hash + '/'
			html_message = '<meta http-equiv="Content-Type" content="text/html; charset=utf-8">We got a request to reset your password.<BR> <a href="' + accept_link + '"> Click Here To Reset Your Password </a>'
			text_message = 'We got a request to reset your password. please go to ' + accept_link + ' in order to do it.'
			msg = EmailMultiAlternatives(subject, text_message, 'OOS Server<contact@oos.com>', [user_mail])
			msg.attach_alternative(html_message,"text/html")
			msg.send()
			json_data = status.objects.filter(status='OK')
		else:
			json_data=list(status.objects.filter(status='ERR',MSG='PD'))
	else:
		json_data=list(status.objects.filter(status='ERR',MSG='PD'))
	json_dump = "[" + serializers.serialize("json", json_data)
	json_dump += errors + "]"
	return HttpResponse(json_dump.replace('\'','"'))

def reset_pass_link(request, UserId, UserHash):
	msg = "Error... unknowd.. Shit.."
	cur_user = User.objects.filter(id=UserId)
	if cur_user:
		cur_profile = UserProfile.objects.filter(user=cur_user[0])
		if cur_profile:
			cur_hash = cur_profile[0].hash
			if UserHash == cur_hash:
				#msg = '<meta http-equiv="Content-Type" content="text/html; charset=utf-8"><form action=/account/reset_pass_do/ method=post>Enter New Password:<input type=text name=password_new><input type=hidden name=userid value=' + UserId + '><input type=hidden value=' + UserHash + 'name=userhash><input type=submit>'
				msg = '''<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
<script type="text/javascript"> 
function pvalidate() 
{ 
if ((document.registration.pass1.value != document.registration.pass2.value) || (document.registration.pass1.value == ""))
{ 
alert("Passwords did not match!"); 
return false; 
} else { 
document.registration.submit(); 
return true; 
} 
}
</script> 
<form action=/account/reset_pass_do/ method=post onsubmit="return pvalidate()" name="registration">Enter New Password:<input type=password name=pass1 id=pass1><BR>Validate Password:<input type=password name=pass2 id=pass2><BR><input type=hidden name=userid value=''' + UserId + '''><input type=hidden value=''' + UserHash + ''' name=userhash><input type="button" onclick="return pvalidate()" value="Submit">  '''
			else:
				msg = "Hash do not match... do not fool me!"
		else:
			msg = "User has no profile.. check Admin"
	else:
		msg = "Unknown User ID.. not exist"
	return HttpResponse(msg)

def reset_pass_do(request):
	msg="Error accured.. sorry - contact support"
	cur_user = User.objects.filter(id=request.POST['userid'])
	if cur_user:
		cur_profile = UserProfile.objects.filter(user=cur_user[0])
		if cur_profile:
			cur_hash = cur_profile[0].hash
			if request.POST['userhash'] == cur_hash:
				cur_profile[0].hash = hashlib.sha224("OOS" + cur_user[0].username + cur_user[0].email).hexdigest()
				cur_profile[0].save()
				cur_user[0].set_password(request.POST['pass1'])
				cur_user[0].save()
				msg = "Password changed."
			else:
				msg = "Hash do not match... do not fool me!"
		else:
			msg = "User has no profile.. check Admin"
	else:
		msg = "Unknown User ID.. not exist"
	return HttpResponse(msg)

			
				
		

