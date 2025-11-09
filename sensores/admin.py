from django.contrib import admin
from .models import Sensor, LecturaSensor

@admin.register(Sensor)
class SensorAdmin(admin.ModelAdmin):
    list_display = ('nombre', 'tipo_maestra', 'unidad_maestra', 'activo')
    list_filter = ('activo', 'tipo_maestra')
    search_fields = ('nombre',)

@admin.register(LecturaSensor)
class LecturaSensorAdmin(admin.ModelAdmin):
    list_display = ('sensor', 'valor', 'fecha_hora')
    list_filter = ('sensor',)