
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:guitar/Controllers/actions.dart';
import 'package:guitar/Controllers/apiHelper.dart';
import 'package:guitar/Controllers/database.dart';
import 'package:guitar/view/showLyrics.dart';
import 'package:guitar/view/savelyrics.dart';
import 'package:guitar/view/animator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
class SavedPage extends StatefulWidget {
  
  @override
  _SavedPageState createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {

ApiHelper apiHelper = ApiHelper();
SongDatabaseProvider songDatabaseProvider = SongDatabaseProvider();
ActionsController actionsController = ActionsController();

Widget newListView(List<Song> song){
return ListView.separated(
          separatorBuilder: (context, index) => Divider(
                color: Colors.white38
              ),
          itemCount: song.length,
          itemBuilder: (context, position) {
       
             return WidgetANimator(  
             Slidable(
              actions: <Widget>[
                IconSlideAction(
                  
                  iconWidget: Icon(Icons.remove_circle_outline, color:Colors.pinkAccent) ,
                  caption: 'Remove',
                  color: Colors.blue,
                  onTap: () {
                    setState(() {
                         apiHelper.removeFavorite(song[position].title, song[position].bods, song[position].id);
                          actionsController.snackBarContent("Sucesfully removed to favorite", Icons.favorite, Colors.grey, context);
                                 
                       songDatabaseProvider.getAllFavorites();     
                      
                    });
                  }
                ),
              ],
         
              child: ListTile(
                leading: Icon(Icons.library_music, color: Colors.white,),
                title: Text(
                
                   song.length != 0 
                  ?
                  '${song[position].title}'
                  :
                  'Not Found',
               
                  style: TextStyle(
                      fontSize: 15.0,
                         color: Colors.white60,
                      fontWeight: FontWeight.bold),
                
                ),
                subtitle: Text( song[position].artist != null
                            ?  '${song[position].artist}'
                            :
                            '',
                 style: TextStyle( 
                      fontSize: 10.0,
                         color: Colors.pinkAccent,
                      ),
          
                ),
                trailing: Icon(Icons.arrow_forward, color: Colors.white30,),
                onTap: () {
                    Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(),
           
                  settings: RouteSettings(
                    arguments: song[position],
                  ),
                  
                ),
                
              );
                },
              ),
              
              actionPane: SlidableDrawerActionPane(),
            )
             );
          });
 
}



  @override
  Widget build(BuildContext context) {
       return Scaffold(
       appBar: AppBar(
         backgroundColor: Color.fromRGBO(23,34,59, 1),
         leading: Icon(Icons.favorite, color: Colors.pinkAccent),
         title: Text("Favorites"),
      ),
       
      body: new Builder(
        
          builder: (BuildContext context) {
            
            return Container(
                   decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/bg.png"), fit: BoxFit.cover)),
             // color: Color.fromRGBO(23,34,59, 1),
              child: Column(
              
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
               
                Expanded(
                  flex: 8,
                  child: Container(
                            color: Color.fromRGBO(38,56,89, .8),
                               child: 
                   _futureBuilder(),
                  )
                  ),
                  
                

              ],
            ),
            );
            
          })
    );
       
  }

  


 FutureBuilder _futureBuilder(){
    return FutureBuilder(
          future: songDatabaseProvider.getAllFavorites(),
          builder: (context, snapshot) {
            
            return snapshot.data != null
                ? newListView(snapshot.data)
                : _centerLoading();
          });

  }
Center _centerLoading(){

  return Center(child: CircularProgressIndicator());

}

}

