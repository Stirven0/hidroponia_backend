from rest_framework.routers import DefaultRouter
from .views import SolucionNutritivaViewSet

router = DefaultRouter()
router.register(r'', SolucionNutritivaViewSet, basename='soluciones')

urlpatterns = router.urls