import os
import sys

sys.path.append('/home/gabi/oos')
os.environ['DJANGO_SETTINGS_MODULE'] = 'oos.settings'

import django.core.handlers.wsgi
application = django.core.handlers.wsgi.WSGIHandler()


