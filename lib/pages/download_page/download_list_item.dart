import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import '../../constant/color_constant.dart';
import '../../widgets/app_image_assets.dart';
import 'download_page.dart';

class DownloadListItem extends StatelessWidget {
  const DownloadListItem({
    super.key,
    this.data,
    this.onTap,
    this.onActionTap,
    this.onCancel,
  });

  final ItemHolder? data;
  final Function(TaskInfo?)? onTap;
  final Function(TaskInfo)? onActionTap;
  final Function(TaskInfo)? onCancel;

  Widget? _buildTrailing(TaskInfo task) {
    if (task.status == DownloadTaskStatus.undefined) {
      return IconButton(
        onPressed: () => onActionTap?.call(task),
        constraints: const BoxConstraints(minHeight: 32, minWidth: 32),
        icon: const Icon(Icons.file_download),
        tooltip: 'Start',
      );
    } else if (task.status == DownloadTaskStatus.running) {
      return Row(
        children: [
          Text('${task.progress}%'),
          IconButton(
            onPressed: () => onActionTap?.call(task),
            icon: const Icon(
              Icons.pause_circle_outline,
            ),
            tooltip: 'Pause',
          ),
        ],
      );
    } else if (task.status == DownloadTaskStatus.paused) {
      return Row(
        children: [
          Text('${task.progress}%'),
          IconButton(
            onPressed: () => onActionTap?.call(task),
            // constraints: const BoxConstraints(minHeight: 32, minWidth: 32),
            icon: const Icon(
              Icons.play_circle_outline,
            ),
            tooltip: 'Resume',
          ),
          // if (onCancel != null)
          //   IconButton(
          //     onPressed: () => onCancel?.call(task),
          //     constraints: const BoxConstraints(minHeight: 32, minWidth: 32),
          //     icon: const Icon(Icons.cancel, color: Colors.red),
          //     tooltip: 'Cancel',
          //   ),
        ],
      );
    } else if (task.status == DownloadTaskStatus.complete) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children:   [
          // const Text('Ready', style: TextStyle(color: Colors.green)),
          Container(
            child: IconButton(
              onPressed: () => onActionTap?.call(task),
              constraints: const BoxConstraints(minHeight: 32, minWidth: 32),
              icon: const Icon(Icons.delete,size: 22,),
              tooltip: 'Delete',
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.arrow_forward_ios_outlined,size: 20,),
          ),
        ],
      );
    } else if (task.status == DownloadTaskStatus.canceled) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text('Canceled', style: TextStyle(color: Colors.red)),
          if (onActionTap != null)
            IconButton(
              onPressed: () => onActionTap?.call(task),
              constraints: const BoxConstraints(minHeight: 32, minWidth: 32),
              icon: const Icon(Icons.cancel),
              tooltip: 'Cancel',
            )
        ],
      );
    } else if (task.status == DownloadTaskStatus.failed) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text('Failed', style: TextStyle(color: Colors.red)),
          IconButton(
            onPressed: () => onActionTap?.call(task),
            constraints: const BoxConstraints(minHeight: 32, minWidth: 32),
            icon: const Icon(Icons.refresh, color: Colors.green),
            tooltip: 'Refresh',
          )
        ],
      );
    } else if (task.status == DownloadTaskStatus.enqueued) {
      return const Text('Pending', style: TextStyle(color: Colors.orange));
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: data!.task!.status == DownloadTaskStatus.complete
          ? () {
        onTap!(data!.task);
      }
          : null,
      child: Container(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Row(
          children: [
            Container(
              height: 80,
              width: 80,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AppImageAsset(
                  image: data!.imageLink!,
                  webFit: BoxFit.fill,
                  isWebImage: true,
                ),
              ), // no matter how big it is, it won't overflow
            ),
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    // height: 70,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            data!.name!,
                            maxLines: 1,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: _buildTrailing(data!.task!),
                        ),
                      ],
                    ),
                  ),
                  if (data!.task!.status == DownloadTaskStatus.running ||
                      data!.task!.status == DownloadTaskStatus.paused)
                    Padding(
                      padding:  const EdgeInsets.only(bottom: 10),
                      child: Container(
                        margin:
                        const EdgeInsets.only(right: 10),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          child: LinearProgressIndicator(
                            value: data!.task!.progress! / 100 ,
                            color: ColorConstant.appBlue,
                            minHeight: 7,
                            backgroundColor: Colors.grey, //<-- SEE HERE
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
