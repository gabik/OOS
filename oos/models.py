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
	end_date = models.DateField()
	is_active = models.BooleanField(default=1)

	def __unicode__(self):
		return self.item.name + " : " + self.client_user.username

class pics(models.Model):
	work_id = models.ForeignKey('work', unique=False)
	pic = models.FileField(upload_to='work_pics')

	def __unicode__(self):
		return self.work_id.item.name + " : " + self.work_id.client_user.username 

class price(models.Model):
	work_id = models.ForeignKey(work, unique=False)
	provider_user = models.ForeignKey(User, unique=False, related_name="price_provider")
	price = models.DecimalField(max_digits=10,decimal_places=2)
	text = models.TextField()
	post_date = models.DateTimeField(auto_now_add=True)
	show_date = models.DateTimeField(auto_now=True)
	is_active = models.BooleanField(default=1)

	def __unicode__(self):
		return str(self.work_id) + " : " + str(self.provider_user) + " : " + str(self.price)

class hidden_works(models.Model):
	work_id = models.ForeignKey(work, unique=False)
	provider_user = models.ForeignKey(User, unique=False, related_name="hidden_provider")

	def __unicode__(self):
		return str(self.work_id) + " : " + str(self.provider_user) 

class item_cat(models.Model):
	name = models.CharField(max_length=100)

	def __unicode__(self):
		return str(self.id) + " : " + str(self.name)

class item_keys(models.Model):
	cat = models.ForeignKey(item_cat, unique=False, related_name="item_keys_cat")
	name = models.CharField(max_length=100)
	parent = models.ForeignKey('self', unique=False, blank=True, null=True, related_name="item_keys_parent")

	def __unicode__(self):
		return str(self.id) + " : (" + str(self.cat) + ") : " + str(self.name) 

class item_values(models.Model):
	key = models.ForeignKey(item_keys, unique=False, related_name="item_values_key")
	value = models.CharField(max_length=100)
	parent = models.ForeignKey('self', unique=False, blank=True, null=True, related_name="item_keys_parent")

	def __unicode__(self):
		return str(self.id) + " : (" + str(self.key) + ") : " + str(self.value) 

class items(models.Model):
	item_id = models.PositiveSmallIntegerField()
	value = models.ForeignKey(item_values, unique=False, blank=False, null=False)

	def __unicode__(self):
		return str(self.id) + " : (" + str(self.item_id) + ") : " + str(self.value)
