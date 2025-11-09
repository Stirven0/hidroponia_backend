from rest_framework.routers import DefaultRouter
from .views import AlertaSistemaViewSet

router = DefaultRouter()
router.register(r'', AlertaSistemaViewSet, basename='alertas')

urlpatterns = router.urls