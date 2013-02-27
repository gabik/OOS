from django.contrib.auth.views import login, logout, password_reset_confirm
from django.conf.urls.defaults import *
from account import views

urlpatterns = patterns('account.views',
	(r'^login/$', login),
	(r'^Plogin/$', 'Plogin'),
	(r'^new/$', 'create_user'),
	(r'^Pnew/$', 'create_P_user'),
	(r'^logout/$', logout),
	(r'^is_login/$', 'is_login'),
	#(r'^invation/(?P<guestHash>\w+)/$', 'invation'),
	#(r'^unsubscribe/(?P<guestHash>\w+)/$', 'unsubscribe'),
)

