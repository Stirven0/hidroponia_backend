from django.db import models

class SolucionNutritiva(models.Model):
    tipo_maestra = models.ForeignKey('maestra.Maestra', on_delete=models.DO_NOTHING)
    nombre = models.CharField(max_length=50)
    litros_disponibles = models.DecimalField(max_digits=10, decimal_places=2)
    ph_optimo = models.DecimalField(max_digits=3, decimal_places=1, blank=True, null=True)
    conductividad_optima = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)
    descripcion = models.TextField(blank=True, null=True)
    activo = models.IntegerField(default=1, blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True, blank=True, null=True)
    updated_at = models.DateTimeField(auto_now=True, blank=True, null=True)

    class Meta:
        db_table = 'Solucion_Nutritiva'
        managed = False
        app_label = 'soluciones'   # o la app que corresponda