### 📝 Daily Rewards - Manual UI Setup Guide

**Sistema completado:** El código está 100% funcional. Solo necesitas crear la UI manualmente en Studio siguiendo esta guía.

---

## ✅ Paso 1: Crear RemoteEvents

Antes de crear la UI, necesitas dos RemoteEvents:

### En Roblox Studio:

1. **Ve a:** ReplicatedStorage → Remotes
2. **Crea dos RemoteEvents:**
   - Click derecho en "Remotes" → Insert Object → RemoteEvent
   - **Nombre:** `ClaimDailyReward`
   - Click derecho en "Remotes" → Insert Object → RemoteEvent
   - **Nombre:** `CheckDailyReward`

### Estructura:
```
ReplicatedStorage
└── Remotes
    ├── ClaimDailyReward (RemoteEvent) ← NUEVO
    ├── CheckDailyReward (RemoteEvent) ← NUEVO
    └── ... (otros remotes)
```

---

## ✅ Paso 2: Crear la UI Principal

### 2.1 Crear el ScreenGui

1. **Ve a:** StarterGui (en el Explorer)
2. **Click derecho → Insert Object → ScreenGui**
3. **Nombre:** `DailyRewardsGui` (exactamente así)
4. **Propiedades:**
   - ResetOnSpawn: `false`
   - ZIndexBehavior: `Sibling`

### 2.2 Crear el MainFrame

1. **Click derecho en DailyRewardsGui → Insert Object → Frame**
2. **Nombre:** `MainFrame`
3. **Propiedades:**
   - Size: `{0.5, 0},{0.6, 0}` (UDim2)
   - Position: `{0.25, 0},{0.2, 0}` (centrado)
   - AnchorPoint: `{0, 0}`
   - BackgroundColor3: `RGB(30, 30, 40)` (gris oscuro)
   - BorderSizePixel: `0`

4. **Añade UICorner al MainFrame:**
   - Click derecho en MainFrame → Insert Object → UICorner
   - CornerRadius: `{0, 12}`

---

## ✅ Paso 3: Crear Elementos del MainFrame

Todos estos elementos son **hijos de MainFrame**.

### 3.1 TitleLabel (Título)

1. **Insert Object → TextLabel**
2. **Nombre:** `TitleLabel`
3. **Propiedades:**
   - Size: `{1, 0},{0.1, 0}`
   - Position: `{0, 0},{0, 0}`
   - BackgroundTransparency: `1`
   - Text: `"DAILY REWARDS"`
   - TextColor3: `RGB(255, 255, 255)`
   - TextSize: `28`
   - Font: `GothamBold`
   - TextScaled: `false`

### 3.2 CloseButton (Botón X)

1. **Insert Object → TextButton**
2. **Nombre:** `CloseButton`
3. **Propiedades:**
   - Size: `{0.08, 0},{0.08, 0}`
   - Position: `{0.9, 0},{0.02, 0}`
   - BackgroundColor3: `RGB(200, 50, 50)` (rojo)
   - Text: `"X"`
   - TextColor3: `RGB(255, 255, 255)`
   - TextSize: `24`
   - Font: `GothamBold`

4. **Añade UICorner:**
   - CornerRadius: `{0, 8}`

### 3.3 StatusLabel (Estado actual)

1. **Insert Object → TextLabel**
2. **Nombre:** `StatusLabel`
3. **Propiedades:**
   - Size: `{0.8, 0},{0.08, 0}`
   - Position: `{0.1, 0},{0.12, 0}`
   - BackgroundTransparency: `1`
   - Text: `"Loading..."`
   - TextColor3: `RGB(200, 200, 200)`
   - TextSize: `18`
   - Font: `Gotham`

### 3.4 DaysContainer (Contenedor de los 7 días)

1. **Insert Object → Frame**
2. **Nombre:** `DaysContainer`
3. **Propiedades:**
   - Size: `{0.9, 0},{0.5, 0}`
   - Position: `{0.05, 0},{0.22, 0}`
   - BackgroundTransparency: `1`

4. **Añade UIGridLayout:**
   - Click derecho en DaysContainer → Insert Object → UIGridLayout
   - **Propiedades:**
     - CellSize: `{0, 120},{0, 100}`
     - CellPadding: `{0, 10},{0, 10}`
     - FillDirection: `Horizontal`
     - HorizontalAlignment: `Center`
     - SortOrder: `Name`

### 3.5 ClaimButton (Botón de reclamar)

