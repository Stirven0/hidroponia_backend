from rest_framework import serializers
from .models import SolucionNutritiva

class SolucionNutritivaSerializer(serializers.ModelSerializer):
    tipo = serializers.StringRelatedField(source='tipo_maestra.nombre')

    class Meta:
        model = SolucionNutritiva
        fields = [
            'id', 'nombre', 'tipo', 'litros_disponibles',
            'ph_optimo', 'conductividad_optima', 'descripcion', 'activo'
        ]