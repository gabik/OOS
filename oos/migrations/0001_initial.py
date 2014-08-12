# -*- coding: utf-8 -*-
from south.utils import datetime_utils as datetime
from south.db import db
from south.v2 import SchemaMigration
from django.db import models


class Migration(SchemaMigration):

    def forwards(self, orm):
        # Adding model 'item_cat'
        db.create_table(u'oos_item_cat', (
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('name', self.gf('django.db.models.fields.CharField')(max_length=100)),
        ))
        db.send_create_signal(u'oos', ['item_cat'])

        # Adding model 'item_keys'
        db.create_table(u'oos_item_keys', (
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('cat', self.gf('django.db.models.fields.related.ForeignKey')(related_name='item_keys_cat', to=orm['oos.item_cat'])),
            ('name', self.gf('django.db.models.fields.CharField')(max_length=100)),
            ('parent', self.gf('django.db.models.fields.related.ForeignKey')(blank=True, related_name='item_keys_parent', null=True, to=orm['oos.item_keys'])),
        ))
        db.send_create_signal(u'oos', ['item_keys'])

        # Adding model 'item_values'
        db.create_table(u'oos_item_values', (
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('key', self.gf('django.db.models.fields.related.ForeignKey')(related_name='item_values_key', to=orm['oos.item_keys'])),
            ('value', self.gf('django.db.models.fields.CharField')(max_length=100)),
            ('parent', self.gf('django.db.models.fields.related.ForeignKey')(blank=True, related_name='item_keys_parent', null=True, to=orm['oos.item_values'])),
        ))
        db.send_create_signal(u'oos', ['item_values'])

        # Adding model 'items'
        db.create_table(u'oos_items', (
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('item_id', self.gf('django.db.models.fields.PositiveSmallIntegerField')()),
            ('value', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['oos.item_values'], null=True, blank=True)),
        ))
        db.send_create_signal(u'oos', ['items'])

        # Adding model 'item'
        db.create_table(u'oos_item', (
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('parent_id', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['oos.item'], null=True, blank=True)),
            ('name', self.gf('django.db.models.fields.CharField')(max_length=100)),
            ('level', self.gf('django.db.models.fields.PositiveIntegerField')()),
        ))
        db.send_create_signal(u'oos', ['item'])

        # Adding model 'opinion'
        db.create_table(u'oos_opinion', (
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('client_user', self.gf('django.db.models.fields.related.ForeignKey')(related_name='opinion_client', to=orm['auth.User'])),
            ('provider_user', self.gf('django.db.models.fields.related.ForeignKey')(related_name='opinion_provider', to=orm['auth.User'])),
            ('text', self.gf('django.db.models.fields.TextField')()),
            ('rate', self.gf('django.db.models.fields.PositiveSmallIntegerField')()),
            ('post_date', self.gf('django.db.models.fields.DateTimeField')(auto_now_add=True, blank=True)),
            ('show_date', self.gf('django.db.models.fields.DateTimeField')(auto_now=True, blank=True)),
        ))
        db.send_create_signal(u'oos', ['opinion'])

        # Adding model 'work'
        db.create_table(u'oos_work', (
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('client_user', self.gf('django.db.models.fields.related.ForeignKey')(related_name='work_client', to=orm['auth.User'])),
            ('item', self.gf('django.db.models.fields.PositiveIntegerField')()),
            ('text', self.gf('django.db.models.fields.TextField')()),
            ('area', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['account.area'])),
            ('post_date', self.gf('django.db.models.fields.DateTimeField')(auto_now_add=True, blank=True)),
            ('show_date', self.gf('django.db.models.fields.DateTimeField')(auto_now=True, blank=True)),
            ('end_date', self.gf('django.db.models.fields.DateField')()),
            ('is_active', self.gf('django.db.models.fields.BooleanField')(default=True)),
        ))
        db.send_create_signal(u'oos', ['work'])

        # Adding model 'pics'
        db.create_table(u'oos_pics', (
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('work_id', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['oos.work'])),
            ('pic', self.gf('django.db.models.fields.files.FileField')(max_length=100)),
        ))
        db.send_create_signal(u'oos', ['pics'])

        # Adding model 'price'
        db.create_table(u'oos_price', (
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('work_id', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['oos.work'])),
            ('provider_user', self.gf('django.db.models.fields.related.ForeignKey')(related_name='price_provider', to=orm['auth.User'])),
            ('price', self.gf('django.db.models.fields.DecimalField')(max_digits=10, decimal_places=2)),
            ('text', self.gf('django.db.models.fields.TextField')(blank=True)),
            ('post_date', self.gf('django.db.models.fields.DateTimeField')(auto_now_add=True, blank=True)),
            ('show_date', self.gf('django.db.models.fields.DateTimeField')(auto_now=True, blank=True)),
            ('is_active', self.gf('django.db.models.fields.BooleanField')(default=True)),
        ))
        db.send_create_signal(u'oos', ['price'])

        # Adding model 'hidden_works'
        db.create_table(u'oos_hidden_works', (
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('work_id', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['oos.work'])),
            ('provider_user', self.gf('django.db.models.fields.related.ForeignKey')(related_name='hidden_provider', to=orm['auth.User'])),
        ))
        db.send_create_signal(u'oos', ['hidden_works'])


    def backwards(self, orm):
        # Deleting model 'item_cat'
        db.delete_table(u'oos_item_cat')

        # Deleting model 'item_keys'
        db.delete_table(u'oos_item_keys')

        # Deleting model 'item_values'
        db.delete_table(u'oos_item_values')

        # Deleting model 'items'
        db.delete_table(u'oos_items')

        # Deleting model 'item'
        db.delete_table(u'oos_item')

        # Deleting model 'opinion'
        db.delete_table(u'oos_opinion')

        # Deleting model 'work'
        db.delete_table(u'oos_work')

        # Deleting model 'pics'
        db.delete_table(u'oos_pics')

        # Deleting model 'price'
        db.delete_table(u'oos_price')

        # Deleting model 'hidden_works'
        db.delete_table(u'oos_hidden_works')


    models = {
        u'account.area': {
            'Meta': {'object_name': 'area'},
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'name': ('django.db.models.fields.CharField', [], {'max_length': '30'}),
            'parent': ('django.db.models.fields.related.ForeignKey', [], {'to': u"orm['account.area']", 'null': 'True', 'blank': 'True'})
        },
        u'auth.group': {
            'Meta': {'object_name': 'Group'},
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'name': ('django.db.models.fields.CharField', [], {'unique': 'True', 'max_length': '80'}),
            'permissions': ('django.db.models.fields.related.ManyToManyField', [], {'to': u"orm['auth.Permission']", 'symmetrical': 'False', 'blank': 'True'})
        },
        u'auth.permission': {
            'Meta': {'ordering': "(u'content_type__app_label', u'content_type__model', u'codename')", 'unique_together': "((u'content_type', u'codename'),)", 'object_name': 'Permission'},
            'codename': ('django.db.models.fields.CharField', [], {'max_length': '100'}),
            'content_type': ('django.db.models.fields.related.ForeignKey', [], {'to': u"orm['contenttypes.ContentType']"}),
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'name': ('django.db.models.fields.CharField', [], {'max_length': '50'})
        },
        u'auth.user': {
            'Meta': {'object_name': 'User'},
            'date_joined': ('django.db.models.fields.DateTimeField', [], {'default': 'datetime.datetime.now'}),
            'email': ('django.db.models.fields.EmailField', [], {'max_length': '75', 'blank': 'True'}),
            'first_name': ('django.db.models.fields.CharField', [], {'max_length': '30', 'blank': 'True'}),
            'groups': ('django.db.models.fields.related.ManyToManyField', [], {'symmetrical': 'False', 'related_name': "u'user_set'", 'blank': 'True', 'to': u"orm['auth.Group']"}),
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'is_active': ('django.db.models.fields.BooleanField', [], {'default': 'True'}),
            'is_staff': ('django.db.models.fields.BooleanField', [], {'default': 'False'}),
            'is_superuser': ('django.db.models.fields.BooleanField', [], {'default': 'False'}),
            'last_login': ('django.db.models.fields.DateTimeField', [], {'default': 'datetime.datetime.now'}),
            'last_name': ('django.db.models.fields.CharField', [], {'max_length': '30', 'blank': 'True'}),
            'password': ('django.db.models.fields.CharField', [], {'max_length': '128'}),
            'user_permissions': ('django.db.models.fields.related.ManyToManyField', [], {'symmetrical': 'False', 'related_name': "u'user_set'", 'blank': 'True', 'to': u"orm['auth.Permission']"}),
            'username': ('django.db.models.fields.CharField', [], {'unique': 'True', 'max_length': '30'})
        },
        u'contenttypes.contenttype': {
            'Meta': {'ordering': "('name',)", 'unique_together': "(('app_label', 'model'),)", 'object_name': 'ContentType', 'db_table': "'django_content_type'"},
            'app_label': ('django.db.models.fields.CharField', [], {'max_length': '100'}),
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'model': ('django.db.models.fields.CharField', [], {'max_length': '100'}),
            'name': ('django.db.models.fields.CharField', [], {'max_length': '100'})
        },
        u'oos.hidden_works': {
            'Meta': {'object_name': 'hidden_works'},
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'provider_user': ('django.db.models.fields.related.ForeignKey', [], {'related_name': "'hidden_provider'", 'to': u"orm['auth.User']"}),
            'work_id': ('django.db.models.fields.related.ForeignKey', [], {'to': u"orm['oos.work']"})
        },
        u'oos.item': {
            'Meta': {'object_name': 'item'},
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'level': ('django.db.models.fields.PositiveIntegerField', [], {}),
            'name': ('django.db.models.fields.CharField', [], {'max_length': '100'}),
            'parent_id': ('django.db.models.fields.related.ForeignKey', [], {'to': u"orm['oos.item']", 'null': 'True', 'blank': 'True'})
        },
        u'oos.item_cat': {
            'Meta': {'object_name': 'item_cat'},
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'name': ('django.db.models.fields.CharField', [], {'max_length': '100'})
        },
        u'oos.item_keys': {
            'Meta': {'object_name': 'item_keys'},
            'cat': ('django.db.models.fields.related.ForeignKey', [], {'related_name': "'item_keys_cat'", 'to': u"orm['oos.item_cat']"}),
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'name': ('django.db.models.fields.CharField', [], {'max_length': '100'}),
            'parent': ('django.db.models.fields.related.ForeignKey', [], {'blank': 'True', 'related_name': "'item_keys_parent'", 'null': 'True', 'to': u"orm['oos.item_keys']"})
        },
        u'oos.item_values': {
            'Meta': {'object_name': 'item_values'},
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'key': ('django.db.models.fields.related.ForeignKey', [], {'related_name': "'item_values_key'", 'to': u"orm['oos.item_keys']"}),
            'parent': ('django.db.models.fields.related.ForeignKey', [], {'blank': 'True', 'related_name': "'item_keys_parent'", 'null': 'True', 'to': u"orm['oos.item_values']"}),
            'value': ('django.db.models.fields.CharField', [], {'max_length': '100'})
        },
        u'oos.items': {
            'Meta': {'object_name': 'items'},
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'item_id': ('django.db.models.fields.PositiveSmallIntegerField', [], {}),
            'value': ('django.db.models.fields.related.ForeignKey', [], {'to': u"orm['oos.item_values']", 'null': 'True', 'blank': 'True'})
        },
        u'oos.opinion': {
            'Meta': {'object_name': 'opinion'},
            'client_user': ('django.db.models.fields.related.ForeignKey', [], {'related_name': "'opinion_client'", 'to': u"orm['auth.User']"}),
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'post_date': ('django.db.models.fields.DateTimeField', [], {'auto_now_add': 'True', 'blank': 'True'}),
            'provider_user': ('django.db.models.fields.related.ForeignKey', [], {'related_name': "'opinion_provider'", 'to': u"orm['auth.User']"}),
            'rate': ('django.db.models.fields.PositiveSmallIntegerField', [], {}),
            'show_date': ('django.db.models.fields.DateTimeField', [], {'auto_now': 'True', 'blank': 'True'}),
            'text': ('django.db.models.fields.TextField', [], {})
        },
        u'oos.pics': {
            'Meta': {'object_name': 'pics'},
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'pic': ('django.db.models.fields.files.FileField', [], {'max_length': '100'}),
            'work_id': ('django.db.models.fields.related.ForeignKey', [], {'to': u"orm['oos.work']"})
        },
        u'oos.price': {
            'Meta': {'object_name': 'price'},
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'is_active': ('django.db.models.fields.BooleanField', [], {'default': 'True'}),
            'post_date': ('django.db.models.fields.DateTimeField', [], {'auto_now_add': 'True', 'blank': 'True'}),
            'price': ('django.db.models.fields.DecimalField', [], {'max_digits': '10', 'decimal_places': '2'}),
            'provider_user': ('django.db.models.fields.related.ForeignKey', [], {'related_name': "'price_provider'", 'to': u"orm['auth.User']"}),
            'show_date': ('django.db.models.fields.DateTimeField', [], {'auto_now': 'True', 'blank': 'True'}),
            'text': ('django.db.models.fields.TextField', [], {'blank': 'True'}),
            'work_id': ('django.db.models.fields.related.ForeignKey', [], {'to': u"orm['oos.work']"})
        },
        u'oos.work': {
            'Meta': {'object_name': 'work'},
            'area': ('django.db.models.fields.related.ForeignKey', [], {'to': u"orm['account.area']"}),
            'client_user': ('django.db.models.fields.related.ForeignKey', [], {'related_name': "'work_client'", 'to': u"orm['auth.User']"}),
            'end_date': ('django.db.models.fields.DateField', [], {}),
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'is_active': ('django.db.models.fields.BooleanField', [], {'default': 'True'}),
            'item': ('django.db.models.fields.PositiveIntegerField', [], {}),
            'post_date': ('django.db.models.fields.DateTimeField', [], {'auto_now_add': 'True', 'blank': 'True'}),
            'show_date': ('django.db.models.fields.DateTimeField', [], {'auto_now': 'True', 'blank': 'True'}),
            'text': ('django.db.models.fields.TextField', [], {})
        }
    }

    complete_apps = ['oos']