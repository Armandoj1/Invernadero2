# Configuración de Firebase para AgriSense Pro

## Pasos Rápidos

### 1. Crear proyecto en Firebase

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Haz clic en "Agregar proyecto"
3. Nombra tu proyecto: **agrisense-pro**
4. Desactiva Google Analytics (opcional)
5. Haz clic en "Crear proyecto"

### 2. Configurar con FlutterFire CLI (Recomendado)

```bash
# Instalar FlutterFire CLI
dart pub global activate flutterfire_cli

# Configurar Firebase automáticamente
flutterfire configure
```

Selecciona el proyecto **agrisense-pro** y las plataformas que desees (Android, iOS, Web, Windows).

### 3. Habilitar Authentication

1. En Firebase Console, ve a **Authentication**
2. Haz clic en **"Empezar"**
3. Ve a la pestaña **"Sign-in method"**
4. Habilita **"Correo electrónico/Contraseña"**
5. Guarda los cambios

### 4. Instalar dependencias

```bash
flutter pub get
```

### 5. Ejecutar la aplicación

```bash
flutter run
```

## Configuración Manual (Alternativa)

### Para Web

1. En Firebase Console, ve a **Configuración del proyecto** (icono de engranaje)
2. En "Tus apps", haz clic en el icono de **Web** (</>)
3. Registra la app con el nombre: **agrisense-pro-web**
4. Copia la configuración de Firebase
5. Pega los valores en `lib/firebase_options.dart`:

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'TU_API_KEY',
  appId: 'TU_APP_ID',
  messagingSenderId: 'TU_MESSAGING_SENDER_ID',
  projectId: 'TU_PROJECT_ID',
  authDomain: 'TU_AUTH_DOMAIN',
  storageBucket: 'TU_STORAGE_BUCKET',
);
```

### Para Android

1. En Firebase Console, agrega una app Android
2. Nombre del paquete: `com.example.agrisense_pro` (o el que tengas en `android/app/build.gradle`)
3. Descarga `google-services.json`
4. Colócalo en `android/app/google-services.json`

### Para iOS

1. En Firebase Console, agrega una app iOS
2. ID del paquete: el que está en `ios/Runner.xcodeproj/project.pbxproj`
3. Descarga `GoogleService-Info.plist`
4. Colócalo en `ios/Runner/GoogleService-Info.plist`

## Solución de Problemas

### Error: "No Firebase App '[DEFAULT]' has been created"

Asegúrate de que:
- Has ejecutado `flutterfire configure`
- El archivo `lib/firebase_options.dart` existe y tiene la configuración correcta
- Has ejecutado `flutter pub get`

### Error de autenticación

Verifica que:
- Authentication esté habilitado en Firebase Console
- El método "Email/Password" esté activo en Sign-in methods

### Error en build Android

Agrega en `android/app/build.gradle`:

```gradle
dependencies {
    // ... otras dependencias
    implementation platform('com.google.firebase:firebase-bom:32.7.0')
}
```

Y en `android/build.gradle`:

```gradle
buildscript {
    dependencies {
        // ... otras dependencias
        classpath 'com.google.gms:google-services:4.4.0'
    }
}
```

Al final de `android/app/build.gradle`:

```gradle
apply plugin: 'com.google.gms.google-services'
```

## Usuarios de Prueba

Una vez configurado, puedes crear usuarios de prueba desde:

1. **La aplicación**: Usando el botón "Regístrate aquí"
2. **Firebase Console**: Authentication > Users > Add user

## Próximos Pasos

Después de configurar Firebase:

1. ✅ Prueba el login
2. ✅ Prueba el registro
3. ✅ Prueba recuperar contraseña
4. 🚀 Comienza a construir el dashboard de monitoreo
