from django.contrib.auth.views import login, logout, password_reset_confirm, password_reset
from django.conf.urls.defaults import *
from web import views

urlpatterns = patterns('web.views',
	(r'^login/$', login),
)

