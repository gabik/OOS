from django.db import models
from django.contrib.auth.models import User

class area(models.Model):
	name = models.CharField(max_length=30)

	def __unicode__(self):
		return self.name

class UserProfile(models.Model):
	user = models.ForeignKey(User, unique=True)
	phone_num1 = models.CharField(max_length=30)
	phone_num2 = models.CharField(max_length=30, blank=True, null=True)
	address = models.CharField(max_length=200)
	level = models.IntegerField(default=0)
	birthday = models.DateField(blank=True, null=True)
	is_client = models.BooleanField(default=1)
	area_id = models.ForeignKey(area, unique=False)

	def __unicode__(self):
		return self.user.username

class status(models.Model):
	status = models.CharField(max_length=30)
	MSG = models.CharField(max_length=30, blank=True)
	
	def __unicode__(self):
		return self.status + " : " + str(self.MSG)
