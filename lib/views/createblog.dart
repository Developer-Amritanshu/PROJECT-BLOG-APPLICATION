import 'dart:io';

import 'package:blog_application/services/crud.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class CreateBlog extends StatefulWidget {
  @override
  _CreateBlogState createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  File selectedImage;
  String authorName, title, desc;
  CrudMethods crudMethods = new CrudMethods();
  bool _isLoading = false;

  Future getImage() async {
    // ignore: deprecated_member_use
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      selectedImage = image;
    });
  }

  uploadBlog() async {
    if (selectedImage != null) {
      setState(() {
        _isLoading = true;
      });
      // upload image to firestore
      StorageReference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child("blogImages")
          .child("${randomAlphaNumeric(9)}.jpg");
      final StorageUploadTask task = firebaseStorageRef.putFile(selectedImage);
      var downloadUrl = await (await task.onComplete).ref.getDownloadURL();
      Map<String, String> blogMap = {
        "imgUrl": downloadUrl,
        "authorName": authorName,
        "title": title,
        "desc": desc
      };
      crudMethods.adddata(blogMap).then((result) => {
        Navigator.pop(context),
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Original",
              style: TextStyle(fontSize: 22),
            ),
            Text(
              " Blog ",
              style: TextStyle(fontSize: 22, color: Colors.green),
            ),
            Icon(
              Icons.verified,
              size: 20,
              color: Colors.blue,
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          GestureDetector(
            onTap: () {
              uploadBlog();
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.file_upload)),
          ),
        ],
      ),
      body: _isLoading
          ? Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      getImage();
                    },
                    child: selectedImage != null
                        ? Container(
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.file(
                                  selectedImage,
                                  fit: BoxFit.cover,
                                )),
                            height: 170,
                            width: MediaQuery.of(context).size.width,
                          )
                        : Container(
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            height: 170,
                            width: MediaQuery.of(context).size.width,
                            child: Icon(
                              Icons.add_a_photo,
                              color: Colors.black45,
                            ),
                          ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(hintText: "Author Name"),
                          onChanged: (val) {
                            authorName = val;
                          },
                        ),
                        TextField(
                          decoration: InputDecoration(hintText: "Title",),
                          onChanged: (val) {
                            title = val;
                          },
                        ),
                        TextField(
                          maxLines: 5,
                          decoration: InputDecoration(hintText: "Description"),
                          onChanged: (val) {
                            desc = val;
                          },
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
