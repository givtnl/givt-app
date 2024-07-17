import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/generosity_challenge_cubit.dart';
import 'package:givt_app/utils/media_picker_service.dart';

class Day5SavedPicture extends StatefulWidget {
  const Day5SavedPicture({super.key});

  @override
  State<Day5SavedPicture> createState() => _Day5SavedPictureState();
}

class _Day5SavedPictureState extends State<Day5SavedPicture> {
  late final MediaPickerService service;
  String? imagePath;

  @override
  void initState() {
    super.initState();
    service = getIt<MediaPickerService>();
    _initializeImagePath();
  }

  Future<void> _initializeImagePath() async {
    imageCache.clear();
    final savedPath =
        await context.read<GenerosityChallengeCubit>().getDay5PicturePath();

    setState(() {
      imagePath = savedPath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      height: MediaQuery.sizeOf(context).width * .4,
      width: MediaQuery.sizeOf(context).width * .5,
      decoration: BoxDecoration(
        image: imagePath != null
            ? DecorationImage(
                image: FileImage(File(imagePath!)),
                fit: BoxFit.cover,
              )
            : null,
        borderRadius: BorderRadius.circular(20),
      ),
      child: imagePath == null
          ? const Center(child: CircularProgressIndicator())
          : null,
    );
  }
}
