from django.conf.urls import patterns, include, url
from django.contrib import admin
from django.conf import settings
from oos.views import get_child, get_work, get_user, post_work, post_price, post_pic, get_works, get_prices, get_BC, provider_works
admin.autodiscover()

urlpatterns = patterns('',
	(r'^account/', include('account.urls')),
	(r'^oos/get_child/$', get_child),
	(r'^oos/get_work/$', get_work),
	(r'^oos/get_works/$', get_works),
	(r'^oos/get_user/$', get_user),
	(r'^oos/post_work/$', post_work),
	(r'^oos/post_price/$', post_price),
	(r'^oos/post_pic/$', post_pic),
	(r'^oos/get_prices/$', get_prices),
	(r'^oos/get_BC/$', get_BC),
	(r'^oos/get_prov_works/$', provider_works),
	(r'^admin/', include(admin.site.urls)),
	(r'^static/admin/(?P<path>.*)$', 'django.views.static.serve', {'document_root': settings.ADMIN_MEDIA_ROOT}),
	(r'^static/(?P<path>.*)$', 'django.views.static.serve', {'document_root': settings.MEDIA_ROOT}),

    # url(r'^$', 'oos.views.home', name='home'),
    # url(r'^oos/', include('oos.foo.urls')),

    # Uncomment the admin/doc line below to enable admin documentation:
    # url(r'^admin/doc/', include('django.contrib.admindocs.urls')),
)
