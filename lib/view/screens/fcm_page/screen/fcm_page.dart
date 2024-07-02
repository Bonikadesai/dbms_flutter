import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:database_management_system/view/screens/home_page/helper/fcm_helper/fcm_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FcmPage extends StatelessWidget {
  const FcmPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FCM Page"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FCMHelper.fcmHelper.fetchAllFCMData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("ERROR : ${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            QuerySnapshot<Map<String, dynamic>>? data = snapshot.data;

            List<QueryDocumentSnapshot<Map<String, dynamic>>> allData =
                data?.docs ?? [];

            return ListView.builder(
                itemCount: allData.length,
                itemBuilder: (context, index) {
                  Map data = allData[index].data();
                  return Card(
                    child: ListTile(
                      isThreeLine: true,
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage: MemoryImage(
                            Uint8List.fromList(data['image'].codeUnits)),
                      ),
                      title: Text(
                        data['name'],
                      ),
                      subtitle: Text(data['age'].toString()),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(data['date']),
                          IconButton(
                            onPressed: () {
                              FCMHelper.fcmHelper.deleteFCMData(id: data['id']);
                            },
                            icon: const Icon(
                              Icons.delete,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              FCMHelper.fcmHelper.updateFCMData(id: data['id']);
                            },
                            icon: const Icon(
                              Icons.edit,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                });
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