1. **Insert Object → TextButton**
2. **Nombre:** `ClaimButton`
3. **Propiedades:**
   - Size: `{0.6, 0},{0.12, 0}`
   - Position: `{0.2, 0},{0.82, 0}`
   - BackgroundColor3: `RGB(85, 255, 127)` (verde)
   - Text: `"CLAIM DAILY REWARD"`
   - TextColor3: `RGB(0, 0, 0)`
   - TextSize: `20`
   - Font: `GothamBold`

4. **Añade UICorner:**
   - CornerRadius: `{0, 8}`

---

## ✅ Paso 4: Crear los 7 Días (Day Frames)

Ahora crearás **7 Frames idénticos** dentro de **DaysContainer**. Aquí está cómo crear uno, luego duplicarás:

### 4.1 Crear Day1

1. **Click derecho en DaysContainer → Insert Object → Frame**
2. **Nombre:** `Day1`
3. **Propiedades:**
   - Size: Auto (controlado por UIGridLayout)
   - BackgroundColor3: `RGB(50, 50, 50)` (gris)
   - BorderSizePixel: `0`

4. **Añade UICorner:**
   - CornerRadius: `{0, 8}`

### 4.2 Crear elementos dentro de Day1

Todos estos son **hijos de Day1**:

#### a) DayLabel (Texto "Day 1")

1. **Insert Object → TextLabel**
2. **Nombre:** `DayLabel`
3. **Propiedades:**
   - Size: `{1, 0},{0.3, 0}`
   - Position: `{0, 0},{0.05, 0}`
   - BackgroundTransparency: `1`
   - Text: `"Day 1"`
   - TextColor3: `RGB(255, 255, 255)`
   - TextSize: `16`
   - Font: `GothamBold`

#### b) IconLabel (Icono ✓ o !)

1. **Insert Object → TextLabel**
2. **Nombre:** `IconLabel`
3. **Propiedades:**
   - Size: `{1, 0},{0.3, 0}`
   - Position: `{0, 0},{0.35, 0}`
   - BackgroundTransparency: `1`
   - Text: `""` (vacío por ahora)
   - TextColor3: `RGB(255, 255, 255)`
   - TextSize: `32`
   - Font: `GothamBold`

#### c) RewardLabel (Cantidad de dinero)

1. **Insert Object → TextLabel**
2. **Nombre:** `RewardLabel`
3. **Propiedades:**
   - Size: `{1, 0},{0.25, 0}`
   - Position: `{0, 0},{0.7, 0}`
   - BackgroundTransparency: `1`
   - Text: `"$100"`
   - TextColor3: `RGB(255, 215, 0)` (dorado)
   - TextSize: `18`
   - Font: `GothamBold`

### 4.3 Duplicar para Day2-Day7

1. **Click derecho en Day1 → Duplicate** (o Ctrl+D)
2. **Renombra la copia a `Day2`**
3. **Cambia RewardLabel.Text a `"$200"`**

4. **Repite para Day3-Day7:**
   - Day3: `"$300"`
   - Day4: `"$500"`
   - Day5: `"$750"`
   - Day6: `"$1000"`
   - Day7: `"$2000"`

---

## ✅ Paso 5: Estructura Final

Verifica que tu estructura sea exactamente así:

```
StarterGui
└── DailyRewardsGui (ScreenGui)
    └── MainFrame (Frame)
        ├── TitleLabel (TextLabel)
        ├── CloseButton (TextButton)
        ├── StatusLabel (TextLabel)
        ├── DaysContainer (Frame)
        │   ├── Day1 (Frame)
        │   │   ├── DayLabel (TextLabel)
        │   │   ├── IconLabel (TextLabel)
        │   │   └── RewardLabel (TextLabel)
        │   ├── Day2 (Frame)
        │   │   ├── DayLabel (TextLabel)
        │   │   ├── IconLabel (TextLabel)
        │   │   └── RewardLabel (TextLabel)
        │   ├── Day3... Day7 (igual)
        └── ClaimButton (TextButton)
```

---

## ✅ Paso 6: Sincronizar y Probar

1. **Guarda el juego** (Ctrl+S)
2. **Sincroniza con Rojo** (si está corriendo)
3. **Presiona Play en Studio**

### ¿Qué debería pasar?

- **A los 3 segundos** de entrar, la UI debería aparecer automáticamente (si puedes reclamar)
- Verás:
  - **Day 1** en verde (disponible)
  - **Days 2-7** en gris oscuro (bloqueados)
  - Botón **"CLAIM DAY 1 REWARD"** en verde
  - Status: **"Available: $100"**

