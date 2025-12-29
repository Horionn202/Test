# 🐾 SISTEMA DE PETS - Place2.rbxlx

## ✅ QUÉ COPIAR DEL ARCHIVO `Place2.rbxlx`

Este sistema es MUCHO más simple que el anterior.

---

## 📋 LISTA COMPLETA DE ELEMENTOS A COPIAR:

### 1️⃣ **WORKSPACE**

#### ✅ Player_Pets (OBLIGATORIO)
- **Tipo:** Folder vacía
- **Ubicación:** `Workspace > Player_Pets`
- **Qué hace:** Almacena las pets equipadas de cada jugador
- **Acción:** Copiar y pegar en tu Workspace

#### ✅ Eggs (OBLIGATORIO)
- **Tipo:** Folder con modelos de huevos
- **Ubicación:** `Workspace > Eggs`
- **Contiene:** Todos los huevos que los jugadores pueden abrir
  - Cada huevo tiene:
    - `Price` (IntValue) - Precio del huevo
    - `Currency` (StringValue) - Moneda ("Money", "Coins", etc.)
- **Acción:** Copiar toda la carpeta "Eggs" con todos los huevos

#### ⭐ Pet System Kit (OPCIONAL)
- **Tipo:** Model con ejemplos visuales
- **Ubicación:** `Workspace > Pet System Kit`
- **Qué es:** Kit de ejemplo/demostración
- **Acción:** NO es necesario, puedes omitirlo

---

### 2️⃣ **REPLICATEDSTORAGE**

#### ✅ Pets (OBLIGATORIO - LO MÁS IMPORTANTE)
- **Tipo:** Folder con subcarpetas de huevos
- **Ubicación:** `ReplicatedStorage > Pets`
- **Estructura:**
  ```
  Pets
  ├─ [Nombre del Huevo 1]
  │  ├─ Pet 1 (Model con Attributes)
  │  ├─ Pet 2 (Model con Attributes)
  │  └─ Pet 3 (Model con Attributes)
  └─ [Nombre del Huevo 2]
     ├─ Pet 1
     └─ Pet 2
  ```
- **Cada Pet debe tener:**
  - `Rarity` (IntValue) - Probabilidad de salir (1-100)
  - `Multiplier1` (NumberValue) - Multiplicador que da la pet
  - Modelo 3D con PrimaryPart configurado
- **Acción:** Copiar toda la carpeta "Pets" completa

#### ✅ EggHatchingRemotes (OBLIGATORIO)
- **Tipo:** Folder con RemoteFunctions y RemoteEvents
- **Ubicación:** `ReplicatedStorage > EggHatchingRemotes`
- **Contiene:**
  - `HatchServer` (RemoteFunction)
  - `Hatch3Pets` (RemoteFunction)
  - `EquipPet` (RemoteFunction)
  - `UnequipPet` (RemoteFunction)
  - `UnequipAll` (RemoteEvent)
  - `DeletePet` (RemoteEvent)
  - `AutoHatch` (RemoteFunction)
  - `Test` (RemoteEvent)
- **Acción:** Copiar toda la carpeta "EggHatchingRemotes"

---

### 3️⃣ **SERVERSTORAGE**

#### ✅ EggHatchingData (OBLIGATORIO)
- **Tipo:** Folder con carpetas de datos del jugador
- **Ubicación:** `ServerStorage > EggHatchingData`
- **Contiene:**
  - `Pets` (Folder) - Se clona al jugador cuando entra
  - `Values` (Folder) - Valores del jugador:
    - `MaxPetsEquipped` (IntValue) - Máximo de pets equipadas
    - `CanTripleHatch` (BoolValue) - Si puede abrir 3 huevos
    - `CanAutoHatch` (BoolValue) - Si tiene auto-hatch
    - `Multiplier1` (StringValue) - Multiplicador total
- **Acción:** Copiar toda la carpeta "EggHatchingData"

---

### 4️⃣ **SERVERCRIPTSERVICE**

#### ✅ Egg_System (OBLIGATORIO)
- **Tipo:** Folder con Script del servidor
- **Ubicación:** `ServerScriptService > Egg_System`
- **Contiene:**
  - Script principal que maneja todo el sistema
- **Acción:**
  - ❌ **NO COPIAR** - Yo voy a crear la versión adaptada a tu juego
  - Este script lo voy a integrar con tu DataStore existente

---

### 5️⃣ **STARTERGUI**

#### ⭐ Main (OPCIONAL - UI del sistema)
- **Tipo:** ScreenGui
- **Ubicación:** `StarterGui > Main`
- **Qué contiene:** UI para ver/equipar pets
- **Acción:** Copiar si quieres la interfaz gráfica

#### ⭐ EggSystem (OPCIONAL - UI de huevos)
- **Tipo:** ScreenGui
- **Ubicación:** `StarterGui > EggSystem`
- **Qué contiene:** Animaciones de apertura de huevos
- **Acción:** Copiar si quieres la interfaz gráfica

---

### 6️⃣ **STARTERPLAYER**

#### ⭐ StarterCharacterScripts (OPCIONAL)
- **Tipo:** Folder con LocalScript
- **Ubicación:** `StarterPlayer > StarterCharacterScripts`
- **Qué contiene:** Script para que las pets sigan al jugador
- **Acción:** Copiar si existe

---

## ✅ RESUMEN RÁPIDO - LO MÍNIMO NECESARIO:

### **OBLIGATORIO:**
1. ✅ `Workspace > Player_Pets` (carpeta vacía)
2. ✅ `Workspace > Eggs` (carpeta con huevos)
3. ✅ `ReplicatedStorage > Pets` (carpeta con modelos de pets)
4. ✅ `ReplicatedStorage > EggHatchingRemotes` (remote events)
5. ✅ `ServerStorage > EggHatchingData` (datos del jugador)

### **OPCIONAL:**
6. ⭐ `StarterGui > Main` (UI)
7. ⭐ `StarterGui > EggSystem` (UI)
8. ⭐ `StarterPlayer > StarterCharacterScripts` (seguir jugador)

---

## 🔧 DESPUÉS DE COPIAR TODO:

**YO VOY A:**
1. Crear el script del servidor adaptado a tu DataStore
2. Integrar con tu sistema de dinero (Money en vez de Coins)
3. Crear el script para que las pets sigan al jugador
4. Asegurarme que todo funcione con Rojo

**TÚ SOLO NECESITAS:**
1. Copiar los elementos listados arriba del archivo `Place2.rbxlx` a tu juego
2. Decirme cuando termines de copiar

---

## 📝 NOTAS IMPORTANTES:

### Estructura de cada Pet en `ReplicatedStorage > Pets`:
```
[Nombre del Huevo] (Folder)
├─ [Nombre Pet 1] (Model)
│  ├─ Rarity (IntValue) = 50  (% de probabilidad)
│  ├─ Multiplier1 (NumberValue) = 1.5  (multiplicador)
│  └─ [Partes del modelo con PrimaryPart configurado]
└─ [Nombre Pet 2] (Model)
   ├─ Rarity (IntValue) = 30
   └─ Multiplier1 (NumberValue) = 2
```

### Estructura de cada Huevo en `Workspace > Eggs`:
```
[Nombre del Huevo] (Model)
├─ Price (IntValue) = 100  (precio)
├─ Currency (StringValue) = "Money"  (moneda)
└─ [Partes del modelo del huevo]
```

---

**¿LISTO PARA COPIAR?** Avísame cuando termines y creo el sistema adaptado para ti. 🚀
