from django.contrib import admin
from .models import *

@admin.register(SolucionNutritiva)
class SolucionNutritivaAdmin(admin.ModelAdmin):
    list_display = ('nombre', 'litros_disponibles', 'ph_optimo', 'activo')
    list_filter = ('activo', 'tipo_maestra')
    search_fields = ('nombre',)