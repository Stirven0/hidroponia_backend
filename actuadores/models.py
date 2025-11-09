from django.db import models

class Actuador(models.Model):
    tipo_maestra = models.ForeignKey('maestra.Maestra', on_delete=models.DO_NOTHING, related_name='actuadores_tipo')
    nombre = models.CharField(max_length=50)
    descripcion = models.CharField(max_length=255, blank=True, null=True)
    activo = models.IntegerField(default=1, blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True, blank=True, null=True)
    updated_at = models.DateTimeField(auto_now=True, blank=True, null=True)

    class Meta:
        db_table = 'Actuador'
        managed = False
        app_label = 'actuador'