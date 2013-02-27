from django import forms
from oos.models import item
from django.forms import ModelForm
import csv

class items_import(forms.Form):
	file = forms.FileField()

	class Meta:
		model = item

	def save(self):
		records = csv.reader(self.cleaned_data["file"])
		for line in records:
			input_data = Data()
			input_data.parent_id = line[1]
			input_data.name = line[2]
			input_data.level = line[3]
			input_data.save()

