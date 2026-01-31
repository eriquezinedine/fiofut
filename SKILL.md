# SKILL.md - Reglas de Desarrollo para FioFut

## REGLA PRINCIPAL: Usar widgets y estilos globales del package `app_ui`

**NUNCA** hardcodear colores, estilos de texto, o crear widgets personalizados cuando ya existen en `app_ui`.

---

## 1. COLORES - Usar `AppColors`

**PROHIBIDO:**
```dart
// MAL - Color hardcodeado
Color(0xFFE53935)
Color(0xFF22C55E)
Color(0xFF3B82F6)
Color(0xFF6B7280)
Color(0xFF1A1A1A)
```

**CORRECTO:**
```dart
// BIEN - Usar AppColors
AppColors.red
AppColors.green
AppColors.blue
AppColors.textMuted
AppColors.card
AppColors.backgroundSecondary
```

### Colores disponibles en `AppColors`:
- **Brand:** `primary` (lime), `secondary` (red)
- **Backgrounds:** `background`, `backgroundSecondary`, `card`, `surface`, `surfaceAlt`
- **Text:** `textPrimary`, `textSecondary`, `textMuted`, `textDimmed`, `titleColor`
- **Status:** `success`, `error`, `warning`, `info`
- **Base:** `red`, `redBright`, `redCoral`, `green`, `blue`, `orange`, `purple`, `pink`, `teal`, `lime`
- **Helpers:** `white`, `black`, `transparent`, `border`, `divider`

---

## 2. ESTILOS DE TEXTO - Usar `AppTextStyles`

**PROHIBIDO:**
```dart
// MAL - TextStyle hardcodeado
TextStyle(
  fontFamily: 'Inter',
  fontSize: 15,
  fontWeight: FontWeight.normal,
  color: AppColors.textPrimary,
)
```

**CORRECTO:**
```dart
// BIEN - Usar AppTextStyles
AppTextStyles.input
AppTextStyles.inputHint
AppTextStyles.body
AppTextStyles.bodyMedium
AppTextStyles.caption
AppTextStyles.titleSmall
AppTextStyles.button
```

### Estilos disponibles en `AppTextStyles`:
- **Display:** `displayXL` (80px bold - para numeros grandes como peso/altura)
- **Headings:** `h1` (48px), `h2` (28px), `h3` (20px)
- **Body:** `body`, `bodyMedium`, `bodyDefault`, `bodySmall`
- **Titles:** `titleLarge`, `titleMedium`, `titleSmall`
- **Labels:** `labelLarge`, `labelMedium`, `labelSmall`
- **Input:** `input` (15px), `inputHint` (15px muted)
- **Buttons:** `button`, `buttonSmall`
- **Others:** `caption`, `small`, `overline`

---

## 3. WIDGETS GLOBALES - Usar widgets de `app_ui`

**PROHIBIDO:**
```dart
// MAL - TextField raw con Container personalizado
Container(
  decoration: BoxDecoration(...),
  child: TextField(...),
)
```

**CORRECTO:**
```dart
// BIEN - Usar widgets globales
AppTextField(...)
AppTextArea(...)
AppInputWithAction(...)
AppSearchField(...)
AppButton(...)
AppCard(...)
AppEmptyState(...)
```

### Widgets disponibles:
- `AppTextField` - Campo de texto estándar
- `AppTextArea` - Campo multilínea (altura 180px)
- `AppInputWithAction` - Input con botón de acción (ej: código referido)
- `AppSearchField` - Campo de búsqueda
- `AppButton` - Botón principal
- `AppCard` - Card estándar
- `AppEmptyState` - Estado vacío
- `AppLoading` - Indicador de carga
- `AppErrorWidget` - Widget de error
- `AppCachedImage` - Imagen con cache

---

## 4. SPACING - Usar `AppSpacing`

**PROHIBIDO:**
```dart
// MAL - SizedBox hardcodeado
SizedBox(height: 8)
SizedBox(width: 16)
```

**CORRECTO:**
```dart
// BIEN - Usar AppSpacing
AppSpacing.verticalXs  // 4
AppSpacing.verticalSm  // 8
AppSpacing.verticalMd  // 16
AppSpacing.verticalLg  // 24
AppSpacing.verticalXl  // 32

AppSpacing.horizontalXs
AppSpacing.horizontalSm
// etc.
```

---

## 5. IMPORTAR `app_ui`

Siempre importar el package:
```dart
import 'package:app_ui/app_ui.dart';
```

Esto da acceso a:
- `AppColors`
- `AppTextStyles`
- `AppSpacing`
- Todos los widgets globales

---

## RESUMEN

| Tipo | PROHIBIDO | CORRECTO |
|------|-----------|----------|
| Colores | `Color(0xFF...)` | `AppColors.xxx` |
| Texto | `TextStyle(fontFamily: 'Inter'...)` | `AppTextStyles.xxx` |
| Inputs | `TextField()` raw | `AppTextField`, `AppTextArea`, etc. |
| Spacing | `SizedBox(height: 8)` | `AppSpacing.verticalSm` |
