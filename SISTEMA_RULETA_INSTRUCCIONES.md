# 🎰 SISTEMA DE RULETA - INSTRUCCIONES COMPLETAS

## ✅ ARCHIVOS YA CREADOS (listos para usar)

He creado los siguientes archivos en tu proyecto:

### 📂 Servidor
- `src/server/MainGame/SpinHandler.server.lua` - Lógica del servidor
- `src/server/MainGame/DataStore.server.lua` - **ACTUALIZADO** para guardar spins

### 📂 Cliente
- `src/client/SpinWheel.client.lua` - UI y animaciones

### 📂 Shared/Replicated
- `src/shared/SpinConfig.lua` - Configuración de recompensas
- `src/replicated/SpinEvents.lua` - RemoteEvents

---

## 🎨 LO QUE NECESITAS COPIAR DEL PROYECTO DE LA RULETA

Abre el archivo `Ruelta.rbxlx` que está en tu carpeta Downloads y copia estos elementos:

### 1. **UI de la Ruleta (ScreenGui)**

**Ubicación en Ruelta.rbxlx:** `StarterGui > ScreenGui`

**Qué copiar:**
- Todo el **ScreenGui** que contiene la ruleta
  - Incluye: El frame de la ruleta giratoria
  - El botón para abrir la ruleta
  - El botón de spin
  - Todos los ImageLabels de la ruleta

**Dónde pegarlo en tu juego:**
- `StarterGui` (en Roblox Studio)

**Cómo pegarlo:**
1. Abre `Ruelta.rbxlx` en Roblox Studio
2. Ve a `StarterGui`
3. Selecciona todo el **ScreenGui** de la ruleta
4. Click derecho → **Copy**
5. Abre TU juego en Roblox Studio
6. Ve a `StarterGui`
7. Click derecho → **Paste**
8. **MUY IMPORTANTE:** Renombra el ScreenGui a **"SpinUI"**

---

### 2. **Estructura de la UI (nombres importantes)**

El `SpinUI` debe tener esta estructura (verifica los nombres):

```
SpinUI (ScreenGui)
├── OpenButton (TextButton o ImageButton) - Botón para abrir la ruleta
└── MainFrame (Frame) - Frame principal que contiene todo
    ├── CloseButton (TextButton) - Botón para cerrar
    ├── SpinButton (TextButton/ImageButton) - Botón de "SPIN"
    ├── WheelFrame (Frame) - Contenedor de la ruleta
    │   ├── Wheel (ImageLabel) - La ruleta que gira
    │   └── Pointer (ImageLabel) - La flecha/indicador
    ├── RewardLabel (TextLabel) - Muestra "You won: ..."
    ├── SpinCountLabel (TextLabel) - Muestra "Spins: X"
    └── TimerLabel (TextLabel) - Muestra "Next spin in: 00:00"
```

**Si los nombres no coinciden,** tienes 2 opciones:
1. Renombrar los elementos en Studio para que coincidan con los nombres de arriba
2. O modificar `SpinWheel.client.lua` líneas 25-35 con los nombres correctos

---

### 3. **Assets de Imágenes (opcional pero recomendado)**

Si quieres que la ruleta se vea igual, necesitas estas imágenes:

**Imágenes en Ruelta.rbxlx:**
- `rbxassetid://16536971409` - Imagen de la ruleta
- `rbxassetid://16537007919` - Imagen de fondo/decoración

Puedes usar estas IDs directamente o subir tus propias imágenes.

---

## ⚙️ CONFIGURACIÓN ADICIONAL

### 1. **Inicializar RemoteEvents**

Agrega este script en `ServerScriptService`:

```lua
-- En ServerScriptService, crear un script llamado "InitializeEvents.server.lua"
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Ejecutar el módulo de eventos
require(ReplicatedStorage.SpinEvents)

print("Eventos de ruleta inicializados")
```

O simplemente asegúrate de que `SpinEvents.lua` se ejecute al inicio del juego.

---

### 2. **Configurar las Recompensas**

Edita `src/shared/SpinConfig.lua` para personalizar:

#### **Money (Dinero):**
```lua
["Reward1"] = {
    Type = "Money",
    Amount = 100,              -- Cantidad a dar
    TextColor = Color3.fromRGB(115, 255, 131),
    Rarity = 30,               -- Más alto = más común
    Name = "$100",
},
```

#### **Pets (Mascotas):**
```lua
["Reward8"] = {
    Type = "Pet",
    PetName = "Golden Dragon",  -- ⚠️ DEBE ser el nombre EXACTO de tu mascota
    TextColor = Color3.fromRGB(255, 215, 0),
    Rarity = 1,                 -- Muy raro (1%)
    Name = "Golden Dragon",
    IsJackpot = true,
},
```

