import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:testvid/generated/l10n.dart';
import 'package:testvid/core/utils/snackbar_helper.dart';

class VideoController extends GetxController {
  Rx<File?> videoFile = Rx<File?>(null);
  Rx<VideoPlayerController?> playerController =
      Rx<VideoPlayerController?>(null);
  RxBool isInitialized = false.obs;
  RxString customVideoName = RxString('');

  @override
  void onClose() {
    playerController.value?.dispose();
    super.onClose();
  }

  Future<void> pickVideo() async {
    final picker = ImagePicker();
    final pickedVideo = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedVideo != null) {
      videoFile.value = File(pickedVideo.path);

      // Show dialog for custom name
      final String? newName = await Get.dialog(
        Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              child: Builder(
                builder: (context) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      S.of(context).videoName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: pickedVideo.path.split('/').last,
                      decoration: InputDecoration(
                        hintText: S.of(context).enterVideoName,
                        hintStyle: TextStyle(
                          color: Colors.grey.withValues(alpha: 0.5),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onFieldSubmitted: (value) => Get.back(result: value),
                      onSaved: (value) => Get.back(result: value),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: Text(S.of(context).cancel),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6C63FF),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            Form.of(context).save();
                          },
                          child: Text(S.of(context).confirm),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      if (newName != null && newName.isNotEmpty) {
        customVideoName.value = newName;
      } else {
        customVideoName.value = pickedVideo.path.split('/').last;
      }

      initializeController(videoFile.value!);
    }
  }

  void initializeController(File file) async {
    if (playerController.value != null) {
      await playerController.value!.pause(); // Önce durdur
      await playerController.value!.dispose(); // Sonra dispose et
      playerController.value = null; // Mutlaka null'a çek
    }

    final controller = VideoPlayerController.file(file);
    await controller.initialize();
    controller.setLooping(true);
    await controller.play();

    playerController.value = controller;
    isInitialized.value = true;

    update(); // Ekranı yenile
  }

  void showTrimmer() async {
    if (videoFile.value != null) {
      final result = await Get.toNamed(
        '/video-trim',
        arguments: videoFile.value,
      );
      if (result != null && result is File) {
        updateVideo(result);
      }
    }
  }

  void runDeepfakeCheck() {
    SnackbarHelper.showInfo('Processing', 'Deepfake check would run here with an API');
  }

  void clearVideo() async {
    if (playerController.value != null) {
      await playerController.value!.pause();
      await playerController.value!.dispose();
      playerController.value = null;
    }

    videoFile.value = null;
    isInitialized.value = false;
    update();
  }

  void updateVideo(File newVideo) {
    // Preserve the custom name if it exists
    if (customVideoName.value.isEmpty) {
      customVideoName.value = newVideo.path.split('/').last;
    } else {
      // If there was a custom name, append "_trimmed" to it
      if (!customVideoName.value.endsWith("_trimmed")) {
        customVideoName.value = "${customVideoName.value}_trimmed";
      }
    }

    videoFile.value = newVideo;
    initializeController(newVideo);
    update();
  }

  String getDisplayName() {
    return customVideoName.value.isNotEmpty
        ? customVideoName.value
        : videoFile.value?.path.split('/').last ?? 'Unknown Video';
  }
}
