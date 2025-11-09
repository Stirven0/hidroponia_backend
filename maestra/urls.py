from rest_framework.routers import DefaultRouter
from .views import MaestraViewSet

router = DefaultRouter()
router.register(r'', MaestraViewSet, basename='maestra')

urlpatterns = router.urls