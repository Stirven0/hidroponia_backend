from django.db import models

class Maestra(models.Model):
    nombre = models.CharField(max_length=100)
    valor = models.CharField(max_length=100, blank=True, null=True)
    tipo_maestra = models.CharField(max_length=50)
    padre = models.ForeignKey('self', on_delete=models.DO_NOTHING, blank=True, null=True)
    orden = models.IntegerField(blank=True, null=True)
    activo = models.IntegerField(default=1, blank=True, null=True)
    descripcion = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True, blank=True, null=True)
    updated_at = models.DateTimeField(auto_now=True, blank=True, null=True)

    class Meta:
        db_table = 'Maestra'
        unique_together = (('nombre', 'tipo_maestra'),)
        managed = False
        app_label = 'maestra'

class ParametroCultivo(models.Model):
    tipo_cultivo_maestra = models.ForeignKey(Maestra, on_delete=models.DO_NOTHING, related_name='parametros_tipo')
    parametro = models.CharField(max_length=45)
    minimo = models.DecimalField(max_digits=8, decimal_places=3, blank=True, null=True)
    maximo = models.DecimalField(max_digits=8, decimal_places=3, blank=True, null=True)
    unidad_maestra = models.ForeignKey(Maestra, on_delete=models.DO_NOTHING, blank=True, null=True, related_name='parametros_unidad')
    descripcion = models.TextField(blank=True, null=True)
    activo = models.IntegerField(default=1, blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True, blank=True, null=True)
    updated_at = models.DateTimeField(auto_now=True, blank=True, null=True)

    class Meta:
        db_table = 'Parametro_Cultivo'
        unique_together = (('tipo_cultivo_maestra', 'parametro'),)
        managed = False
        app_label = 'parametro_cultivo'