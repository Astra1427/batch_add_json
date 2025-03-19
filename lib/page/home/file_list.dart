import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FileList extends StatefulWidget {
  const FileList({super.key,required this.onFilesSelected});

  final void Function(List<PlatformFile> files) onFilesSelected;

  @override
  State<FileList> createState() => _FileListState();
}

class _FileListState extends State<FileList> {
  /// filePath
  var fileList = <PlatformFile>[];

  @override
  Widget build(BuildContext context) {
    return fileList.isEmpty
        ?  GestureDetector(
            onTap: ()async{
              debugPrint("123123");
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                allowMultiple: true,
                type: FileType.custom,
                allowedExtensions: ['txt', 'dart', 'json' ,'*'],
              );
              if(result == null){
                return;
              }
              setState(() {
                fileList .addAll(result.files);
              });
              widget.onFilesSelected(fileList);
            },
            child: const MouseRegion(
              cursor: SystemMouseCursors.click,
              child:Center(
                child: Text("请添加国际化json文件"),
              ),
          ),
        )
        : ListView.builder(
            itemCount: fileList.length,
            itemBuilder: (context, index) {

              return ListTile(
                title: Text(fileList[index].name),
                trailing: IconButton(
                    onPressed: () {
                      setState(() {
                        fileList.remove(fileList[index]);
                      });
                    },
                    icon: const Icon(Icons.delete_forever_rounded)),
              );
            });
  }
}
