import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// Widget que muestra el botón de favoritos con estado manejado por ValueNotifier
///
/// Características:
/// - Maneja el estado de favorito internamente con ValueNotifier
/// - Usa debouncer para evitar múltiples llamadas al callback
/// - Cambia el color según el estado (AppColors.favorite cuando es favorito)
/// - Notifica cambios a través del callback onChangeValue
class ExerciseFavorite extends StatefulWidget {
  const ExerciseFavorite({
    required this.initialValue,
    required this.onChangeValue,
    this.debounceDuration = const Duration(milliseconds: 500),
    super.key,
  });

  /// Valor inicial del estado de favorito
  final bool initialValue;

  /// Callback que se ejecuta cuando el valor cambia (con debounce)
  final ValueChanged<bool> onChangeValue;

  /// Duración del debounce (por defecto 500ms)
  final Duration debounceDuration;

  @override
  State<ExerciseFavorite> createState() => _ExerciseFavoriteState();
}

class _ExerciseFavoriteState extends State<ExerciseFavorite> {
  late final ValueNotifier<bool> _isFavoriteNotifier;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _isFavoriteNotifier = ValueNotifier<bool>(widget.initialValue);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _isFavoriteNotifier.dispose();
    super.dispose();
  }

  void _toggleFavorite() {
    // Cambiar el estado localmente de inmediato
    _isFavoriteNotifier.value = !_isFavoriteNotifier.value;

    // Cancelar el timer anterior si existe
    _debounceTimer?.cancel();

    // Crear un nuevo timer para el debounce
    _debounceTimer = Timer(widget.debounceDuration, () {
      // Notificar el cambio después del debounce
      widget.onChangeValue(_isFavoriteNotifier.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isFavoriteNotifier,
      builder: (context, isFavorite, child) {
        return GestureDetector(
          onTap: _toggleFavorite,
          child: Column(
            spacing: 7,
            children: [
              Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                size: 24,
                color: isFavorite ? AppColors.favorite : AppColors.white,
              ),
              Text(
                'Favorito',
                style: AppTextStyles.small.copyWith(
                  color: isFavorite ? AppColors.favorite : AppColors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}