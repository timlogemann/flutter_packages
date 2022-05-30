import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:appinio_video_player/src/controls/fullscreen_button.dart';
import 'package:appinio_video_player/src/controls/play_button.dart';
import 'package:appinio_video_player/src/controls/progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomVideoPlayerControlBar extends StatelessWidget {
  final bool visible;
  final CustomVideoPlayerController customVideoPlayerController;
  const CustomVideoPlayerControlBar({
    Key? key,
    required this.visible,
    required this.customVideoPlayerController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      maintainAnimation: true,
      maintainState: true,
      child: Container(
        alignment: Alignment.bottomCenter,
        padding: customVideoPlayerController
            .customVideoPlayerSettings.controlBarPadding,
        decoration: customVideoPlayerController
            .customVideoPlayerSettings.controlBarDecoration,
        child: Row(
          children: [
            if (customVideoPlayerController
                .customVideoPlayerSettings.showPlayButton)
              CustomVideoPlayerPlayPauseButton(
                customVideoPlayerController: customVideoPlayerController,
              ),
            if (customVideoPlayerController
                .customVideoPlayerSettings.showDurationPlayed)
              Padding(
                padding: const EdgeInsets.only(
                  left: 5.0,
                  right: 5.0,
                ),
                child: ValueListenableBuilder<Duration>(
                  valueListenable:
                      customVideoPlayerController.videoProgressNotifier,
                  builder: ((context, progress, child) {
                    return Text(
                      getDurationAsString(progress),
                      style: customVideoPlayerController
                          .customVideoPlayerSettings.durationPlayedTextStyle,
                    );
                  }),
                ),
              ),
            Expanded(
              child: CustomVideoPlayerProgressBar(
                customVideoPlayerController: customVideoPlayerController,
              ),
            ),
            if (customVideoPlayerController
                .customVideoPlayerSettings.showDurationRemaining)
              Padding(
                padding: const EdgeInsets.only(
                  left: 5.0,
                  right: 5.0,
                ),
                child: ValueListenableBuilder<Duration>(
                  valueListenable:
                      customVideoPlayerController.videoProgressNotifier,
                  builder: ((context, progress, child) {
                    return Text(
                      "-" +
                          getDurationAsString(customVideoPlayerController
                                  .videoPlayerController.value.duration -
                              progress),
                      style: customVideoPlayerController
                          .customVideoPlayerSettings.durationRemainingTextStyle,
                    );
                  }),
                ),
              ),
            if (customVideoPlayerController
                .customVideoPlayerSettings.showFullscreenButton)
              CustomVideoPlayerFullscreenButton(
                customVideoPlayerController: customVideoPlayerController,
              )
          ],
        ),
      ),
    );
  }

  String getDurationAsString(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration > const Duration(hours: 1)) {
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    } else {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
  }
}