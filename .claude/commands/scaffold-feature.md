Create a new Flutter feature following the project's Clean Architecture structure.

## Input

Ask the user for the **feature name** in snake_case (e.g., `training_exercise`, `player_profile`).

## Task

Given the feature name `$FEATURE`, create the following folder and file structure under `lib/apps/client/features/$FEATURE/`:

```
$FEATURE/
├── data/
│   └── repositories/
├── domain/
│   ├── models/
│   ├── providers/
│   └── domain.dart
├── presentation/
│   ├── screens/
│   │   ├── ${FEATURE}_screen.dart
│   │   └── screens.dart
│   ├── widgets/
│   │   └── widgets.dart
│   └── presentation.dart
└── $FEATURE.dart
```

## File contents

### `$FEATURE.dart` (barrel export at feature root)
```dart
export 'domain/domain.dart';
export 'presentation/presentation.dart';
```

### `domain/domain.dart`
```dart
// exports for models and providers will go here
```

### `presentation/presentation.dart`
```dart
export 'screens/screens.dart';
export 'widgets/widgets.dart';
```

### `presentation/screens/screens.dart`
```dart
export '${FEATURE}_screen.dart';
```

### `presentation/screens/${FEATURE}_screen.dart`
```dart
import 'package:flutter/material.dart';

class ${FeaturePascalCase}Screen extends StatelessWidget {
  const ${FeaturePascalCase}Screen({super.key});

  static const String name = '${FEATURE}';
  static const String path = '/${FEATURE}';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('${FeaturePascalCase}Screen'),
      ),
    );
  }
}
```

Where `${FeaturePascalCase}` is the feature name converted to PascalCase (e.g., `training_exercise` → `TrainingExercise`).
The `name` and `path` use the snake_case feature name (e.g., `name = 'training_exercise'`, `path = '/training_exercise'`).

### `presentation/widgets/widgets.dart`
```dart
// exports for widgets will go here
```

## Rules

1. **Always ask** for the feature name before creating anything.
2. Convert the feature name to snake_case if the user provides it in another format.
3. Create ALL folders and files listed above — do not skip any.
4. Use the exact barrel export pattern shown.
5. After creating all files, show a summary tree of what was created.
6. Do NOT add the feature to any router or navigation — just scaffold the structure.
