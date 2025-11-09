from rest_framework import serializers
from .models import AlertaSistema

class AlertaSistemaSerializer(serializers.ModelSerializer):
    cultivo_nombre = serializers.CharField(source='cultivo.nombre', read_only=True)

    class Meta:
        model = AlertaSistema
        fields = ['id', 'tipo_alerta', 'mensaje', 'severidad', 'activa', 'fecha_creacion', 'cultivo_nombre']