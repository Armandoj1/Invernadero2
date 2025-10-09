# AgriSense Pro

Sistema de control de temperatura para invernaderos utilizando lógica difusa e inteligencia artificial. Monitoreo en tiempo real con simulación de sensores para optimizar el crecimiento de cultivos.

## Características

- 🔐 Autenticación con Firebase (Login/Registro)
- 🏗️ Arquitectura MVC (Modelo-Vista-Controlador)
- 🎨 Diseño moderno y responsivo
- 📱 Soporte multiplataforma (Android, iOS, Web, Windows)
- 🔄 Gestión de estado con GetX
- 💾 Persistencia local con SharedPreferences

## Configuración

### 1. Instalar dependencias

```bash
flutter pub get
```

### 2. Configurar Firebase

#### Opción A: Usar FlutterFire CLI (Recomendado)

1. Instalar FlutterFire CLI:
```bash
dart pub global activate flutterfire_cli
```

2. Configurar Firebase para tu proyecto:
```bash
flutterfire configure
```

Esto generará automáticamente el archivo `lib/firebase_options.dart` con tus credenciales.

#### Opción B: Configuración Manual

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Crea un nuevo proyecto o selecciona uno existente
3. Agrega tu aplicación (Android/iOS/Web)
4. Descarga los archivos de configuración:
   - **Android**: `google-services.json` → `android/app/`
   - **iOS**: `GoogleService-Info.plist` → `ios/Runner/`
   - **Web**: Copia la configuración en `lib/firebase_options.dart`

5. Habilita **Authentication** en Firebase Console:
   - Ve a Authentication > Sign-in method
   - Habilita "Email/Password"

### 3. Ejecutar la aplicación

```bash
flutter run
```

## Estructura del Proyecto

```
lib/
├── controllers/
│   └── auth_controller.dart       # Controlador de autenticación
├── models/
│   └── user_model.dart            # Modelo de usuario
├── views/
│   ├── auth/
│   │   ├── login_view.dart        # Pantalla de login
│   │   └── register_view.dart     # Pantalla de registro
│   └── home/
│       └── home_view.dart         # Pantalla principal
├── firebase_options.dart          # Configuración de Firebase
└── main.dart                      # Punto de entrada
```

## Arquitectura MVC

### Modelo (Model)
- `UserModel`: Representa los datos del usuario

### Vista (View)
- `LoginView`: Interfaz de inicio de sesión
- `RegisterView`: Interfaz de registro
- `HomeView`: Pantalla principal después del login

### Controlador (Controller)
- `AuthController`: Maneja la lógica de autenticación
  - Login
  - Registro
  - Cierre de sesión
  - Recuperación de contraseña
  - Persistencia de sesión

## Funcionalidades Implementadas

### ✅ Autenticación
- [x] Inicio de sesión con email/contraseña
- [x] Registro de nuevos usuarios
- [x] Recuperación de contraseña
- [x] Recordar sesión
- [x] Cierre de sesión
- [x] Validación de formularios
- [x] Manejo de errores en español

### 🚧 Próximamente
- [ ] Dashboard de monitoreo
- [ ] Gráficas de temperatura en tiempo real
- [ ] Configuración de sensores
- [ ] Sistema de notificaciones
- [ ] Control de invernaderos
- [ ] Lógica difusa e IA

## Tecnologías Utilizadas

- **Flutter**: Framework de UI
- **Firebase Auth**: Autenticación de usuarios
- **GetX**: Gestión de estado y navegación
- **SharedPreferences**: Almacenamiento local

## Licencia

© 2024 AgriSense Pro. Todos los derechos reservados.
