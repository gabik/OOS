# -*- coding: utf-8 -*-
from south.utils import datetime_utils as datetime
from south.db import db
from south.v2 import SchemaMigration
from django.db import models


class Migration(SchemaMigration):

    def forwards(self, orm):
        # Deleting field 'item_cat.img'
        db.delete_column(u'oos_item_cat', 'img')


    def backwards(self, orm):
        # Adding field 'item_cat.img'
        db.add_column(u'oos_item_cat', 'img',
                      self.gf('django.db.models.fields.files.ImageField')(default='category_img/default.jpg', max_length=100),
                      keep_default=False)


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