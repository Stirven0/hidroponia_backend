from rest_framework import serializers
from .models import Cultivo

class CultivoSerializer(serializers.ModelSerializer):
    estado = serializers.StringRelatedField(source='estado_maestra.nombre')
    tipo = serializers.StringRelatedField(source='tipo_cultivo_maestra.nombre')

    class Meta:
        model = Cultivo
        fields = ['id', 'nombre', 'tiempo_cosecha_dias', 'estado', 'tipo', 'fecha_inicio', 'fecha_estimada_cosecha', 'descripcion']