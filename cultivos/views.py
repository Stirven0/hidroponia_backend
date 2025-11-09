from rest_framework import viewsets
from .models import Cultivo
from .serializers import CultivoSerializer

class CultivoViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Cultivo.objects.filter(activo=1)
    serializer_class = CultivoSerializer