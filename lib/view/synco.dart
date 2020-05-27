
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:guitar/Controllers/apiHelper.dart';
import 'package:guitar/view/animator.dart';

import 'package:guitar/Controllers/database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:path/path.dart' as p;


class SynchoScreen extends StatefulWidget {

  @override
  _SynchoScreenState createState() => _SynchoScreenState();


}
class  _SynchoScreenState extends State<SynchoScreen>  with TickerProviderStateMixin{
 AnimationController _controller;
 ApiHelper apiHelper = ApiHelper();
 SongDatabaseProvider songDatabaseProvider = SongDatabaseProvider();
  @override

void initState()
{
  _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 5000));
 getAllCount();
  super.initState();

}
 
  @override

void dispose()
{
  _controller.dispose();
  super.dispose();
}

 syncDB()
{
  print("sample");
  _controller.repeat();
  apiHelper.synchronizingDB();

}
int _ab;
Future<String> getAllCount() 
async {
  await songDatabaseProvider.allSongCount().then((nValue){
  setState(() {
    
    _ab =  nValue;
  });
  
 //   print(_ab);
   });
   return _ab.toString();



}         
String _incr;
String incrementVal()
{
  //setState(() {
     _incr =   apiHelper.addedSong.toString();
 // });
  print(_incr);
   return _incr;

} 
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
         backgroundColor: Color.fromRGBO(23,34,59, 1),
         
          
      ),
      body:
      Container(
        padding: EdgeInsets.fromLTRB(10, 20, 10, 5),
       color: Color.fromRGBO(38,56,89, 1),
       alignment: Alignment.center,
        child: Column(

          children: <Widget>[
            Card(
              child: Container( 
                    color: Color.fromRGBO(23,34,59, 1),
                    width: 500,
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Column(
                   
                      children: <Widget>[ 
                          RotationTransition(turns: Tween(begin: 0.0, end: 1.0).animate(_controller)
                          ,child:     IconButton(icon: Icon(Icons.sync, color: Colors.white),color: Colors.white, iconSize: 100, onPressed:  syncDB ),
                         
                          ),
                         ListTile(
                            
                            title: Text(
                            "Synchronizing... ",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white60,
                            
                            ),

                          ),
                          subtitle: Text(
                            incrementVal()
                            ,
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.white
                            ),),

                       ),
                      ]
                    ),
              ),
            
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 20, 20, 20),
              child: Column(children: <Widget>[
                ListTile(
                     leading: Icon(Icons.sync, color: Colors.white,),
                  title: Text(
                  "Date of Last Synchonization ",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white60
                  ),

                ),
                subtitle: Text("April 07, 2020",
                 style: TextStyle(
                    fontSize: 17,
                    color: Colors.white
                  ),),

                ),
                Divider(
                  color: Colors.white,
                  thickness: 0.5,
                ),
                   ListTile(
                     leading: Icon(Icons.music_note, color: Colors.white,),
                  title: Text(
                  "Available Song",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white60
                  ),
                  
                ),
                   subtitle: Text( _ab.toString(),
                 style: TextStyle(
                    fontSize: 17,
                    color: Colors.white
                  ),),

                ),
                

              ],)
            )
            
          
            
       
            
          ],
        )
        
        
      ),

    );

  }

}