from django.db import models
from django.contrib.auth.models import User

class item(models.Model):
	parent_id = models.PositiveIntegerField()
	name = models.CharField(max_length=100)
	level = models.PositiveIntegerField()

	def __unicode__(self):
		return self.name

class opinion(models.Model):
	client_user = models.ForeignKey(User, unique=False, related_name='opinion_client')
	provider_user = models.ForeignKey(User, unique=False, related_name='opinion_provider')
	text = models.TextField()
	rate = models.PositiveSmallIntegerField()

	def __unicode__(self):
		return self.client_user.username
