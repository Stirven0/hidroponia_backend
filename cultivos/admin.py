from django.contrib import admin
from .models import Cultivo

@admin.register(Cultivo)
class CultivoAdmin(admin.ModelAdmin):
    list_display = ('nombre', 'estado_maestra', 'tipo_cultivo_maestra', 'activo')
    list_filter = ('activo', 'estado_maestra')
    search_fields = ('nombre',)