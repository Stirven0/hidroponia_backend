from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from .models import Actuador
from .serializers import ActuadorSerializer

class ActuadorViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Actuador.objects.filter(activo=1)
    serializer_class = ActuadorSerializer

    @action(detail=True, methods=['post'])
    def activar(self, request, pk=None):
        actuador = self.get_object()
        # Aquí puedes agregar lógica para cambiar estado o enviar señal
        return Response({'mensaje': f'Actuador {actuador.nombre} activado'}, status=status.HTTP_200_OK)