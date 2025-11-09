from rest_framework.routers import DefaultRouter
from .views import SensorViewSet

router = DefaultRouter()
router.register(r'', SensorViewSet, basename='sensores')

urlpatterns = router.urls