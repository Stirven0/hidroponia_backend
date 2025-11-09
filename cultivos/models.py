from django.db import models

class Cultivo(models.Model):
    nombre = models.CharField(max_length=50)
    tiempo_cosecha_dias = models.IntegerField()
    estado_maestra = models.ForeignKey('maestra.Maestra', on_delete=models.DO_NOTHING, related_name='cultivos_estado')
    tipo_cultivo_maestra = models.ForeignKey('maestra.Maestra', on_delete=models.DO_NOTHING, related_name='cultivos_tipo')
    fecha_inicio = models.DateField()
    fecha_estimada_cosecha = models.DateField(blank=True, null=True)
    descripcion = models.TextField(blank=True, null=True)
    activo = models.IntegerField(default=1, blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True, blank=True, null=True)
    updated_at = models.DateTimeField(auto_now=True, blank=True, null=True)

    class Meta:
        db_table = 'Cultivo'
        managed = False
        app_label = 'cultivos'