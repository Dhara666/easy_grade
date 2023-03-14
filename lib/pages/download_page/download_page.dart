// ignore_for_file: unnecessary_this

import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:easy_grade/model/course_video_model.dart';
import 'package:easy_grade/pages/play_video.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant/color_constant.dart';
import '../../shared_preference/shared_preference.dart';
import '../../utills/app_logs.dart';
import '../../widgets/app_text.dart';
import 'download_list_item.dart';
import 'package:permission_handler/permission_handler.dart';

class MyDownloadPage extends StatefulWidget with WidgetsBindingObserver {
  final String? downloadName;

  const MyDownloadPage({super.key, this.downloadName});

  @override
  MyDownloadPageState createState() => MyDownloadPageState();
}

class MyDownloadPageState extends State<MyDownloadPage> {
  List<TaskInfo>? _tasks;
  late List<ItemHolder> _items;
  late bool _permissionReady;
  late String _localPath;
  final ReceivePort _port = ReceivePort();
 int count = 0;
  @override
  void initState() {
    super.initState();

     _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback, step: 1);

    _permissionReady = false;

    _prepare();

  }

  @override
  void dispose() {
     _unbindBackgroundIsolate();
    super.dispose();
  }

  void _bindBackgroundIsolate() {
    final isSuccess = IsolateNameServer.registerPortWithName(
      _port.sendPort,
      'downloader_send_port',
    );
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      final taskId = (data as List<dynamic>)[0] as String;
      final status = data[1] as DownloadTaskStatus;
      final progress = data[2] as int;

      // print(
      //   'Callback on UI isolate: '
      //   'task ($taskId) is in status ($status) and process ($progress)',
      // );

      if (_tasks != null && _tasks!.isNotEmpty) {
        final task = _tasks!.firstWhere((task) => task.taskId == taskId);
        setState(() {
          task
            ..status = status
            ..progress = progress;
        });
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }
  //
  @pragma('vm:entry-point')
  static void downloadCallback(
    String id,
    DownloadTaskStatus status,
    int progress,
  ) {
    // logs(
    //   'Callback on background'
    //   'task ($id) is in status ($status) and process ($progress)',
    // );

    IsolateNameServer.lookupPortByName('downloader_send_port')
        ?.send([id, status, progress]);
  }


  Widget _buildDownloadListPending() {
    bool isShowTitle = false;
    return AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        shrinkWrap: true,
        // physics: const NeverScrollableScrollPhysics(),
        physics: const BouncingScrollPhysics(),
        itemCount: _items.length,
        itemBuilder: (BuildContext c, int index) {
          if (_items[index].task?.status == DownloadTaskStatus.undefined || _items[index].task?.status == DownloadTaskStatus.running || _items[index].task?.status == DownloadTaskStatus.paused || _items[index].task?.status == DownloadTaskStatus.failed)
         {
            isShowTitle = true;
            if(index > 0){
              for(int i = 0 ; i < index ;i++){
                if (_items[i].task?.status == DownloadTaskStatus.undefined || _items[i].task?.status == DownloadTaskStatus.running || _items[i].task?.status == DownloadTaskStatus.paused || _items[i].task?.status == DownloadTaskStatus.failed) {
                  isShowTitle = false;
                }
              }
            }
         }
          else {
            isShowTitle = false;
          }
          return Column(
            children: [
              if(isShowTitle) Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.grey.withOpacity(0.45),
                  width: MediaQuery.of(context).size.width,
                  child: const AppText(text: "Downloading",)),
              AnimationConfiguration.staggeredList(
                position: index,
                delay: const Duration(milliseconds: 50),
                child: SlideAnimation(
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.fastLinearToSlowEaseIn,
                  horizontalOffset: 30,
                  verticalOffset: 300.0,
                  child: FlipAnimation(
                      duration: const Duration(milliseconds: 2000),
                      curve: Curves.fastLinearToSlowEaseIn,
                      flipAxis: FlipAxis.y,
                      child: _items[index].task == null
                          ? Container()
                          : (_items[index].task?.status == DownloadTaskStatus.undefined || _items[index].task?.status == DownloadTaskStatus.running || _items[index].task?.status == DownloadTaskStatus.paused || _items[index].task?.status == DownloadTaskStatus.failed) ?
                           Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            decoration: BoxDecoration(
                                color: ColorConstant.appWhite,
                                borderRadius: BorderRadius.circular(15)),
                            child: DownloadListItem(
                              data: _items[index],
                              onTap: (task) async {
                                final success = await _openDownloadedFile(task);
                                if (!success) {
                                  ScaffoldMessenger.of(this.context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Cannot open this file'),
                                    ),
                                  );
                                }
                              },
                              onActionTap: (task) {
                                if (task.status == DownloadTaskStatus.undefined) {
                                  _requestDownload(task);
                                } else if (task.status ==
                                    DownloadTaskStatus.running) {
                                  _pauseDownload(task);
                                } else if (task.status == DownloadTaskStatus.paused) {
                                  _resumeDownload(task);
                                } else if (task.status ==
                                    DownloadTaskStatus.complete ||
                                    task.status == DownloadTaskStatus.canceled) {
                                  _delete(task);
                                } else if (task.status ==
                                    DownloadTaskStatus.failed) {
                                  _retryDownload(task);
                                }
                              },
                              onCancel: _delete,
                            ),
                      ) :
                           const SizedBox()
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDownloadList() {
   bool  isShowTitle = false;
    return AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        shrinkWrap: true,
        // physics: const NeverScrollableScrollPhysics(),
        physics: const BouncingScrollPhysics(),
        itemCount: _items.length,
        itemBuilder: (BuildContext c, int index) {
          if (_items[index].task!.status == DownloadTaskStatus.complete) {
            isShowTitle = true;
            if(index > 0){
              for(int i = 0 ; i < index ;i++){
                if (_items[i].task!.status == DownloadTaskStatus.complete) {
                  isShowTitle = false;
                }
              }
            }
          }
          else {
            isShowTitle = false;
          }
          return Column(
            children: [
              if(isShowTitle) Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.grey.withOpacity(0.45),
                  width: MediaQuery.of(context).size.width,
                  child: const AppText(text: "Downloaded",)),
              AnimationConfiguration.staggeredList(
                position: index,
                delay: const Duration(milliseconds: 50),
                child: SlideAnimation(
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.fastLinearToSlowEaseIn,
                  horizontalOffset: 30,
                  verticalOffset: 300.0,
                  child: FlipAnimation(
                      duration: const Duration(milliseconds: 2000),
                      curve: Curves.fastLinearToSlowEaseIn,
                      flipAxis: FlipAxis.y,
                      child: _items[index].task == null
                          ? Container()
                          : (_items[index].task!.status == DownloadTaskStatus.complete) ?
                        Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              decoration: BoxDecoration(
                                  color: ColorConstant.appWhite,
                                  borderRadius: BorderRadius.circular(15)),
                              child: DownloadListItem(
                                data: _items[index],
                                onTap: (task) async {
                                  final success = await _openDownloadedFile(task);
                                  if (!success) {
                                    // ignore: use_build_context_synchronously
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Cannot open this file'),
                                      ),
                                    );
                                  }
                                },
                                onActionTap: (task) {
                                  if (task.status == DownloadTaskStatus.undefined) {
                                    _requestDownload(task);
                                  } else if (task.status ==
                                      DownloadTaskStatus.running) {
                                    _pauseDownload(task);
                                  } else if (task.status == DownloadTaskStatus.paused) {
                                       _resumeDownload(task);
                                   } else if (task.status ==
                                          DownloadTaskStatus.complete ||
                                      task.status == DownloadTaskStatus.canceled) {
                                    _delete(task);
                                  } else if (task.status ==
                                      DownloadTaskStatus.failed) {
                                    _retryDownload(task);
                                  }
                                },
                                onCancel: _delete,
                              ),
                            ) : const SizedBox()
                ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNoPermissionWarning() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Grant storage permission to continue',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blueGrey, fontSize: 18),
            ),
          ),
          const SizedBox(height: 32),
          TextButton(
            onPressed: _retryRequestPermission,
            child: const Text(
              'Retry',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _retryRequestPermission() async {
    final hasGranted = await _checkPermission();

    if (hasGranted) {
      await _prepareSaveDir();
    }

    setState(() {
      _permissionReady = hasGranted;
    });
  }

  Future<void> _requestDownload(TaskInfo task) async {
    task.taskId = await FlutterDownloader.enqueue(
      url: task.link!,
      headers: {'auth': 'test_for_sql_encoding'},
      savedDir: _localPath,
      showNotification: false,
      openFileFromNotification: false,
      requiresStorageNotLow: false,
    );
  }

  Future<void> _pauseDownload(TaskInfo task) async {
    await FlutterDownloader.pause(taskId: task.taskId!);
  }

  Future<void> _resumeDownload(TaskInfo task) async {
    final newTaskId = await FlutterDownloader.resume(taskId: task.taskId!);
    task.taskId = newTaskId;
  }

  Future<void> _retryDownload(TaskInfo task) async {
    final newTaskId = await FlutterDownloader.retry(taskId: task.taskId!);
    task.taskId = newTaskId;
  }

  Future<bool> _openDownloadedFile(TaskInfo? task) {
    if (task != null) {
      Navigator.push(context, MaterialPageRoute(builder: (context)=> DefaultPlayer(videoLink: '$_localPath/${task.link?.split('/').last}', isFile: true)));
      return Future.value(true);
     // return FlutterDownloader.open(taskId: task.taskId!);
    } else {
      return Future.value(false);
    }
  }

  Future<void> _delete(TaskInfo task) async {
    await FlutterDownloader.remove(
      taskId: task.taskId!,
      shouldDeleteContent: true,
    );
    await _prepare();
    setState(() {});
  }

  Future<bool> _checkPermission() async {
    if (Platform.isIOS) {
      return true;
    }

      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }

    return false;
  }


  Future<void> _prepare() async {
    final tasks = await FlutterDownloader.loadTasks();
    if (tasks == null) {
      logs('No tasks were retrieved from the database.');
      return;
    }

    var count = 0;
    _tasks = [];
    _items = [];

    List<Video> videoList = [];
    List<Video> filterList = [];
    final prefs = await SharedPreferences.getInstance();
    List<String>? decodedRestaturantsString = prefs.getStringList(downloadList);
    if (decodedRestaturantsString != null) {
      videoList = decodedRestaturantsString
          .map((res) => Video.fromJson(json.decode(res)))
          .toList();
    }
    for (var element in videoList) {
      if (element.topicName == widget.downloadName) {
        filterList.add(element);
      }
    }

    _tasks!.addAll(
      filterList.map((image) => TaskInfo(
          name: image.title,
          link: image.videoFile,
          imageLink: image.videoThumbnail)),
    );

    for (var i = count; i < _tasks!.length; i++) {
      _items.add(ItemHolder(
          name: _tasks![i].name,
          task: _tasks![i],
          imageLink: _tasks![i].imageLink));
      count++;
    }

    for (final task in tasks) {
      for (final info in _tasks!) {
        if (info.link == task.url) {
          info
            ..taskId = task.taskId
            ..status = task.status
            ..progress = task.progress;
        }
      }
    }

    _permissionReady = await _checkPermission();

    if (_permissionReady) {
      await _prepareSaveDir();
    }
    setState(() {
    });

  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;
    final savedDir = Directory(_localPath);
    final hasExisted = savedDir.existsSync();
    if (!hasExisted) {
      await savedDir.create();
    }
  }

  Future<String?> _findLocalPath() async {
    String? externalStorageDirPath;
    // externalStorageDirPath = (await getExternalStorageDirectory())?.path;
    if (Platform.isAndroid) {
      // try {
      //   externalStorageDirPath = await AndroidPathProvider.downloadsPath;
      // } catch (e) {
        final directory = await getExternalStorageDirectory();
         externalStorageDirPath = directory?.path;
     //   }
     } else if (Platform.isIOS) {
      externalStorageDirPath =
          (await getApplicationDocumentsDirectory()).absolute.path;
    }
    return externalStorageDirPath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: ColorConstant.appWhite,
        iconTheme: const IconThemeData(
          color: ColorConstant.appBlack,
        ),
        elevation: 0.0,
        titleSpacing: 0.0,
        title: const AppText(
            text: "Downloads", fontSize: 18, textColor: ColorConstant.appBlack),
      ),
      body: Builder(
        builder: (context) {
          return _permissionReady
              ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDownloadListPending(),
                    _buildDownloadList(),
                  ],
                ),
              )
              : _buildNoPermissionWarning();
        },
      ),
    );
  }
}

class ItemHolder {
  ItemHolder({this.name, this.task, this.imageLink});

  final String? name;
  final String? imageLink;
  final TaskInfo? task;
}

class TaskInfo {
  TaskInfo({this.name, this.link, this.imageLink});

  final String? name;
  final String? link;
  final String? imageLink;

  String? taskId;
  String? videoPath;
  int? progress = 0;
  DownloadTaskStatus? status = DownloadTaskStatus.undefined;
}
