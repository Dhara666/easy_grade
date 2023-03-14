
import 'dart:io';
import 'package:easy_grade/utills/app_logs.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../constant/color_constant.dart';
import 'dart:async';
import '../model/course_video_model.dart';
import '../provider/course_provider.dart';

bool isNext = false;
bool isPrevious = false;

class DefaultPlayer extends StatefulWidget {
  final String videoLink;
  final bool isFile;

  const DefaultPlayer({Key? key, required this.videoLink, required this.isFile})
      : super(key: key);

  @override
  DefaultPlayerState createState() => DefaultPlayerState();
}

class DefaultPlayerState extends State<DefaultPlayer> {
  late FlickManager flickManager;
  double playBackSpeed = 1.0;
  static const List<double> _examplePlaybackRates = <double>[
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
        videoPlayerController: widget.isFile
            ? VideoPlayerController.file(File(widget.videoLink))
            : VideoPlayerController.network(widget.videoLink));
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.appBlack,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: ColorConstant.appBlack,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              FlickVideoPlayer(
                flickManager: flickManager,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  PopupMenuButton<double>(
                    color: Colors.white,
                    initialValue: playBackSpeed,
                    tooltip: 'Playback speed',
                    onSelected: (double speed) {
                      flickManager.flickVideoManager?.videoPlayerController!
                          .setPlaybackSpeed(speed);
                      setState(() {
                        playBackSpeed = speed;
                      });
                    },
                    itemBuilder: (BuildContext context) {
                      return <PopupMenuItem<double>>[
                        for (final double speed in _examplePlaybackRates)
                          PopupMenuItem<double>(
                            value: speed,
                            child: Text('${speed}x'),
                          )
                      ];
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      child: Text(
                        '${playBackSpeed.toStringAsFixed(2).toString()}x',
                        style: TextStyle(
                            color: Colors.pink.computeLuminance() > 0.5
                                ? Colors.black
                                : Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class AnimationPlayer extends StatefulWidget {
 // List<Video>? items;
  int? videoIndex;
  AnimationPlayer({Key? key,
   // this.items,
    this.videoIndex}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AnimationPlayerState createState() => _AnimationPlayerState();
}


class _AnimationPlayerState extends State<AnimationPlayer> {
  late FlickManager flickManager;
  late AnimationPlayerDataManager dataManager;
  double playBackSpeed = 1.0;
  List<Video>? videoString;
  @override
  void initState() {
    super.initState();
    CourseProvider courseProvider = Provider.of<CourseProvider>(context, listen: false);
    videoString = courseProvider.myFilterVideoDetail;
    flickManager = FlickManager(
      videoPlayerController:
      VideoPlayerController.network(courseProvider.myFilterVideoDetail[widget.videoIndex!].videoFile!,
      ),
      onVideoEnd: () {
        // if(dataManager.currentIndex == widget.items!.length-1){
        //   isNext = false;
        // } else{
        //   isNext = true;
        // }
        // if(dataManager.currentIndex == 0) {
        //   isPrevious = false;
        // } else{
        //   isPrevious = true;
        // }
        // setState(() {});
      },
    );

     if(widget.videoIndex! == 0) {
       isPrevious = false;
       isNext = true;
    }
     else if(widget.videoIndex! == videoString!.length-1) {
      isPrevious = true;
      isNext = false;
    }
    else{
      isPrevious = true;
      isNext = true;
    }
    setState(() {});

    dataManager =
        AnimationPlayerDataManager(flickManager, context, widget.videoIndex!);
  }

  @override
  void dispose() {
    flickManager.dispose();
    isNext = false;
    isPrevious = false;
    super.dispose();
  }

  static const List<double> _examplePlaybackRates = <double>[
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.appBlack,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: ColorConstant.appBlack,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              FlickVideoPlayer(
                flickManager: flickManager,
                flickVideoWithControlsFullscreen: FlickVideoWithControls(
                  controls: AnimationPlayerLandscapeControls(
                    animationPlayerDataManager: dataManager,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  PopupMenuButton<double>(
                    color: Colors.white,
                    initialValue: playBackSpeed,
                    onSelected: (double speed) {
                      flickManager.flickVideoManager?.videoPlayerController!
                          .setPlaybackSpeed(speed);
                      setState(() {
                        playBackSpeed = speed;
                      });
                    },
                    itemBuilder: (BuildContext context) {
                      return <PopupMenuItem<double>>[
                        for (final double speed in _examplePlaybackRates)
                          PopupMenuItem<double>(
                            value: speed,
                            child: Text('${speed}x'),
                          )
                      ];
                    },
                    child:Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      child: Text(
                        '${playBackSpeed.toStringAsFixed(2).toString()}x',
                        style: TextStyle(
                            color: Colors.pink.computeLuminance() > 0.5
                                ? Colors.black
                                : Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  (isPrevious)  ?  GestureDetector(
                    onTap: () {
                      if(dataManager.currentIndex == 1) {
                        isPrevious = false;
                        isNext = true;
                      }
                      else{
                        isPrevious = true;
                        isNext = true;
                      }
                      dataManager.playPreviousVideo();
                      setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0, top: 12,bottom: 12,right: 12),
                      child: Row(
                        children: const <Widget>[
                          Icon(
                            Icons.keyboard_arrow_left,
                            size: 20,
                            color: Colors.white,
                          ),
                          Text(
                            'Previous',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ): const SizedBox(),
                  (isNext) ?  GestureDetector(
                    onTap: () {
                     //  if(dataManager.currentIndex == widget.items!.length-2) {
                       if(dataManager.currentIndex == videoString!.length-2) {
                             isPrevious = true;
                              isNext = false;
                         }
                        else{
                         isPrevious = true;
                          isNext = true;
                             }
                      dataManager.playNextVideo();
                      setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0, top: 12,bottom: 12,right: 12),
                      child: Row(
                        children: const <Widget>[
                          Text(
                            'Next',
                            style: TextStyle(color: Colors.white),
                          ),
                          Icon(
                            Icons.keyboard_arrow_right,
                            size: 20,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ) : const SizedBox()
                ],
              )
            ],
          ),
        ),
      ),
    );
    // );
  }
}

class AnimationPlayerDataManager {
  bool inAnimation = false;
  final FlickManager flickManager;
  // final List<Video> items;
  int currentIndex;
  late Timer videoChangeTimer;
  BuildContext context;

  AnimationPlayerDataManager(this.flickManager,this.context, this.currentIndex);

  playNextVideo([Duration? duration]) async {
    // if (currentIndex >= (items.length-1)) {
    //   currentIndex = -1;
    //   // Navigator.pop(context);
    //   // SystemNavigator.pop();
    // }
    CourseProvider courseProvider = Provider.of<CourseProvider>(context, listen: false);
    String nextVideoUrl = courseProvider.myFilterVideoDetail[currentIndex + 1].videoFile!;
    if (currentIndex != courseProvider.myFilterVideoDetail.length - 1) {
      currentIndex++;

      if (courseProvider.myFilterVideoDetail[currentIndex].iswatch == null) {
        await courseProvider.videoComplete(
            context, courseProvider.myFilterVideoDetail[currentIndex].id.toString(),
            topicId: courseProvider.myFilterVideoDetail[currentIndex].topicId.toString());
        final bool watch = courseProvider.myFilterVideoDetail.every((video) => video.iswatch == 1);
        if(watch){
          logs("---->watch Successfully $watch");
          await courseProvider.courseComplete(
              context, courseProvider.myFilterVideoDetail[0].topicId.toString());
        }
      }
    }

    flickManager.handleChangeVideo(VideoPlayerController.network(nextVideoUrl),
        videoChangeDuration: duration, timerCancelCallback: (bool playNext) {
          videoChangeTimer.cancel();
          if (playNext) {
            currentIndex++;
          }
        });
  }

  playPreviousVideo([Duration? duration]) async {
    // if (currentIndex == 0) {
    //   currentIndex = 0;
    // }
    //
    // else
    CourseProvider courseProvider = Provider.of<CourseProvider>(context, listen: false);
      if (currentIndex != courseProvider.myFilterVideoDetail.length-1 || currentIndex == courseProvider.myFilterVideoDetail.length-1) {
      currentIndex--;

      if (courseProvider.myFilterVideoDetail[currentIndex].iswatch == null) {
        await courseProvider.videoComplete(
            context, courseProvider.myFilterVideoDetail[currentIndex].id.toString(),
            topicId: courseProvider.myFilterVideoDetail[currentIndex].topicId.toString());
        final bool watch = courseProvider.myFilterVideoDetail.every((video) => video.iswatch == 1);
        if(watch){
          courseProvider.courseComplete(
              this.context, courseProvider.myFilterVideoDetail[0].topicId.toString());
        }
      }
    }

    String nextVideoUrl = courseProvider.myFilterVideoDetail[currentIndex].videoFile!;
    flickManager.handleChangeVideo(VideoPlayerController.network(nextVideoUrl),
        videoChangeDuration: duration, timerCancelCallback: (bool playNext) {
          videoChangeTimer.cancel();
          if (playNext) {
            currentIndex--;
          }
        });
  }

  String getCurrentVideoTitle() {
    CourseProvider courseProvider = Provider.of<CourseProvider>(context, listen: false);
    if (currentIndex != -1) {
      return courseProvider.myFilterVideoDetail[currentIndex].title!;
    } else {
      return courseProvider.myFilterVideoDetail[courseProvider.myFilterVideoDetail.length - 1].title!;
    }
  }
}


class AnimationPlayerLandscapeControls extends StatefulWidget {
  const AnimationPlayerLandscapeControls(
      {Key? key, required this.animationPlayerDataManager})
      : super(key: key);

  final AnimationPlayerDataManager animationPlayerDataManager;

  @override
  State<AnimationPlayerLandscapeControls> createState() => _AnimationPlayerLandscapeControlsState();
}

class _AnimationPlayerLandscapeControlsState extends State<AnimationPlayerLandscapeControls> {

  @override
  Widget build(BuildContext context) {
    FlickVideoManager flickVideoManager =
    Provider.of<FlickVideoManager>(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      color: Colors.transparent,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: Colors.white,
        ),
        child: IconTheme(
          data: const IconThemeData(color: Colors.white, size: 40),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[

                  (isPrevious) ?  GestureDetector(
                    onTap: () {
                      if(widget.animationPlayerDataManager.currentIndex == 1) {
                        isPrevious = false;
                        isNext = true;
                      }
                      else{
                        isPrevious = true;
                        isNext = true;
                      }
                      (widget.animationPlayerDataManager).playPreviousVideo();
                      setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0, top: 12,bottom: 12,right: 12),
                      child: Row(
                        children: const <Widget>[
                          Icon(
                            Icons.keyboard_arrow_left,
                            size: 20,
                            color: Colors.white,
                          ),
                          Text(
                            'Previous',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ) : const SizedBox(),
                  (isNext) ?
                  GestureDetector(
                    onTap: () {
                      CourseProvider courseProvider = Provider.of<CourseProvider>(context, listen: false);
                      if(widget.animationPlayerDataManager.currentIndex == courseProvider.myFilterVideoDetail.length-2) {
                        isPrevious = true;
                        isNext = false;
                      }
                      else{
                        isPrevious = true;
                        isNext = true;
                      }
                      (widget.animationPlayerDataManager).playNextVideo();
                      setState(() {});

                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0, top: 12,bottom: 12,right: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:  const <Widget>[
                          Text(
                            'Next',
                            style: TextStyle(color: Colors.white),
                          ),
                          Icon(
                            Icons.keyboard_arrow_right,
                            size: 20,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ): const SizedBox(),
                ],

              ),
              Expanded(
                child: FlickShowControlsAction(
                  child: FlickSeekVideoAction(
                    child: Center(
                      child: flickVideoManager.nextVideoAutoPlayTimer != null
                          ? FlickAutoPlayCircularProgress(
                        colors: FlickAutoPlayTimerProgressColors(),
                      )
                          : const FlickVideoBuffer(),
                    ),
                  ),
                ),
              ),
              FlickAutoHideChild(
                child: Column(
                  children: <Widget>[

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        (widget.animationPlayerDataManager).getCurrentVideoTitle(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    FlickVideoProgressBar(
                      flickProgressBarSettings:
                      FlickProgressBarSettings(height: 5),
                    ),
                    Row(
                      children: [
                        const FlickPlayToggle(size: 30),
                        const SizedBox(
                          width: 10,
                        ),
                        const FlickSoundToggle(size: 30),
                        const SizedBox(
                          width: 20,
                        ),
                        DefaultTextStyle(
                          style: const TextStyle(color: Colors.white54),
                          child: Row(
                            children: const <Widget>[
                              FlickCurrentPosition(
                                fontSize: 16,
                              ),
                              Text('/'),
                              FlickTotalDuration(
                                fontSize: 16,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        const FlickFullScreenToggle(
                          size: 30,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
