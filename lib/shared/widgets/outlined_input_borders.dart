import 'package:flutter/material.dart';
import 'package:givt_app/utils/app_theme.dart';

InputBorder get enabledInputBorder => OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: AppTheme.inputFieldBorderEnabled,
        width: 2,
      ),
    );

InputBorder get selectedInputBorder => OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: AppTheme.primary40,
        width: 2,
      ),
    );
InputBorder get errorInputBorder => OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: AppTheme.error50,
        width: 2,
      ),
    );
