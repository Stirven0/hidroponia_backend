from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from .models import Sensor, LecturaSensor
from .serializers import SensorSerializer, LecturaSensorSerializer

class SensorViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Sensor.objects.filter(activo=1)
    serializer_class = SensorSerializer

    @action(detail=True, methods=['post'])
    def agregar_lectura(self, request, pk=None):
        sensor = self.get_object()
        valor = request.data.get('valor')
        if valor is None:
            return Response({'error': 'Falta el valor'}, status=status.HTTP_400_BAD_REQUEST)
        lectura = LecturaSensor.objects.create(sensor=sensor, valor=valor, fecha_hora=request.data.get('fecha_hora'))
        serializer = LecturaSensorSerializer(lectura)
        return Response(serializer.data, status=status.HTTP_201_CREATED)