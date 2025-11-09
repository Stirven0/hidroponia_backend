from rest_framework import viewsets
from .models import AlertaSistema
from .serializers import AlertaSistemaSerializer

class AlertaSistemaViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = AlertaSistema.objects.filter(activa=1).order_by('-fecha_creacion')
    serializer_class = AlertaSistemaSerializer