from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from .models import SolucionNutritiva
from .serializers import SolucionNutritivaSerializer

class SolucionNutritivaViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = SolucionNutritiva.objects.filter(activo=1)
    serializer_class = SolucionNutritivaSerializer

    @action(detail=True, methods=['post'])
    def decrementar(self, request, pk=None):
        """Restar litros tras una aplicación."""
        solucion = self.get_object()
        cantidad = request.data.get('cantidad')
        if cantidad is None or float(cantidad) <= 0:
            return Response({'error': 'Cantidad inválida'}, status=status.HTTP_400_BAD_REQUEST)
        if solucion.litros_disponibles < float(cantidad):
            return Response({'error': 'Litros insuficientes'}, status=status.HTTP_400_BAD_REQUEST)
        solucion.litros_disponibles -= float(cantidad)
        solucion.save(update_fields=['litros_disponibles'])
        return Response({'litros_restantes': solucion.litros_disponibles})