from rest_framework.routers import DefaultRouter
from .views import CultivoViewSet

router = DefaultRouter()
router.register(r'', CultivoViewSet, basename='cultivos')

urlpatterns = router.urls