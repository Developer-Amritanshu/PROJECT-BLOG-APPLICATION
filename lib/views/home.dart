import 'package:blog_application/services/crud.dart';
import 'package:blog_application/views/createblog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CrudMethods crudMethods = new CrudMethods();
  Stream blogsStream;

  Widget BlogList() {
    return Container(
      child: blogsStream != null
          ? StreamBuilder(
              stream: blogsStream,
              builder: (context, snapshot) {
                if(snapshot.data==null) return Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                );
                return ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      shrinkWrap: true,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        return BlogsTile(
                          authorName: snapshot
                              .data.documents[index].data["authorName"],
                          description:
                              snapshot.data.documents[index].data["desc"],
                          imgUrl:
                              snapshot.data.documents[index].data["imgUrl"],
                          title:
                              snapshot.data.documents[index].data["title"],
                        );
                      });
              })
          : Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    crudMethods.getData().then((result) {
      setState(() {
        blogsStream = result;       
      });
    });
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
        
      ),
      body: Container(
        margin: EdgeInsets.only(top: 15),
        child: BlogList()),
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              backgroundColor: Colors.green,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreateBlog()));
              },
              child: Icon(Icons.add),
            )
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class BlogsTile extends StatelessWidget {
  String imgUrl, title, description, authorName;
  BlogsTile(
      {@required this.authorName,
      @required this.description,
      @required this.imgUrl,
      @required this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      height: 170,
      child: Stack(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CachedNetworkImage(
                imageUrl:imgUrl,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
              )),
          Container(
            height: 170,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.black45.withOpacity(0.3),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  authorName,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
