from django.contrib.auth.views import login, logout, password_reset_confirm, password_reset
#from django.conf.urls.defaults import *
from django.conf.urls import patterns
from account import views

urlpatterns = patterns('account.views',
	(r'^login/$', login),
	(r'^Plogin/$', 'Plogin'),
	(r'^new/$', 'create_user'),
	(r'^Pnew/$', 'create_P_user'),
	(r'^Pnew_prov/$', 'create_P_provider'),
	(r'^Pupdate_prof/$', 'update_P_profile'),
	(r'^Pget_profile/$', 'get_P_profile'),
	(r'^Pget_email/$', 'get_P_email'),
	(r'^Pcng_pass/$', 'change_P_pass'),
	(r'^logout/$', logout),
	(r'^is_login/$', 'is_login'),
	(r'^get_areas/$', 'get_all_areas'),
	(r'^resetPWD/$', 'reset_P_password'),
	(r'^resetaccept/(?P<UserId>\d+)/(?P<UserHash>\w+)/$', 'reset_pass_link'),
	(r'^reset_pass_do/$', 'reset_pass_do'),
	(r'^accept_prov/(?P<UserId>\d+)/(?P<UserHash>\w+)/$', 'accept_prov'),
	(r'^reject_prov/(?P<UserId>\d+)/(?P<UserHash>\w+)/$', 'reject_prov'),
	#(r'^unsubscribe/(?P<guestHash>\w+)/$', 'unsubscribe'),
)

