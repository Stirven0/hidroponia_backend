from django.contrib import admin
from .models import Actuador

@admin.register(Actuador)
class ActuadorAdmin(admin.ModelAdmin):
    list_display = ('nombre', 'tipo_maestra', 'activo')
    list_filter = ('activo', 'tipo_maestra')
    search_fields = ('nombre',)