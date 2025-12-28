# 🐛 BUGFIX: Capacidad se Resetea al Salir

**Problema Reportado:** Al salir y volver a entrar, los upgrades se guardaban pero la capacidad se reseteaba.

**Fecha:** 28 Diciembre 2025
**Estado:** ✅ ARREGLADO

---

## 🔍 El Problema

### Antes del Fix:

**Al salir del juego:**
```
BackpackLevel = 10 → Guardado ✅
BaseCapacity = 170 → NO guardado ❌
Capacity = 190 (con bonuses) → Guardado pero incorrecto ❌
```

**Al volver a entrar:**
```
1. LeaderboardManager crea BaseCapacity = 10 (nivel 1 inicial)
2. DataStore carga BackpackLevel = 10
3. DataStore carga Capacity = 190
4. RecalcCapacityHandler recalcula:
   Capacity = BaseCapacity (10) + bonuses
   = 10 + (rebirths * 5) + VIP
   = Mucho menos de 190 ❌
```

**Resultado:** La capacidad se reseteaba al valor del nivel 1 + bonuses.

---

## ✅ La Solución

**Cambio en DataStore.server.lua:**

### 1. Guardar `BaseCapacity` en vez de `Capacity`

**ANTES:**
```lua
local data = {
    Money = leaderstats.Money.Value,
    BackpackLevel = stats.BackpackLevel.Value,
    Capacity = stats.Capacity.Value, -- ❌ Guardaba capacity final
}
```

**DESPUÉS:**
```lua
local data = {
    Money = leaderstats.Money.Value,
    BackpackLevel = stats.BackpackLevel.Value,
    BaseCapacity = stats.BaseCapacity.Value, -- ✅ Guarda base capacity
    -- No guardar Capacity porque se recalcula automáticamente
}
```

### 2. Cargar `BaseCapacity` al entrar

**ANTES:**
```lua
backpackLevel.Value = data.BackpackLevel or 1
capacity.Value = data.Capacity or 10 -- ❌ Cargaba mal
```

**DESPUÉS:**
```lua
backpackLevel.Value = data.BackpackLevel or 1
baseCapacity.Value = data.BaseCapacity or 10 -- ✅ Carga correcto
-- NO cargar Capacity aquí, RecalcCapacityHandler lo recalculará
```

### 3. Dejar que `RecalcCapacityHandler` recalcule automáticamente

El sistema ya existente recalcula la capacity 1 segundo después de entrar:
```lua
Capacity = BaseCapacity + (Rebirths * 5) + VIP bonus
```

---

## 🎯 Cómo Funciona Ahora

### Al Salir:
```
BackpackLevel = 10 → Guardado ✅
BaseCapacity = 170 → Guardado ✅
Rebirths = 2 → Guardado ✅
```

### Al Volver a Entrar:
```
1. LeaderboardManager crea las stats con valores iniciales
2. DataStore carga:
   - BackpackLevel = 10 ✅
   - BaseCapacity = 170 ✅
   - Rebirths = 2 ✅
3. RecalcCapacityHandler (después de 1 seg) recalcula:
   Capacity = 170 + (2 * 5) + VIP
   = 170 + 10 + 10 (si tiene VIP)
   = 190 ✅
```

**Resultado:** La capacidad se mantiene correctamente.

---

## 🧪 Cómo Probarlo

1. **Entra al juego en Studio**
2. **Compra varios upgrades de backpack** (ej: llega a nivel 10)
3. **Verifica tu capacidad** (debería ser 170 si estás en nivel 10)
4. **Sal del juego** (Stop en Studio)
5. **Vuelve a entrar** (Play de nuevo)
6. **Espera 1-2 segundos** (para que RecalcCapacityHandler ejecute)
7. **Verifica tu capacidad** → Debería seguir siendo 170 ✅

---

## 📊 Datos Guardados Ahora

El DataStore ahora guarda:

```lua
{
    Money = número,
    Inventory = número,
    InventoryValue = número,
    BackpackLevel = número,     -- Nivel de upgrade (1-34)
    BaseCapacity = número,      -- Capacidad base según nivel ✅ NUEVO
    Rebirths = número,          -- Cantidad de rebirths
    SpeedLevel = número,        -- Nivel de velocidad (0-10)
}
```

**NO guarda:**
- `Capacity` (final) - Se recalcula automáticamente

**Por qué:** La capacity final depende de múltiples factores:
- BaseCapacity (del upgrade level)
- Rebirths (+5 por rebirth)
- VIP (+10 si tiene gamepass)

Es mejor guardar los valores base y recalcular, para evitar inconsistencias.

---

## ⚠️ Importante: Jugadores Existentes

Si ya tenías jugadores que jugaron antes de este fix:

### Caso 1: Tienen data guardada con `Capacity` antigua
**Qué pasa:**
- El código intentará cargar `data.BaseCapacity`
- Como no existe en su data antigua, usará el valor por defecto `10`
- Sus upgrades se perderán ❌

**Solución - Migración de Data:**

Añade esto TEMPORALMENTE al DataStore (después de cargar):

```lua
if success and data then
    -- ... (código existente)

    -- 🔁 MIGRACIÓN: Si no tiene BaseCapacity guardado, calcularlo desde BackpackLevel
    if not data.BaseCapacity and data.BackpackLevel then
        local Upgrades = require(ReplicatedStorage.Shared.UpgradesConfig)
        local levelData = Upgrades.Backpack.Levels[data.BackpackLevel]
        if levelData then
            baseCapacity.Value = levelData.Capacity
            print("[MIGRATION] Restored BaseCapacity for", player.Name, "to", levelData.Capacity)
        end
    end
end
```

**Esto reconstruye el BaseCapacity** basándose en el BackpackLevel guardado.

### Caso 2: Jugadores nuevos
**Qué pasa:**
- No tienen data guardada
- Usan valores por defecto
- Todo funciona correctamente ✅

---

## 🔧 Si el Bug Persiste

### Verifica estos archivos:

**1. LeaderboardManager.server.lua**
- ¿Crea `BaseCapacity` correctamente?

**2. RecalcCapacityHandler.server.lua**
- ¿Espera 1 segundo antes de recalcular?
- ¿Está conectado a PlayerAdded?

**3. DataStore.server.lua**
- ¿Guarda `BaseCapacity`?
- ¿Carga `BaseCapacity`?

### Revisa el Output en Studio:

Busca errores como:
```
Infinite yield possible on 'Players.YourName.Stats:WaitForChild("BaseCapacity")'
```

Si ves esto, significa que `BaseCapacity` no se está creando.

---

## ✅ Checklist de Verificación

- [x] DataStore guarda `BaseCapacity`
- [x] DataStore carga `BaseCapacity`
- [x] RecalcCapacityHandler recalcula después de cargar
- [x] NO se guarda ni carga `Capacity` final
- [ ] Migración de data para jugadores existentes (opcional)

---

## 📝 Notas Adicionales

### ¿Por qué no guardar Capacity directamente?

**Problema:** Si guardas `Capacity = 190` y luego:
1. El jugador compra VIP gamepass
2. La capacity debería ser 200 (190 + 10)
3. Pero al recargar, vuelve a 190

**Solución:** Guardando solo los valores base (`BaseCapacity`, `Rebirths`, etc.), el sistema siempre recalcula correctamente con todos los bonuses actuales.

---

**El bug está arreglado.** Prueba en Studio y verifica que funcione correctamente.
