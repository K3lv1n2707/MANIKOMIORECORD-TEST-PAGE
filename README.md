# Web productora — Eventos · Booking · Logística

Sitio web con panel de administrador. Los dueños pueden agregar eventos, artistas,
fotos y videos de la galería y noticias sin tocar código.

## Qué incluye

**Web pública**
- Pantalla de carga con “Entrar con sonido” / “Entrar sin sonido”.
- Portada con carrusel (Eventos, Booking, Logística), elementos flotantes y efecto vidrio.
- Próximos eventos con fecha, flyer y botón “Comprar entradas” (lleva al link de cada evento).
- Booking: artistas nacionales e internacionales, muestra de audio al pasar el mouse
  (en celular, con el botón de play), perfil de cada artista y botón “Contratar” a WhatsApp.
- Logística: personal de carga, seguridad, vallado, sonido, permisos, sillas y más.
- Galería de fotos y videos (archivos subidos o links de YouTube) con visor ampliado.
- Noticias, sección Nosotros y contacto por WhatsApp.
- Páginas: `/`, `/eventos`, `/eventos/<evento>`, `/artistas/<artista>`, `/galeria`, `/noticias`, `/noticias/<noticia>`.

**Panel de administrador** (`/admin`)
- Login con usuario y contraseña. La contraseña se guarda cifrada (bcrypt), nunca en texto plano.
- Bloqueo de 15 minutos después de 5 intentos fallidos.
- Eventos, Artistas (foto + audio), Galería (subida múltiple), Noticias, Ajustes del sitio
  (logo, WhatsApp, redes, textos de Nosotros, fotos de la portada) y cambio de contraseña.

## Tecnología

- Node.js 22 + Express + plantillas EJS.
- Base de datos SQLite (viene dentro de Node, no hay que instalar otro servicio).
- Todo lo que sube el cliente (base de datos y archivos) vive en **una sola carpeta**: `/app/data`.
  **Esa carpeta debe ser un volumen** para que no se borre al actualizar la web.

Límites de subida: fotos 10 MB, audios 15 MB, videos 100 MB. Para videos largos, usar links de YouTube.

---

## Publicar en Hostinger con Easypanel

> Los nombres de los botones de Easypanel pueden variar un poco entre versiones.
> Si algo no coincide, guíate por la idea de cada paso.

### 1. Subir el código a GitHub
1. Crea una cuenta en github.com (si no tienes) y un repositorio **privado**, por ejemplo `web-productora`.
2. Sube **todo el contenido de esta carpeta** al repositorio. La forma más fácil:
   en el repositorio vacío, “uploading an existing file” y arrastra los archivos y carpetas
   (`src`, `views`, `public`, `Dockerfile`, `package.json`, `package-lock.json`, etc.).
   No hace falta subir `node_modules` ni `data`.

### 2. Crear la app en Easypanel
1. En hPanel → tu VPS → **Panel de gestión** (abre Easypanel).
2. Crea un **Project** (ej. `productora`) y dentro un servicio tipo **App**.
3. En **Source**, elige **GitHub**, conecta tu cuenta y selecciona el repositorio y la rama `main`.
4. En **Build**, elige **Dockerfile** (el archivo ya está en la raíz).

### 3. Variables de entorno (pestaña Environment)
```
ADMIN_USER=admin
ADMIN_PASSWORD=una-contraseña-segura
SESSION_SECRET=una-frase-larga-y-aleatoria-de-al-menos-32-caracteres
```
- `ADMIN_USER` / `ADMIN_PASSWORD` crean el primer administrador **solo la primera vez**.
  Después, la contraseña se cambia desde el panel (Mi cuenta).
- Para `SESSION_SECRET` puedes usar cualquier texto largo al azar.

### 4. Volumen para los datos (pestaña Mounts / Volumes) — IMPORTANTE
Agrega un **Volume** con:
- Nombre: `data`
- Ruta de montaje (Mount path): `/app/data`

Sin esto, cada vez que actualices la web se perderían los eventos, artistas y fotos.

### 5. Dominio (pestaña Domains)
1. Agrega tu dominio (ej. `tudominio.com`) y también `www.tudominio.com`.
2. Puerto del contenedor: **3000**. Activa HTTPS (Easypanel genera el certificado SSL).
3. En el DNS del dominio (en Hostinger: **Administrador de DNS**), crea o edita los registros **A**:
   - `@`   → `72.60.118.19`
   - `www` → `72.60.118.19`
   (Usa la IP de tu VPS si cambia.) El DNS puede tardar de minutos a unas horas en propagarse.

### 6. Deploy
Pulsa **Deploy**. Cuando termine, entra a `https://tudominio.com/admin` con el usuario y la contraseña del paso 3.

### 7. Primeros pasos en el panel
1. **Ajustes del sitio**: número de WhatsApp (con código de país, ej. `593991234567`), logo, redes y textos de Nosotros.
2. **Artistas**: foto, biografía y audio de muestra (MP3 de 20–40 s).
3. **Eventos**: flyer, fecha y el link de compra de entradas. Marca uno como “Destacado”.
4. **Galería** y **Noticias**.

## Actualizar la web
Sube los cambios al repositorio de GitHub y pulsa **Deploy** en Easypanel.
Los datos del cliente no se tocan porque viven en el volumen `/app/data`.

## Copias de seguridad
Todo está en el volumen `/app/data` (archivo `db.sqlite` + carpeta `uploads`).
Además de las copias del VPS en Hostinger, conviene descargar esa carpeta de vez en cuando.

## Recuperar el acceso si se olvida la contraseña
Desde la consola del contenedor en Easypanel:
```
node --disable-warning=ExperimentalWarning -e "const b=require('bcryptjs');const {db}=require('./src/db');db.prepare('UPDATE admins SET password_hash=? WHERE username=?').run(b.hashSync('NuevaClave123',12),'admin');console.log('listo')"
```
(Cambia `NuevaClave123` y `admin` por los valores que quieras.)

## Probar en tu computadora (opcional)
Necesitas Node.js 22 o superior.
```
npm install
# Windows PowerShell:
$env:ADMIN_USER="admin"; $env:ADMIN_PASSWORD="Prueba12345"; npm run dev
# Mac / Linux:
ADMIN_USER=admin ADMIN_PASSWORD=Prueba12345 npm run dev
```
Abre http://localhost:3000 y http://localhost:3000/admin