4. **Click en CLAIM**
   - Recibirás $100
   - Botón cambiará a gris: **"CLAIMED - COME BACK LATER"**
   - Day 1 tendrá un ✓
   - Status: **"Next reward in 23h 59m"**

---

## ✅ Paso 7: Testing Rápido (Opcional)

Si quieres probar sin esperar 24 horas:

### Modificar Cooldown:

1. **Abre:** `src/shared/DailyRewardsConfig.lua`
2. **Cambia línea 29:**
   ```lua
   DailyRewardsConfig.ClaimCooldown = 60 -- 1 minuto (para testing)
   ```
3. **Guarda y sincroniza**
4. **Ahora podrás reclamar cada 1 minuto**

**IMPORTANTE:** Antes de publicar, ¡vuelve a cambiar a 86400 (24 horas)!

---

## 🎨 Personalización (Opcional)

### Cambiar Colores:

Edita `src/shared/DailyRewardsConfig.lua` líneas 37-42:

```lua
DailyRewardsConfig.UIColors = {
    Available = Color3.fromRGB(85, 255, 127), -- Verde
    Claimed = Color3.fromRGB(100, 100, 100), -- Gris
    Locked = Color3.fromRGB(50, 50, 50), -- Gris oscuro
    Special = Color3.fromRGB(255, 215, 0), -- Dorado (día 7)
}
```

### Cambiar Recompensas:

Edita `src/shared/DailyRewardsConfig.lua` líneas 7-35:

```lua
[1] = {
    Money = 500, -- Cambia aquí
    Name = "Day 1",
    Description = "Welcome back!",
},
```

---

## 🔍 Debugging

### Error: "DailyRewardsGui not found in PlayerGui"

**Causa:** La UI no existe o tiene nombre incorrecto.

**Solución:**
- Ve a StarterGui
- Verifica que exista `DailyRewardsGui` (exactamente así, con mayúsculas)

---

### Error: "Infinite yield on MainFrame"

**Causa:** Falta MainFrame o tiene nombre incorrecto.

**Solución:**
- Dentro de DailyRewardsGui, debe haber un Frame llamado `MainFrame`

---

### La UI no se abre automáticamente

**Posible causa:** Ya reclamaste hoy.

**Solución para resetear:**
1. En Command Bar (Server):
   ```lua
   for _, p in ipairs(game.Players:GetPlayers()) do
       p:SetAttribute("LastDailyReward", 0)
       p:SetAttribute("DailyStreak", 0)
   end
   ```
2. Stop y Play de nuevo

---

### Los días no cambian de color

**Causa:** Los nombres de los Day Frames están mal.

**Solución:**
- Verifica que en DaysContainer tengas exactamente:
  - `Day1`, `Day2`, `Day3`, `Day4`, `Day5`, `Day6`, `Day7`
- Mayúsculas y minúsculas importan

---

## 📊 Datos Guardados

El sistema guarda en DataStore:

```lua
{
    LastDailyReward = timestamp, -- Última vez que reclamó
    DailyStreak = número,        -- Día actual del streak (1-7)
}
```

---

## ✅ Checklist Final

Antes de publicar, verifica:

- [ ] RemoteEvents `ClaimDailyReward` y `CheckDailyReward` existen
- [ ] ScreenGui `DailyRewardsGui` existe en StarterGui
- [ ] MainFrame con todos los elementos existe
- [ ] 7 Day Frames (Day1-Day7) existen en DaysContainer
- [ ] Cada Day Frame tiene DayLabel, IconLabel, RewardLabel
- [ ] Cooldown está en 86400 (24 horas), no en 60 segundos
- [ ] La UI se abre automáticamente al entrar (si puede reclamar)
- [ ] El botón CLAIM funciona correctamente
- [ ] El streak se guarda entre sesiones

---

## 📝 Archivos Creados (Automáticamente)

- ✅ `src/shared/DailyRewardsConfig.lua` - Configuración
- ✅ `src/server/MainGame/DailyRewardsHandler.server.lua` - Servidor
- ✅ `src/client/DailyRewards.client.lua` - Cliente (LocalScript)
- ✅ `src/server/MainGame/DataStore.server.lua` - Actualizado

---

## 🎯 Siguiente Paso Recomendado

Después de implementar Daily Rewards, considera:
1. **Codes System** (fácil, 3 horas) - Códigos canjeables
2. **Quest System** (8 horas) - Objetivos diarios
3. **Achievements** (6 horas) - Badges y logros

---

**El código está 100% listo. Solo crea la UI en Studio siguiendo esta guía.** ✅
