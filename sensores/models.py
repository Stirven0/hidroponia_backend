from django.db import models

class Sensor(models.Model):
    tipo_maestra = models.ForeignKey('maestra.Maestra', on_delete=models.DO_NOTHING, related_name='sensores_tipo')
    nombre = models.CharField(max_length=50)
    unidad_maestra = models.ForeignKey('maestra.Maestra', on_delete=models.DO_NOTHING, blank=True, null=True, related_name='sensores_unidad')
    descripcion = models.CharField(max_length=255, blank=True, null=True)
    activo = models.IntegerField(default=1, blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True, blank=True, null=True)
    updated_at = models.DateTimeField(auto_now=True, blank=True, null=True)

    class Meta:
        db_table = 'Sensor'
        managed = False
        app_label = 'sensor'

class LecturaSensor(models.Model):
    sensor = models.ForeignKey(Sensor, on_delete=models.DO_NOTHING)
    fecha_hora = models.DateTimeField()
    valor = models.DecimalField(max_digits=12, decimal_places=4)
    created_at = models.DateTimeField(auto_now_add=True, blank=True, null=True)

    class Meta:
        db_table = 'Lectura_Sensor'
        managed = False
        app_label = 'lectura_sensor'