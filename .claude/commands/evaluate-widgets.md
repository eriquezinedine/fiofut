Analyze the Flutter file at path: $ARGUMENTS

## Task

Evaluate the file and identify widgets that should be extracted into their own files in the same `widgets/` folder.

## Rules

1. **Read the full file** first to understand all widgets defined in it.
2. **Identify extraction candidates** — any widget class (public or private) that:
   - Has its own `build` method with more than ~30 lines of UI code.
   - Is logically independent and could be reused or tested separately.
   - Is NOT the main widget that gives the file its name (e.g., `SerieExerciseWidget` stays in `serie_exercise_widget.dart`).
3. **Skip extraction** for:
   - Tiny helper widgets (< 15 lines) that are only used once in the same file.
   - Widgets that depend heavily on private state of the parent widget (e.g., `_State` classes).
4. **Report findings** in a table:

| Widget | Lines | Reason to extract | Suggested file name |
|--------|-------|--------------------|---------------------|

5. **Ask the user** which widgets they want to extract.
6. **For each extraction**, create a new file in the same `widgets/` folder using `part`/`part of` so private members remain accessible. Follow the existing pattern in the codebase.
7. After extraction, verify no compilation errors are introduced.

## Output

- Show the evaluation table first.
- Wait for user confirmation before making any changes.
