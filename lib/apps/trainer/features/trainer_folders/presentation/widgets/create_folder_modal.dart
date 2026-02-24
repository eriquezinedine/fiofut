import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class CreateFolderModal extends StatefulWidget {
  const CreateFolderModal._({
    this.initialTitle,
    this.initialDescription,
  });

  final String? initialTitle;
  final String? initialDescription;

  static Future<({String title, String? description})?> show(
    BuildContext context, {
    String? initialTitle,
    String? initialDescription,
  }) {
    return showModalBottomSheet<({String title, String? description})>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CreateFolderModal._(
        initialTitle: initialTitle,
        initialDescription: initialDescription,
      ),
    );
  }

  @override
  State<CreateFolderModal> createState() => _CreateFolderModalState();
}

class _CreateFolderModalState extends State<CreateFolderModal> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _descriptionController =
        TextEditingController(text: widget.initialDescription);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final isEditing = widget.initialTitle != null;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 16 + bottomInset),
      decoration: const BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textMuted.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isEditing ? 'Editar Carpeta' : 'Crear Carpeta',
            style: AppTextStyles.h3.copyWith(color: AppColors.white),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _titleController,
            style: AppTextStyles.body.copyWith(color: AppColors.white),
            decoration: InputDecoration(
              hintText: 'Titulo de la carpeta',
              hintStyle:
                  AppTextStyles.body.copyWith(color: AppColors.textMuted),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            autofocus: true,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descriptionController,
            style: AppTextStyles.body.copyWith(color: AppColors.white),
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'Descripcion (opcional)',
              hintStyle:
                  AppTextStyles.body.copyWith(color: AppColors.textMuted),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          const SizedBox(height: 20),
          AppButton(
            text: isEditing ? 'Guardar' : 'Crear',
            onPressed: () {
              final title = _titleController.text.trim();
              if (title.isEmpty) return;
              final desc = _descriptionController.text.trim();
              Navigator.pop(
                context,
                (title: title, description: desc.isEmpty ? null : desc),
              );
            },
          ),
        ],
      ),
    );
  }
}
