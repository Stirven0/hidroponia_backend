
# 🌱 Hidroponia Backend  
Backend Django + Django REST Framework para gestión automatizada de cultivos hidropónicos.

---

## 📦 Stack
| Tecnología | Versión |
|------------|---------|
| Python | 3.11+ |
| Django | 5.2.8 |
| Django REST Framework | 3.14.0 |
| MySQL | 8.0 |
| mysqlclient | 2.2.0 |
| python-decouple | 3.8 |

---

## 🚀 Instalación local (Windows / Linux / macOS)

1. **Clonar**
   ```bash
   git clone https://github.com/Stirven0/hidroponia_backend.git 
   cd hidroponia_backend
   ```

2. **Entorno virtual**
   ```bash
   python -m venv .venv
   # Windows
   .\.venv\Scripts\activate
   # Linux / macOS
   source .venv/bin/activate
   ```

3. **Dependencias**
   ```bash
   pip install -r requirements.txt
   ```

4. **Variables de entorno**  
   Crear archivo `.env` en la raíz:
   ```
   DB_NAME=proyecto_hidroponico
   DB_USER=root
   DB_PASSWORD=1234
   DB_HOST=localhost
   DB_PORT=3307
   ```

5. **Levantar**
   ```bash
   python manage.py runserver
   ```
   Admin: http://127.0.0.1:8000/admin   
   API: http://127.0.0.1:8000/api/ 

---

## 📡 Endpoints principales (REST)

| Método | Endpoint | Uso |
|--------|----------|-----|
| GET | `/api/cultivos/` | Listar cultivos activos |
| GET | `/api/sensores/` | Listar sensores |
| POST | `/api/sensores/<id>/agregar_lectura/` | Enviar lectura |
| GET | `/api/actuadores/` | Listar actuadores |
| POST | `/api/actuadores/<id>/activar/` | Activar actuador |
| GET | `/api/alertas/` | Alertas activas |
| GET | `/api/soluciones/` | Inventario de soluciones |

---

## 🗃️ Base de datos
Esquema `proyecto_hidroponico` en MySQL 8.  
Tablas maestras auto-referenciadas + triggers + procedimientos.  
**No crear migraciones**; modelos usan `managed = False`.

---

## 🔐 Usuario admin por defecto
Crear super-user:
```bash
python manage.py createsuperuser
```

---

## 🐳 Docker (próximo paso)
Se incluirá `docker-compose.yml` para levantar:
- MySQL 8
- Django + DRF
- phpMyAdmin (opcional)