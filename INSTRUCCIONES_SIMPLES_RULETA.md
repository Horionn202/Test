# 🎰 INSTRUCCIONES SÚPER SIMPLES - Sistema de Ruleta

## ✅ YA HICE TODO EL CÓDIGO

Los scripts están listos y adaptados a los nombres del proyecto original.

---

## 🎯 LO ÚNICO QUE NECESITAS HACER

### **PASO 1: Copiar TODO el ScreenGui**

1. Abre **`Downloads/Ruelta.rbxlx`** en Roblox Studio
2. En el **Explorer**, ve a **StarterGui**
3. Busca el **ScreenGui** que se llama **"SPIN"**
4. **Selecciónalo TODO** (el ScreenGui completo con todo lo que tiene dentro)
5. Click derecho → **Copy** (Ctrl+C)
6. Abre **TU JUEGO** en Roblox Studio
7. Ve a **StarterGui**
8. Click derecho → **Paste** (Ctrl+V)

**⚠️ IMPORTANTE:** NO cambies ningún nombre. Déjalo todo como se llama: **"SPIN"**

---

### **PASO 2: Copiar SOLO el LocalScript de abrir/cerrar**

El ScreenGui que copiaste incluye varios LocalScripts. Necesitas **BORRAR el script de SpinScript** (el que hace girar) porque yo ya hice uno mejor.

1. En **StarterGui → SPIN**, verás varios LocalScripts
2. **BORRA** el LocalScript llamado **"SpinScript"** que está dentro del **Frame "Spin"**
   - Ese script es el del proyecto original que gira la ruleta
   - Mi script (`SpinWheel.client.lua`) ya hace eso mejor
3. **DEJA** el LocalScript que está al nivel del ScreenGui (el que abre/cierra la UI)

---

### **PASO 3: Configurar nombres de mascotas**

Abre **`src/shared/SpinConfig.lua`** y cambia los nombres de las mascotas:

```lua
["Reward8"] = {
    Type = "Pet",
    PetName = "Golden Dragon",  -- ⚠️ Cambia esto por el nombre EXACTO de tu mascota rara
    ...
},
```

**Nombres de mascotas configuradas actualmente:**
- `"Golden Dragon"` (Reward8)
- `"Rainbow Unicorn"` (en AvailablePets)
- `"Diamond Cat"` (en AvailablePets)

Cámbialos por los nombres exactos de TUS mascotas.

---

## 🎮 ESTRUCTURA DEL UI (Ya configurado en mis scripts)

El ScreenGui **"SPIN"** tiene:
- **SpinOpen** - Botón para abrir la ruleta (con "Rotated" dentro)
- **Spin** (Frame) - Ventana principal de la ruleta
  - **SpinButton** - Botón para girar
  - **Spin** (Frame interno) - La ruleta que gira
  - **RewardName** - Muestra las recompensas ganadas
  - **SpinTimer** - Muestra "Spin : X (Timer)"
  - **NotEnough** - Frame de error (cuando no hay spins)

**Mis scripts ya usan estos nombres exactos** del proyecto original.

---

## 🎁 RECOMPENSAS CONFIGURADAS

### 💰 Money (Dinero)
- $100 (30%)
- $250 (25%)
- $500 (12%)
- $1,000 (8%)
- $2,500 (3%)
- $10,000 (1% MEGA JACKPOT)

### 🐾 Pets (Mascotas)
- Golden Dragon (1% JACKPOT) ← **Cámbialo por tu mascota**

### 🎲 Spins Extra
- +1 Spin (15%)
- +3 Spins (5%)

---

## ⚙️ CÓMO FUNCIONA

1. **Spins gratis**: Cada 30 minutos los jugadores reciben 1 spin gratis
2. **Timer en UI**: El SpinTimer muestra "Spin : 2 (05:30)" = 2 spins disponibles, próximo en 5:30
3. **Girar**: Clickean SpinButton, la ruleta gira, ganan premio
4. **Todo se guarda**: Spins y tiempos en DataStore

---

## 🛠️ CONFIGURACIÓN OPCIONAL

### Para testing rápido:
En `src/shared/SpinConfig.lua`:
```lua
SpinConfig.SpinCooldown = 60  -- 1 minuto en vez de 30
```

### Para agregar más recompensas:
En `src/shared/SpinConfig.lua`:
```lua
["Reward10"] = {
    Type = "Money",  -- o "Pet" o "Spins"
    Amount = 5000,
    TextColor = Color3.fromRGB(255, 0, 0),
    Rarity = 5,  -- 5% probabilidad
    Name = "$5,000",
},
```

---

## ✅ CHECKLIST

- [ ] Copié el ScreenGui "SPIN" completo a mi StarterGui
- [ ] Borré el LocalScript "SpinScript" que estaba dentro del Frame "Spin"
- [ ] Dejé el LocalScript de abrir/cerrar que está al nivel del ScreenGui
- [ ] Configuré los nombres de las mascotas en SpinConfig.lua

---

## 🐛 SI ALGO NO FUNCIONA

**Error: "No se encontró SPIN"**
→ Verifica que copiaste el ScreenGui a StarterGui

**Error: "No se encontró SpinTimer"**
→ Verifica que NO borraste el Frame "Spin", solo el LocalScript dentro

**No da mascotas:**
→ El nombre debe ser EXACTAMENTE igual al de tu sistema de pets

**Los spins no se guardan:**
→ Ya está configurado en DataStore, verifica Output por errores

---

## 🚀 ¡ESO ES TODO!

Con estos 3 pasos tu sistema de ruleta estará funcionando.

**Los archivos de código ya están completos y listos. 🎉**
