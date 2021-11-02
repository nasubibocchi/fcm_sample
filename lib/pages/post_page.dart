import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcm_statenotifier/entities/post.dart';
import 'package:fcm_statenotifier/functions/firestore_model.dart';
import 'package:fcm_statenotifier/pages/token_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PostPage extends HookConsumerWidget {
  String text = '';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final textController = TextEditingController();

    final firestore = FirebaseFirestore.instance;
    final fireStoreModel = FireStoreModel();

    useEffect(() {
      ref.read(tokenProvider.notifier).getToken();
    }, const []);
    final String token = ref.watch(tokenProvider).token.toString();

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SingleChildScrollView(
            child: StreamBuilder(
                stream: firestore
                    .collection('users')
                    .doc(token)
                    .collection('post')
                    .orderBy('createdAt')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: SizedBox(),
                    );
                  } else {
                    final postList =
                        snapshot.data!.docs.map((e) => Post(e)).toList();
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: postList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            width: size.width * 0.8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              gradient: LinearGradient(
                                begin: FractionalOffset.topLeft,
                                end: FractionalOffset.bottomRight,
                                colors: [
                                  Colors.pink.withOpacity(0.5),
                                  Colors.pink.shade500.withOpacity(0.5),
                                ],
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(postList[index].text.toString()),
                            ),
                          );
                        });
                  }
                }),
          ),
          Row(
            children: [
              SizedBox(
                height: size.height * 0.1,
                width: size.width * 0.8,
                child: TextField(
                  onChanged: (value) {
                    text = value;
                  },
                  onEditingComplete: () {
                    FocusManager.instance.primaryFocus!.unfocus();
                  },
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: '文字を入力',
                    hintStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  controller: textController,
                ),
              ),
              IconButton(
                  onPressed: () {
                    fireStoreModel.addPost2FireStore(token: token, text: text);
                  },
                  icon: const Icon(Icons.send)),
            ],
          ),
        ],
      ),
    );
  }
}
