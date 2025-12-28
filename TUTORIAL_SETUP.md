# 🎓 TUTORIAL SYSTEM - Setup Instructions

**IMPORTANTE:** Sigue estos pasos para que el tutorial funcione correctamente.

---

## ✅ Paso 1: Crear el RemoteEvent

El tutorial necesita un RemoteEvent para comunicarse entre cliente y servidor.

### En Roblox Studio:

1. **Abre tu juego en Roblox Studio**
2. **Ve a ReplicatedStorage** (en el Explorer)
3. **Busca la carpeta "Remotes"** (debería existir ya)
   - Si no existe, créala: Click derecho en ReplicatedStorage → Insert Object → Folder → Nombra "Remotes"
4. **Dentro de la carpeta Remotes, crea un RemoteEvent:**
   - Click derecho en "Remotes" → Insert Object → RemoteEvent
   - **Nombre:** `TutorialComplete` (exactamente así, con mayúsculas)

### Estructura final:
```
ReplicatedStorage
└── Remotes (Folder)
    ├── Rebirth (RemoteEvent)
    ├── BuyUpgrade (RemoteEvent)
    ├── PlayCollectSound (RemoteEvent)
    └── TutorialComplete (RemoteEvent) ← NUEVO
```

---

## ✅ Paso 2: Verificar que existan las zonas

El tutorial necesita estas Parts en Workspace:

### En Roblox Studio:

1. **Ve a Workspace** (en el Explorer)
2. **Verifica que existan:**
   - **FarmZone** (Part) - La zona donde aparecen los crops
   - **SellZone** (Part) - La zona donde se venden los crops

3. **Si no existen o tienen otro nombre:**
   - Edita `src/shared/TutorialConfig.lua`
   - Cambia las líneas 11 y 22 con el nombre correcto

### Estructura esperada:
```
Workspace
├── FarmZone (Part)
├── SellZone (Part)
└── ... (otros objetos)
```

---

## ✅ Paso 3: Sincronizar con Rojo

Ahora que el RemoteEvent está creado en Studio:

1. **Guarda el juego en Studio** (Ctrl + S)
2. **Sincroniza con Rojo:**
   ```bash
   rojo serve
   ```
3. **En Studio:** Plugins → Rojo → Connect

---

## 🧪 Paso 4: Probar el Tutorial

1. **Presiona Play en Studio**
2. **Deberías ver:**
   - Mensaje: "Welcome! Go to the farm zone to start collecting crops"
   - Flecha amarilla apuntando a FarmZone
3. **Sigue los pasos:**
   - Camina a FarmZone
   - Recolecta crops
   - Camina a SellZone
   - Vende crops
4. **Mensaje final:** "Tutorial completed! You now know how to play. Have fun!"
5. **Stop y Play de nuevo** → El tutorial NO debería aparecer ✅

---

## 🔍 Debugging

### Error: "Infinite yield possible on 'ReplicatedStorage.Remotes:WaitForChild(TutorialComplete)'"

**Causa:** El RemoteEvent no existe o tiene el nombre incorrecto.

**Solución:**
1. Ve a ReplicatedStorage → Remotes
2. Verifica que exista un RemoteEvent llamado **exactamente** `TutorialComplete`
3. Verifica mayúsculas/minúsculas

---

### Error: "Zona no encontrada: FarmZone"

**Causa:** La Part FarmZone no existe en Workspace.

**Solución:**
1. Crea una Part en Workspace
2. Nómbrala **exactamente** `FarmZone`
3. O edita `TutorialConfig.lua` con el nombre correcto

---

### El tutorial se repite cada vez que juego

**Causa:** El DataStore no está guardando.

**Solución:**
1. Verifica que `TutorialHandler.server.lua` exista en ServerScriptService
2. Verifica que el Output muestre: `[TUTORIAL] Player YourName completed tutorial`
3. Asegúrate de que el DataStore esté habilitado en Studio:
   - Game Settings → Security → Enable Studio Access to API Services

---

## ✅ Checklist Final

Antes de publicar, verifica:

- [ ] RemoteEvent "TutorialComplete" existe en ReplicatedStorage/Remotes
- [ ] Part "FarmZone" existe en Workspace
- [ ] Part "SellZone" existe en Workspace
- [ ] El tutorial aparece solo la primera vez
- [ ] El tutorial NO se repite en futuros joins
- [ ] Los mensajes están en inglés
- [ ] Las flechas apuntan correctamente

---

## 📝 Resumen de Archivos

### Creados automáticamente:
- ✅ `src/shared/TutorialConfig.lua`
- ✅ `src/client/TutorialSystem.client.lua`
- ✅ `src/server/MainGame/TutorialHandler.server.lua`

### Modificados automáticamente:
- ✅ `src/server/MainGame/DataStore.server.lua`

### Debes crear manualmente en Studio:
- ⚠️ ReplicatedStorage → Remotes → TutorialComplete (RemoteEvent)
- ⚠️ Workspace → FarmZone (Part)
- ⚠️ Workspace → SellZone (Part)

---

**Una vez completados estos pasos, el tutorial estará 100% funcional.** ✅
