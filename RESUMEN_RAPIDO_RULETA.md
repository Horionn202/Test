# 🎰 RESUMEN RÁPIDO - Sistema de Ruleta

## ✅ YA HICE TODO EL CÓDIGO

He creado y configurado estos archivos:

### 📦 Archivos Nuevos
1. `src/shared/SpinConfig.lua` - Configuración de recompensas
2. `src/server/MainGame/SpinHandler.server.lua` - Lógica del servidor
3. `src/client/SpinWheel.client.lua` - UI y animaciones
4. `src/replicated/SpinEvents.lua` - RemoteEvents
5. `src/server/InitializeEvents.server.lua` - Inicializador

### 📝 Archivos Modificados
1. `src/server/MainGame/DataStore.server.lua` - Ahora guarda spins

---

## 🎯 LO ÚNICO QUE NECESITAS HACER

### **PASO 1: Copiar la UI del proyecto Ruelta**

1. Abre `Downloads/Ruelta.rbxlx` en Roblox Studio
2. En `StarterGui`, encuentra el **ScreenGui** llamado **"SPIN"**
3. Cópialo TODO (Ctrl+C)
4. Abre TU juego en Roblox Studio
5. Pégalo en `StarterGui` (Ctrl+V)
6. **NO cambies el nombre**, déjalo como **"SPIN"**

### **PASO 2: Borrar el script de giro original**

El ScreenGui incluye scripts. Necesitas:
1. Ir a **StarterGui → SPIN → Spin** (el Frame)
2. **BORRAR** el LocalScript llamado **"SpinScript"** que está dentro
3. **DEJAR** el LocalScript de abrir/cerrar que está al nivel del ScreenGui

**Mis scripts ya usan los nombres correctos del proyecto original:**
- `SPIN` (ScreenGui)
- `SpinOpen` - Botón para abrir
- `Spin` (Frame) - Ventana principal
  - `SpinButton` - Botón de girar
  - `Spin` (Frame interno) - La ruleta que gira
  - `RewardName` - Texto de recompensa
  - `SpinTimer` - Timer y contador

### **PASO 3: Configurar las mascotas**

En `src/shared/SpinConfig.lua`, cambia el nombre de las mascotas por las de TU juego:

```lua
["Reward8"] = {
    Type = "Pet",
    PetName = "Golden Dragon",  -- ⚠️ Cambia esto por el nombre de TU mascota
    ...
},
```

### **PASO 4: (Opcional) Ajustar tiempos para testing**

En `src/shared/SpinConfig.lua`:

```lua
SpinConfig.SpinCooldown = 60  -- 1 minuto (en vez de 30)
```

---

## 🎮 CÓMO FUNCIONA

**El jugador:**
1. Recibe 1 spin gratis al entrar
2. Cada 30 minutos recibe otro spin automáticamente
3. Clickea el botón para abrir la ruleta
4. Clickea "SPIN" para girar
5. La ruleta gira y para en una recompensa
6. Recibe: Money, Pet o Spins extra

**Todo se guarda automáticamente** en el DataStore.

---

## 🎁 RECOMPENSAS CONFIGURADAS

### Money (Dinero)
- $100 (30% probabilidad)
- $250 (25%)
- $500 (12%)
- $1,000 (8%)
- $2,500 (3%)
- $10,000 (1% - MEGA JACKPOT)

### Pets (Mascotas)
- Golden Dragon (1% - JACKPOT)
  - **⚠️ Cambia el nombre por tu mascota rara**

### Spins Extra
- +1 Spin (15%)
- +3 Spins (5%)

**Total de probabilidades:** 100%

---

## 🛠️ PERSONALIZACIÓN

Para agregar más recompensas, edita `SpinConfig.lua`:

```lua
["Reward11"] = {
    Type = "Money",      -- o "Pet" o "Spins"
    Amount = 5000,       -- Cantidad
    PetName = "...",     -- Solo si Type = "Pet"
    TextColor = Color3.fromRGB(255, 0, 0),
    Rarity = 5,          -- Probabilidad (5%)
    Name = "$5,000",     -- Nombre mostrado
},
```

---

## 🐛 Problemas Comunes

**"No se encontró SpinUI"**
→ Verifica que el ScreenGui se llama "SpinUI" en StarterGui

**"No da mascotas"**
→ El `PetName` debe ser exactamente igual al de tu sistema de pets

**"Los spins no se guardan"**
→ Ya está configurado, verifica errores en Output

---

## ✅ Eso es todo!

Lee `SISTEMA_RULETA_INSTRUCCIONES.md` para detalles completos.

**¡Tu sistema de ruleta está listo! 🎉**
