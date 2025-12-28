# 📱 Daily Rewards UI - Versión Mobile con Scroll

Esta guía te muestra cómo crear la UI con **ScrollingFrame** para que funcione perfecto en móviles.

---

## ✅ Paso 1: Estructura Base (Igual que antes)

1. **StarterGui → Insert Object → ScreenGui**
   - Nombre: `DailyRewardsGui`
   - ResetOnSpawn: `false`

2. **Insert Object → Frame** (dentro de DailyRewardsGui)
   - Nombre: `MainFrame`
   - Size: `{0.9, 0},{0.8, 0}` (más grande para móviles)
   - Position: `{0.05, 0},{0.1, 0}`
   - AnchorPoint: `{0, 0}`
   - BackgroundColor3: `RGB(30, 30, 40)`
   - BorderSizePixel: `0`

3. **Añade UICorner:**
   - CornerRadius: `{0, 12}`

---

## ✅ Paso 2: Elementos del MainFrame

### TitleLabel
```
TextLabel:
├─ Name: TitleLabel
├─ Size: {1, 0},{0.08, 0}
├─ Position: {0, 0},{0, 0}
├─ BackgroundTransparency: 1
├─ Text: "DAILY REWARDS"
├─ TextColor3: RGB(255, 255, 255)
├─ TextSize: 24
└─ Font: GothamBold
```

### CloseButton
```
TextButton:
├─ Name: CloseButton
├─ Size: {0.1, 0},{0.08, 0}
├─ Position: {0.88, 0},{0.01, 0}
├─ BackgroundColor3: RGB(200, 50, 50)
├─ Text: "X"
├─ TextColor3: RGB(255, 255, 255)
├─ TextSize: 20
└─ Font: GothamBold
```
+ UICorner: `{0, 8}`

### StatusLabel
```
TextLabel:
├─ Name: StatusLabel
├─ Size: {0.8, 0},{0.06, 0}
├─ Position: {0.1, 0},{0.1, 0}
├─ BackgroundTransparency: 1
├─ Text: "Loading..."
├─ TextColor3: RGB(200, 200, 200)
├─ TextSize: 16
└─ Font: Gotham
```

---

## ✅ Paso 3: DaysContainer con SCROLL 🔥

**IMPORTANTE:** Usa **ScrollingFrame** en lugar de Frame normal.

1. **Insert Object → ScrollingFrame** (dentro de MainFrame)
2. **Nombre:** `DaysContainer`
3. **Propiedades:**

```
ScrollingFrame:
├─ Size: {0.9, 0},{0.62, 0}
├─ Position: {0.05, 0},{0.18, 0}
├─ BackgroundTransparency: 1
├─ BorderSizePixel: 0
├─ ScrollBarThickness: 8
├─ ScrollBarImageColor3: RGB(100, 100, 100)
├─ ScrollBarImageTransparency: 0.5
├─ CanvasSize: {0, 0},{0, 0}  ← Se auto-ajustará con AutomaticCanvasSize
├─ AutomaticCanvasSize: Y  ← IMPORTANTE: Esto hace el scroll automático
└─ ScrollingDirection: Y
```

4. **Añade UIListLayout** (NO UIGridLayout):
   - Click derecho en DaysContainer → Insert Object → **UIListLayout**

```
UIListLayout:
├─ FillDirection: Vertical  ← Los días van uno debajo del otro
├─ HorizontalAlignment: Center
├─ VerticalAlignment: Top
├─ Padding: {0, 10}  ← 10 píxeles entre cada día
└─ SortOrder: Name
```

5. **Añade UIPadding** (opcional pero recomendado):
```
UIPadding:
├─ PaddingTop: {0, 10}
├─ PaddingBottom: {0, 10}
├─ PaddingLeft: {0, 0}
└─ PaddingRight: {0, 0}
```

---

## ✅ Paso 4: Crear los Day Frames (DIFERENTE)

Ahora los días serán **más grandes** y **verticales** porque tenemos scroll.

### Crear Day1:

1. **Insert Object → Frame** (dentro de DaysContainer)
2. **Nombre:** `Day1`
3. **Propiedades:**

```
Frame:
├─ Size: {0.9, 0},{0, 80}  ← Ancho 90%, alto FIJO 80 píxeles
├─ BackgroundColor3: RGB(50, 50, 50)
├─ BorderSizePixel: 0
└─ LayoutOrder: 1  ← Para ordenar correctamente
```

4. **Añade UICorner:**
   - CornerRadius: `{0, 8}`

### Elementos dentro de Day1:

#### a) DayLabel
```
TextLabel:
├─ Name: DayLabel
├─ Size: {0.3, 0},{1, 0}  ← Ocupa 30% del ancho
├─ Position: {0, 0},{0, 0}
├─ BackgroundTransparency: 1
├─ Text: "Day 1"
├─ TextColor3: RGB(255, 255, 255)
├─ TextSize: 18
├─ Font: GothamBold
└─ TextXAlignment: Left
```