**⚠️ IMPORTANTE:** El `PetName` debe coincidir exactamente con el nombre de las mascotas en tu sistema de pets.

#### **Spins Extra:**
```lua
["Reward3"] = {
    Type = "Spins",
    Amount = 1,                 -- Cuántos spins adicionales
    TextColor = Color3.fromRGB(85, 255, 255),
    Rarity = 15,
    Name = "+1 Spin",
},
```

---

### 3. **Ajustar Tiempos**

En `src/shared/SpinConfig.lua`:

```lua
-- Tiempo entre spins gratis (en segundos)
SpinConfig.SpinCooldown = 60 * 30  -- 30 minutos
-- Para testing rápido:
-- SpinConfig.SpinCooldown = 60  -- 1 minuto

-- Duración de la animación
SpinConfig.SpinDuration = 5  -- 5 segundos
```

---

## 🎮 CÓMO FUNCIONA

### **Spins Gratis:**
- Los jugadores reciben 1 spin gratis al iniciar
- Cada 30 minutos (configurable) reciben otro spin gratis automáticamente
- Los spins se acumulan (pueden tener múltiples)

### **Recompensas:**
- **Money:** Se suma al `leaderstats.Money` del jugador
- **Pets:** Se agrega a la carpeta `Pets` del jugador
  - Si ya tienen la mascota, reciben $5,000 de compensación
- **Spins:** Se suman a sus spins disponibles

### **Sistema de Rareza:**
```
Rarity = 30  →  30% de probabilidad
Rarity = 15  →  15% de probabilidad
Rarity = 1   →  1% de probabilidad (JACKPOT)
```

---

## 🐛 SOLUCIÓN DE PROBLEMAS

### **Error: "No se encontró SpinUI"**
- Verifica que copiaste el ScreenGui a `StarterGui`
- Verifica que lo renombraste a **"SpinUI"**

### **Error: "Eventos no están listos"**
- Crea el script `InitializeEvents.server.lua` en ServerScriptService
- O asegúrate de que `SpinEvents.lua` se ejecute

### **La ruleta no gira:**
- Verifica que el elemento se llama **"Wheel"** (dentro de WheelFrame)
- Verifica que es un ImageLabel con la propiedad `Rotation`

### **No da mascotas:**
- Verifica que el `PetName` coincide exactamente con tu sistema
- Verifica que existe la carpeta `Pets` en el jugador

### **Los spins no se guardan:**
- El DataStore ya está configurado, debería guardar automáticamente
- Verifica que no hay errores en la consola

---

## 📝 TESTING

1. **Modo de prueba rápida:**
   - En `SpinConfig.lua` cambia: `SpinConfig.SpinCooldown = 10` (10 segundos)

2. **Darle spins manualmente (para testing):**
   ```lua
   -- En la consola del servidor
   game.Players.TuNombre.SpinStats.AvailableSpins.Value = 10
   ```

---

## 🎨 PERSONALIZACIÓN AVANZADA

### **Agregar más recompensas:**
Copia este formato en `SpinConfig.Rewards`:

```lua
["Reward10"] = {
    Type = "Money",  -- o "Pet" o "Spins"
    Amount = 1000,
    TextColor = Color3.fromRGB(255, 0, 0),
    Rarity = 10,
    Name = "Nueva Recompensa",
},
```

### **Cambiar colores de la UI:**
Edita en `SpinWheel.client.lua` línea 90+

### **Sonidos (opcional):**
Agrega sonidos en la animación de spin (línea 150+ en SpinWheel.client.lua)

---

## ✅ CHECKLIST FINAL

Antes de publicar, verifica:

- [ ] Copiaste el UI del proyecto Ruelta a StarterGui
- [ ] Renombraste el ScreenGui a "SpinUI"
- [ ] Verificaste que los nombres de los elementos coinciden
- [ ] Configuraste las recompensas en SpinConfig.lua
- [ ] Cambiaste los nombres de las mascotas a las de TU juego
- [ ] Ajustaste los tiempos (SpinCooldown)
- [ ] Creaste InitializeEvents.server.lua
- [ ] Testeaste que funciona correctamente

---

## 🚀 ¡LISTO!

El sistema de ruleta está completo. Los jugadores podrán:
- ✅ Girar la ruleta cada 30 minutos gratis
- ✅ Ganar dinero, mascotas raras y spins extra
- ✅ Ver sus spins disponibles y tiempo restante
- ✅ Todo se guarda automáticamente en el DataStore

Si tienes problemas, revisa la consola de Output en Roblox Studio para ver los errores.
