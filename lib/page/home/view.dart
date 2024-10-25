import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'file_list.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<PlatformFile> files = [];
  late TextEditingController trailController;
  late TextEditingController keyController;
  late TextEditingController jsonController;

  @override
  void initState() {
    super.initState();
    trailController = TextEditingController();
    keyController = TextEditingController();
    jsonController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Batch Add Json (批量导入json)'),
      ),
      body: Row(
        children: [
          Expanded(
              flex: 4,
              child: Container(
                color: Colors.blue,
                child: FileList(onFilesSelected: (files) {
                  this.files = files;
                }),
              )),
          Expanded(
              flex: 6,
              child: Container(
                color: Colors.white70,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: TextField(
                          controller: trailController,
                          decoration: const InputDecoration(
                            hintText: '请输入每个json文件末尾相同的字符串',
                          ),
                        )),
                        Expanded(child: TextField(
                          controller: keyController,
                          decoration: const InputDecoration(
                            hintText: '请输入添加的key',
                          ),
                        )),
                      ],
                    ),
                    const Divider(),
                    Expanded(
                        child: CupertinoTextField(
                      controller: jsonController,
                      maxLines: 100,
                      placeholder: '请输入json',
                    )),
                    TextButton(onPressed: () async{

                      var insertMap = jsonDecode(jsonController.text);

                      for (var file in files) {
                        var f = file.xFile;
                        var rawJson = await f.readAsString();
                        var index = rawJson.lastIndexOf(trailController.text);
                        String updatedContent = '${rawJson.substring(0, index)}  "${keyController.text}": "${insertMap[file.name.split('.')[0].replaceAll('"', '')]}",\n${rawJson.substring(index)}';
                        var write = File(f.path);
                        await write.writeAsString(updatedContent);
                      }
                      showDialog(context: context, builder: (context){
                        return AlertDialog(
                          title: const Text('提示'),
                          content: const Text('操作成功'),
                          actions: [
                            TextButton(onPressed: (){
                              Navigator.of(context).pop();
                            }, child: const Text('确认'))
                          ],
                        );
                      });
                    }, child: const Text('添加'))
                  ],
                ),
              )),
        ],
      ),
    );
  }
}