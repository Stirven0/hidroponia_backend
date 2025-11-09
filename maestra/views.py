from rest_framework import viewsets
from .models import Maestra
from rest_framework import serializers

class MaestraSerializer(serializers.ModelSerializer):
    class Meta:
        model = Maestra
        fields = ['id', 'nombre', 'valor', 'tipo_maestra']

class MaestraViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Maestra.objects.filter(activo=1)
    serializer_class = MaestraSerializer