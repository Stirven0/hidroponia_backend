from django.contrib import admin
from .models import AlertaSistema

@admin.register(AlertaSistema)
class AlertaSistemaAdmin(admin.ModelAdmin):
    list_display = ('tipo_alerta', 'mensaje', 'severidad', 'activa', 'fecha_creacion')
    list_filter = ('activa', 'severidad', 'tipo_alerta')
    search_fields = ('mensaje',)