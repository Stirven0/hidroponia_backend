from rest_framework import serializers
from .models import Actuador

class ActuadorSerializer(serializers.ModelSerializer):
    tipo = serializers.StringRelatedField(source='tipo_maestra.nombre')

    class Meta:
        model = Actuador
        fields = ['id', 'nombre', 'tipo', 'descripcion', 'activo']