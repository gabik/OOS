from django import forms
from oos.models import item, work
from django.forms import ModelForm
import csv

class new_work(ModelForm):
  class Meta:
    model = work
    exclude = ('client_user')

