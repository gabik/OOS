from django.db import models
from django.contrib.auth.models import User

class UserProfile(models.Model):
	user = models.ForeignKey(User, unique=True)
	phoneNum = models.CharField(max_length=30)
	minLevel = models.IntegerField(default=0)
	isCustomer = models.BooleanField(default=1)
        def __unicode__(self):
                printy = self.user.username
                return printy

# Create your models here.
