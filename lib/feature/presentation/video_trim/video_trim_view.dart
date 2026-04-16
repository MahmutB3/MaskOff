import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_trimmer/video_trimmer.dart';
import 'package:get/get.dart';
import 'package:testvid/feature/controllers/theme_controller.dart';
import 'package:testvid/core/services/app_logger.dart';
import 'package:testvid/generated/l10n.dart';
import 'package:testvid/feature/presentation/video_trim/widgets/video_trim_header.dart';
import 'package:testvid/feature/presentation/video_trim/widgets/video_preview_card.dart';
import 'package:testvid/feature/presentation/video_trim/widgets/video_trim_controls.dart';
import 'package:testvid/feature/presentation/video_trim/widgets/video_trim_progress.dart';
import 'package:testvid/core/utils/snackbar_helper.dart';

class VideoTrimView extends StatefulWidget {
  final File videoFile;

  const VideoTrimView({
    super.key,
    required this.videoFile,
  });

  @override
  VideoTrimViewState createState() => VideoTrimViewState();
}

class VideoTrimViewState extends State<VideoTrimView> {
  late Trimmer _trimmer;
  double _startValue = 0.0;
  double _endValue = 0.0;
  bool _isPlaying = false;
  bool _progressVisibility = false;
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  void initState() {
    super.initState();
    _trimmer = Trimmer();
    _loadVideo();
  }

  void _loadVideo() async {
    // Reset values
    _startValue = 0.0;
    _endValue = 0.0;
    _isPlaying = false;

    await _trimmer.loadVideo(videoFile: widget.videoFile);
    setState(() {});
  }

  @override
  void dispose() {
    _trimmer.dispose();
    super.dispose();
  }

  Size _calculateVideoSize() {
    const double maxWidth = 315;
    const double maxHeight = 315;
    final videoPlayerController = _trimmer.videoPlayerController;
    if (videoPlayerController == null) {
      return const Size(maxWidth, maxWidth / (16 / 9));
    }

    final Size videoSize = videoPlayerController.value.size;
    final double videoAspectRatio = videoPlayerController.value.aspectRatio;
    double width = videoSize.width;
    double height = videoSize.height;

    if (width > maxWidth) {
      width = maxWidth;
      height = width / videoAspectRatio;
    }

    if (height > maxHeight) {
      height = maxHeight;
      width = height * videoAspectRatio;
    }

    // Debug logs for video dimensions
    AppLogger().debug('Video aspect ratio: $videoAspectRatio');
    AppLogger().debug('Width: $width');
    AppLogger().debug('Height: $height');

    return Size(width, height);
  }

  Future<void> _saveVideo() async {
    setState(() => _progressVisibility = true);

    try {
      // Store current values
      final double start = _startValue;
      final double end = _endValue;

      // Stop video if playing
      if (_isPlaying) {
        _isPlaying = false;
        if (_trimmer.videoPlayerController != null) {
          await _trimmer.videoPlayerController!.pause();
        }
      }

      await _trimmer.saveTrimmedVideo(
        startValue: start,
        endValue: end,
        onSave: (String? path) {
          setState(() => _progressVisibility = false);
          if (path != null) {
            Get.back(result: File(path));
          }
        },
        storageDir: null, // Will use temporary directory
        videoFileName: _generateTrimmedFileName(widget.videoFile.path),
      );
    } catch (e) {
      setState(() => _progressVisibility = false);
      AppLogger().error('Error saving video: $e');
      SnackbarHelper.showError(
        S.of(Get.context!).error,
        S.of(Get.context!).failedToSaveVideo,
      );
    }
  }

  String _generateTrimmedFileName(String originalPath) {
    final originalName = originalPath.split('/').last;
    final nameWithoutExt = originalName.replaceAll(RegExp(r'\.mp4$'), '');
    return "${nameWithoutExt}_trimmed";
  }

  @override
  Widget build(BuildContext context) {
    final isDark = themeController.isDarkMode;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF1E1E2E) : const Color(0xFFF5F5FA),
      body: SafeArea(
        child: Column(
          children: [
            VideoTrimHeader(isDark: isDark),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      VideoPreviewCard(
                        trimmer: _trimmer,
                        isDark: isDark,
                        videoSize: _calculateVideoSize(),
                      ),
                      const SizedBox(height: 20),
                      VideoTrimControls(
                        trimmer: _trimmer,
                        isDark: isDark,
                        isPlaying: _isPlaying,
                        startValue: _startValue,
                        endValue: _endValue,
                        onChangeStart: (value) => _startValue = value,
                        onChangeEnd: (value) => _endValue = value,
                        onChangePlaybackState: (value) =>
                            setState(() => _isPlaying = value),
                        onPlayPause: () async {
                          bool playbackState =
                              await _trimmer.videoPlaybackControl(
                            startValue: _startValue,
                            endValue: _endValue,
                          );
                          setState(() => _isPlaying = playbackState);
                        },
                        onSave: _saveVideo,
                        isSaving: _progressVisibility,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_progressVisibility) VideoTrimProgress(isDark: isDark),
          ],
        ),
      ),
    );
  }
}