#### b) IconLabel
```
TextLabel:
├─ Name: IconLabel
├─ Size: {0.15, 0},{1, 0}  ← 15% del ancho
├─ Position: {0.3, 0},{0, 0}
├─ BackgroundTransparency: 1
├─ Text: ""
├─ TextColor3: RGB(255, 255, 255)
├─ TextSize: 28
└─ Font: GothamBold
```

#### c) RewardLabel
```
TextLabel:
├─ Name: RewardLabel
├─ Size: {0.4, 0},{1, 0}  ← 40% del ancho
├─ Position: {0.5, 0},{0, 0}
├─ BackgroundTransparency: 1
├─ Text: "$100"
├─ TextColor3: RGB(255, 215, 0)
├─ TextSize: 20
├─ Font: GothamBold
└─ TextXAlignment: Right
```

### Duplicar Day1 para crear Day2-Day7:

1. **Duplica Day1** (Ctrl+D) 6 veces
2. **Renombra:** Day2, Day3, Day4, Day5, Day6, Day7
3. **Cambia LayoutOrder:**
   - Day1: LayoutOrder = 1
   - Day2: LayoutOrder = 2
   - Day3: LayoutOrder = 3
   - etc.
4. **Cambia RewardLabel.Text:**
   - Day2: "$200"
   - Day3: "$300"
   - Day4: "$500"
   - Day5: "$750"
   - Day6: "$1000"
   - Day7: "$2000"

---

## ✅ Paso 5: ClaimButton

```
TextButton:
├─ Name: ClaimButton
├─ Size: {0.8, 0},{0.1, 0}
├─ Position: {0.1, 0},{0.85, 0}
├─ BackgroundColor3: RGB(85, 255, 127)
├─ Text: "CLAIM DAILY REWARD"
├─ TextColor3: RGB(0, 0, 0)
├─ TextSize: 18
└─ Font: GothamBold
```
+ UICorner: `{0, 8}`

---

## 📐 Cómo se verá:

```
┌─────────────────────────────┐
│   DAILY REWARDS          X  │
│   Loading...                │
├─────────────────────────────┤
│ ┌─────────────────────────┐ │ ↕ SCROLL
│ │ Day 1      !      $100  │ │ │
│ └─────────────────────────┘ │ │
│ ┌─────────────────────────┐ │ │
│ │ Day 2             $200  │ │ │
│ └─────────────────────────┘ │ │
│ ┌─────────────────────────┐ │ │
│ │ Day 3             $300  │ │ ↓
│ └─────────────────────────┘ │
│ ... (scroll para ver más)   │
├─────────────────────────────┤
│   [CLAIM DAILY REWARD]      │
└─────────────────────────────┘
```

---

## 🎨 Ventajas de esta versión:

✅ **Funciona perfecto en móviles** - Scroll táctil natural
✅ **Más espacio para cada día** - Texto más legible
✅ **Escalable** - Si en el futuro quieres 14 días, solo duplicas
✅ **No se deforma** - En pantallas pequeñas se puede hacer scroll

---

## 🔧 Ajustes Opcionales:

### Hacer el scroll más visible:
```lua
ScrollBarThickness: 12  -- Más grueso
ScrollBarImageColor3: RGB(85, 255, 127)  -- Verde llamativo
ScrollBarImageTransparency: 0.3  -- Menos transparente
```

### Cambiar el padding entre días:
```lua
UIListLayout.Padding: {0, 15}  -- Más espacio
```

### Días más altos:
```lua
Day1.Size: {0.9, 0},{0, 100}  -- 100 píxeles de alto
```

---

## 📱 Testing en Móvil:

En Studio puedes probar cómo se ve en móvil:

1. **Ve a:** Test → Device Emulation
2. **Selecciona:** Phone (ej: iPhone 12)
3. **Play**
4. Deberías poder hacer scroll con el mouse (simula dedo)

---

## ✅ Estructura Final:

```
StarterGui
└── DailyRewardsGui (ScreenGui)
    └── MainFrame (Frame)
        ├── TitleLabel (TextLabel)
        ├── CloseButton (TextButton)
        ├── StatusLabel (TextLabel)
        ├── DaysContainer (ScrollingFrame) ← SCROLLING
        │   ├── UIListLayout ← VERTICAL
        │   ├── UIPadding
        │   ├── Day1 (Frame)
        │   │   ├── DayLabel
        │   │   ├── IconLabel
        │   │   └── RewardLabel
        │   ├── Day2 (Frame)
        │   ├── Day3 (Frame)
        │   ├── Day4 (Frame)
        │   ├── Day5 (Frame)
        │   ├── Day6 (Frame)
        │   └── Day7 (Frame)
        └── ClaimButton (TextButton)
```

---

**El código que hice sigue funcionando igual, solo cambiaste la UI de horizontal a vertical con scroll.** ✅

El script automáticamente detecta los Day1-Day7 y los actualiza, no importa si están en grid o en lista vertical.
