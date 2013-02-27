from django.db import models
from django.contrib.auth.models import User
from account.models import area

class item(models.Model):
	parent_id = models.ForeignKey('self', unique=False, blank=True, null=True)
	name = models.CharField(max_length=100)
	level = models.PositiveIntegerField()

	def __unicode__(self):
		return self.name

class opinion(models.Model):
	client_user = models.ForeignKey(User, unique=False, related_name='opinion_client')
	provider_user = models.ForeignKey(User, unique=False, related_name='opinion_provider')
	text = models.TextField()
	rate = models.PositiveSmallIntegerField()
	post_date = models.DateTimeField(auto_now_add=True)
	show_date = models.DateTimeField(auto_now=True)

	def __unicode__(self):
		return self.client_user.username

class work(models.Model):
	client_user = models.ForeignKey(User, unique=False, related_name='work_client')
	item = models.ForeignKey(item, unique=False, related_name='work_item')
	text = models.TextField()
	area = models.ForeignKey(area, unique=False)
	post_date = models.DateTimeField(auto_now_add=True)
	show_date = models.DateTimeField(auto_now=True)

	def __unicode__(self):
		return self.item.name + " : " + self.client_user.username

class pics(models.Model):
	work_id = models.ForeignKey('work', unique=False)
	pic = models.FileField(upload_to='work_pics')

	def __unicode__(self):
		return self.work_id.item.name + " : " + self.work_id.client_user.username 

class price(models.Model):
	client_user = models.ForeignKey(User, unique=False, related_name="price_client")
	provider_user = models.ForeignKey(User, unique=False, related_name="price_provider")
	price = models.DecimalField(max_digits=10,decimal_places=2)
	text = models.TextField()
	post_date = models.DateTimeField(auto_now_add=True)
	show_date = models.DateTimeField(auto_now=True)
	is_active = models.BooleanField(default=1)

	def __unicode__(self):
		return self.work_id + " : " + self.provider_user + " : " + self.price

