from django import forms
from django.forms import ModelForm
from account.models import UserProfile, User
#from captcha.fields import CaptchaField

class AgreeForm(forms.Form):
	#captcha = CaptchaField()
	IAgree = forms.BooleanField(required=True)

class UserForm(forms.Form):
	username = forms.CharField(max_length=100, label = 'Username')
	email = forms.EmailField(label = 'E-Mail', required=True)
	password1 = forms.CharField(max_length=20, widget = forms.PasswordInput, label = 'Password')
	password2 = forms.CharField(max_length=20, widget = forms.PasswordInput, label = 'Confirm Password')

	def clean_password1(self):
		password1 = self.cleaned_data['password1']
		if len(password1) < 5:
			raise forms.ValidationError('Minimus 5 chars')
		return password1

	def clean_password2(self):
		password2 = self.cleaned_data['password2']
		try:
			password1 = self.cleaned_data['password1']
		except KeyError:
			return password2
		if password1 != password2:
			raise forms.ValidationError('Please check the password')
		return password2

	def clean_email(self):
		try:
			User.objects.get(email=self.cleaned_data['email'])
			raise forms.ValidationError('Bad email address')
		except User.DoesNotExist:
			return self.cleaned_data['email']

	def clean_username(self):
		try:
			User.objects.get(username=self.cleaned_data['username'])
			raise forms.ValidationError('Bad username')
		except User.DoesNotExist:
			return self.cleaned_data['username']
        

class UserProfileForm(ModelForm):
	class Meta:
		model = UserProfile
		exclude = ('user', 'is_client', 'level', 'hash')

class ProvProfileForm(ModelForm):
	class Meta:
		model = UserProfile
		exclude = ('user', 'is_client', 'hash')

class UpdateUserForm(ModelForm):
	class Meta:
		model = User
		fields = ('first_name', 'last_name', 'email' )
