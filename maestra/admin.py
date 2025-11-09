from django.contrib import admin
from .models import Maestra, ParametroCultivo

@admin.register(Maestra)
class MaestraAdmin(admin.ModelAdmin):
    list_display = ('nombre', 'tipo_maestra', 'valor', 'activo')
    list_filter = ('tipo_maestra', 'activo')
    search_fields = ('nombre',)

@admin.register(ParametroCultivo)
class ParametroCultivoAdmin(admin.ModelAdmin):
    list_display = ('tipo_cultivo_nombre', 'parametro', 'minimo', 'maximo', 'unidad_nombre')
    list_filter = ('tipo_cultivo_maestra', 'parametro')

    def tipo_cultivo_nombre(self, obj):
        return obj.tipo_cultivo_maestra.nombre
    tipo_cultivo_nombre.short_description = 'Tipo Cultivo'

    def unidad_nombre(self, obj):
        return obj.unidad_maestra.nombre if obj.unidad_maestra else '-'
    unidad_nombre.short_description = 'Unidad'