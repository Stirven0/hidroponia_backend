from rest_framework.routers import DefaultRouter
from .views import ActuadorViewSet

router = DefaultRouter()
router.register(r'', ActuadorViewSet, basename='actuadores')

urlpatterns = router.urls