from django.db import models

class AlertaSistema(models.Model):
    cultivo = models.ForeignKey('cultivos.Cultivo', on_delete=models.DO_NOTHING, blank=True, null=True)
    tipo_alerta = models.CharField(max_length=50)
    mensaje = models.TextField()
    severidad = models.CharField(max_length=5)
    activa = models.IntegerField(default=1, blank=True, null=True)
    fecha_creacion = models.DateTimeField(auto_now_add=True, blank=True, null=True)
    fecha_resolucion = models.DateTimeField(blank=True, null=True)
    observaciones = models.TextField(blank=True, null=True)

    class Meta:
        db_table = 'Alerta_Sistema'
        managed = False
        app_label = 'alerta_sistema'