# 💎 CÓMO CREAR PRODUCTOS DE SPINS

## ✅ YA UNIFIQUÉ EL SISTEMA

He consolidado **TODOS** los Developer Products en un solo archivo:
- **`DevProductsHandler.server.lua`** ahora maneja:
  - 💰 Productos de dinero (Money)
  - 🎲 Productos de spins (Ruleta)
  - 🐾 Productos de huevos con Robux (Pets)

---

## 🎯 PASO 1: Crear Developer Products en Roblox

### **1.1 Ve a Creator Dashboard**

1. Abre https://create.roblox.com/
2. Selecciona tu juego
3. Ve a **Monetization** → **Developer Products**

### **1.2 Crear productos de spins**

Crea estos 4 productos (o los que quieras):

| Nombre | Descripción | Precio en Robux |
|--------|-------------|----------------|
| 1 Spin | Get 1 spin for the wheel | 10 R$ |
| 3 Spins | Get 3 spins for the wheel | 25 R$ |
| 5 Spins | Get 5 spins for the wheel | 40 R$ |
| 10 Spins | Get 10 spins for the wheel | 75 R$ |

**Ajusta los precios como quieras.**

### **1.3 Copiar los Product IDs**

Después de crear cada producto, **copia su Product ID** (es un número largo).

---

## 🎯 PASO 2: Configurar los IDs en el código

Abre **`src/server/MainGame/DevProductsHandler.server.lua`**

En las **líneas 22-27**, reemplaza los `0` por tus Product IDs:

```lua
local SPIN_PRODUCTS = {
	[1234567890] = 1,   -- Cambia por tu ID - Da 1 spin
	[1234567891] = 3,   -- Cambia por tu ID - Da 3 spins
	[1234567892] = 5,   -- Cambia por tu ID - Da 5 spins
	[1234567893] = 10,  -- Cambia por tu ID - Da 10 spins
}
```

**Ejemplo:**
```lua
local SPIN_PRODUCTS = {
	[3483576001] = 1,   -- Product ID del "1 Spin"
	[3483576002] = 3,   -- Product ID del "3 Spins"
	[3483576003] = 5,   -- Product ID del "5 Spins"
	[3483576004] = 10,  -- Product ID del "10 Spins"
}
```

---

## 🎯 PASO 3: Crear botones en la UI

### **Opción A: Botones en la ventana de la ruleta**

Edita el UI **SpinUI** en StarterGui y agrega botones de compra.

Por ejemplo, dentro del Frame "Spin", agrega:
```
Spin (Frame)
├── ... otros elementos
└── BuySpinsFrame (Frame)
    ├── Buy1Spin (TextButton)
    ├── Buy3Spins (TextButton)
    ├── Buy5Spins (TextButton)
    └── Buy10Spins (TextButton)
```

### **Opción B: Script para mostrar prompts**

Puedes usar el prompt de compra directamente desde cualquier botón:

```lua
-- En cualquier LocalScript
local MarketplaceService = game:GetService("MarketplaceService")

local button = script.Parent -- Tu botón
local PRODUCT_ID = 1234567890 -- Tu Product ID

button.MouseButton1Click:Connect(function()
	MarketplaceService:PromptProductPurchase(
		game.Players.LocalPlayer,
		PRODUCT_ID
	)
end)
```

---

## 🎯 OPCIÓN FÁCIL: Te creo un script de compra

Si quieres, puedo crear un **LocalScript** que agregue botones de compra automáticamente a la ventana de la ruleta.

---

## 🔍 CÓMO PROBAR

1. **Publica tu juego** (los DevProducts solo funcionan en juegos publicados)
2. Ejecuta el juego desde Roblox (no desde Studio)
3. Click en el botón de compra
4. Compra el producto
5. Los spins se agregarán automáticamente

En el **Output** del servidor verás:
```
[DevProducts] NOMBRE compró 3 spins
```

---

## ✅ VENTAJAS DEL SISTEMA UNIFICADO

- ✅ Un solo ProcessReceipt para todo
- ✅ Fácil de mantener
- ✅ No hay conflictos entre handlers
- ✅ Funciona con: Money, Spins y Pets

---

## 🐛 SOLUCIÓN DE PROBLEMAS

### **Error: "Producto no reconocido"**
→ Verifica que el Product ID esté correcto en SPIN_PRODUCTS

### **No se agregan spins después de comprar**
→ Verifica en Output del servidor si hay errores

### **Los productos no aparecen**
→ Debes publicar el juego primero

---

## 📝 RESUMEN RÁPIDO:

1. ✅ Crea 4 Developer Products en Creator Dashboard
2. ✅ Copia los Product IDs
3. ✅ Pégalos en `DevProductsHandler.server.lua` (líneas 22-27)
4. ✅ Crea botones en el UI para comprar
5. ✅ Publica el juego y prueba

**¿Quieres que te cree un script para los botones de compra?** 🎮
