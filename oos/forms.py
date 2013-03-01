from django import forms
from oos.models import item, work, price
from django.forms import ModelForm
import csv

class new_work(ModelForm):
  class Meta:
    model = work
    exclude = ('client_user')

class new_price(ModelForm):
  class Meta:
    model = price
    exclude = ('provider_user', 'is_active')
