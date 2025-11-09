from rest_framework import serializers
from .models import Sensor, LecturaSensor

class SensorSerializer(serializers.ModelSerializer):
    tipo = serializers.StringRelatedField(source='tipo_maestra.nombre')
    unidad = serializers.StringRelatedField(source='unidad_maestra.valor')

    class Meta:
        model = Sensor
        fields = ['id', 'nombre', 'tipo', 'unidad', 'descripcion']

class LecturaSensorSerializer(serializers.ModelSerializer):
    class Meta:
        model = LecturaSensor
        fields = ['sensor', 'fecha_hora', 'valor']