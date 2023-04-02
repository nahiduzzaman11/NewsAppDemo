import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_api/model/news_model.dart';
import 'package:news_api/provider/news_provider.dart';
import 'package:news_api/screen/news_details.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String sortBy="publishedAt";
  int pageNo=1;

  @override
  Widget build(BuildContext context) {

    var newsProvider=Provider.of<NewsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        centerTitle: true,
        title: Text("News App"),
        leading: Icon(Icons.menu),
        actions: [IconButton(onPressed: () {},
            icon: Icon(Icons.search))],
      ),

      body: Container(
          padding: EdgeInsets.all(20),
          width: double.infinity,
          child: ListView(
            children: [
              Container(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    ElevatedButton(onPressed: (){
                      if(pageNo==1){
                        return null;
                      }else{
                        setState(() {
                          pageNo-=1;
                        });
                      }

                    }, child:Text("Prev"),),
                    ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      shrinkWrap: true,
                      itemBuilder: (context,index){
                        return InkWell(onTap: (){
                          setState(() {
                            pageNo =index+1;
                          });
                        }, child: Expanded(
                          child: Container(
                            color:pageNo==index+1? Colors.blueGrey[900] :Colors.blue,
                            padding: const EdgeInsets.all(14.0),
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text("${index+1}",style: TextStyle(color: Colors.white),),
                              ],
                            ),
                          ),
                        ));
                      },
                    ),
                    ElevatedButton(onPressed: (){
                      if(pageNo <5){
                        setState(() {
                          pageNo+=1;
                        });
                      }
                    }, child:Text("Next",style: TextStyle(color: Colors.white),),),

                  ],
                ),
              ),
              SizedBox(height: 10,),

              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 30,
                  padding: EdgeInsets.all(5),
                  color: Colors.blueGrey[900],
                  child: DropdownButton(
                    isDense: false,
                    dropdownColor: Colors.blueGrey[900],
                    value: sortBy,
                    items: [
                      DropdownMenuItem(child: Text("relevancy",style: TextStyle(color: Colors.white,fontSize: 12),),
                        value: "relevancy",
                      ),
                      DropdownMenuItem(child: Text("popularity",style: TextStyle(color: Colors.white,fontSize: 12),),
                        value: "popularity",
                      ),
                      DropdownMenuItem(child: Text("publishedAt",style: TextStyle(color: Colors.white,fontSize: 12),),
                        value: "publishedAt",
                      ),
                    ],

                    onChanged: ( String? value){
                      setState(() {
                        sortBy=value!;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 15,),

              FutureBuilder <NewsModel>(
                future:newsProvider.getHomeData(pageNo,sortBy) ,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Text("Something is wrong");
                  } else if (snapshot.data == null) {
                    return Text("snapshot data are null");
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.articles!.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>NewsDetails(
                            articles: snapshot.data!.articles![index],
                          )));
                        },
                        child: Card(
                          color: Colors.blueGrey[900],
                          child: Container(
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 0, top: 0,
                                  child: Container(
                                    height: 50,width: 10,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                                Positioned(
                                  right: 0,bottom: 0,
                                  child: Container(
                                    height: 50,width: 10,
                                    color: Colors.blueAccent,
                                  ),),
                                Positioned(
                                  left: 0, top: 0,
                                  child: Container(
                                    height: 10,width: 50,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                                Positioned(
                                  right: 0,bottom: 0,
                                  child: Container(
                                    height: 10,width: 50,
                                    color: Colors.blueAccent,
                                  ),),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex:3,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(6),
                                          child:CachedNetworkImage(
                                            imageUrl: "${snapshot.data!.articles![index].urlToImage}",height: 120,fit: BoxFit.cover,
                                            placeholder: (context, url) => CircularProgressIndicator(),
                                            errorWidget: (context, url, error) => Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTOmYqa4Vpnd-FA25EGmYMiDSWOl9QV8UN1du_duZC9mQ&s",height: 120,),
                                          ),
                                          //Image(image: NetworkImage("${snapshot.data!.articles![index].urlToImage}",))
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Expanded(
                                          flex: 10,
                                          child:Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "${snapshot.data!.articles![index].title}",maxLines: 2,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),

                                              SizedBox(height: 5,),
                                              Text(
                                                "${snapshot.data!.articles![index].author}",style: TextStyle(color: Colors.white),),

                                              SizedBox(height: 2,),
                                              Text(
                                                  "${snapshot.data!.articles![index].publishedAt}",style: TextStyle(color: Colors.white),)
                                            ],
                                          )
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              )
            ],
          )),
    );
  }
}
