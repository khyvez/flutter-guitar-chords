
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:guitar/Controllers/apiHelper.dart';
import 'package:guitar/Controllers/database.dart';
import 'package:guitar/view/save.dart';
import 'package:guitar/view/showLyrics.dart';
import 'package:guitar/view/animator.dart';

import 'package:guitar/view/synco.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tip_dialog/tip_dialog.dart';
import 'package:guitar/Controllers/actions.dart';

Future<String> fetchStr(int vi) async {
  if (vi >= 1) {
     await new Future.delayed(const Duration(seconds: 6), () {});

  }
  return null;
}


class NewsListPage extends StatefulWidget {
  
  @override
  _NewsListPageState createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {

   final TextEditingController _queryController = new TextEditingController();

       ApiHelper apiHelper = ApiHelper();
      SongDatabaseProvider songDatabaseProvider = SongDatabaseProvider();
  
        int visible = 0;



  @override
  Widget build(BuildContext context) {
       return MaterialApp(
      title: 'Guitar',
      
      home: Scaffold(
        appBar:  PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child:  Container(
        padding: EdgeInsets.fromLTRB(10, 40, 10, 0),
              decoration: BoxDecoration(
              gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [Color.fromRGBO(107,14,85, 1), Colors.pinkAccent]),
            ),  
        child: 
        AppBar(
         centerTitle: true,
         flexibleSpace: Container(
           ),
          title: Form(
           
                child: TextFormField(
                    onFieldSubmitted: (_textControlr) {
                   
                   //  searchSong();
                       setState(() {
                    visible++;
                  });
                    
                    },
                     controller: _queryController,
                     style: TextStyle(
                        color: Colors.white,
                        fontSize: 20
                    ), 
                  decoration: InputDecoration(
                    
             

                    hintText: 'Search',
                    hintStyle: TextStyle(color: Colors.white),
                    suffixIcon: GestureDetector(
                         onTap: Feedback.wrapForTap(
                        _queryController.clear,
                        context,
                      ),
                      child: Icon(Icons.clear, color: Colors.white),
                    ),
                    
                  ),
               
                ),
              ),
        backgroundColor:   Color.fromRGBO(255, 255, 255, .1),
        
        )
      )
        ),
       drawer: Drawer(
    child: Container(
      color: Color.fromRGBO(38,56,89, 1),
      child:
     ListView(
      
      padding: EdgeInsets.zero,
      
      children:  <Widget>[
         Container(
          height: 100,
          
          child: 
           DrawerHeader(
          
          decoration: BoxDecoration(
                gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [Color.fromRGBO(107,14,85, 1), Colors.pinkAccent]),
          
          
          ),
          child: Text(
            'Guitar Chords',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
        ),
        ListTile(
            onTap: () 
              {
               
                Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SavedPage(),
           
                  
                ),
              );
              },
          leading: Icon(Icons.music_note, color: Colors.white,),
          title: Text('Favorite'
          ,style: TextStyle(color: Colors.white),
         
          ),
        ),
         ListTile(
          leading: Icon(Icons.settings,color: Colors.white,),
          title: Text('Settings'
          ,style: TextStyle(color: Colors.white),
          ),
        ),
        ListTile(
            onTap: () 
              {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SynchoScreen(),
           
                  
                ),
              );
             
              },
          leading: Icon(Icons.sync,color: Colors.white,),
          title: Text('Synchronize'
          ,style: TextStyle(color: Colors.white),
          ),
        ),
      ],
       )),)
    ,

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
                    child:  StringWidget(str: fetchStr(visible), vi: visible, query: _queryController.text,),
                  )
                  ),
                  
                

              ],
            ),
            );
            
          })
    )
       );
  }



}


class StringWidget extends StatelessWidget {

  final Future<String> str;
  final String query;
  final int vi;
   SongDatabaseProvider songDBP = SongDatabaseProvider();
   ActionsController actionsController = ActionsController();
  
ApiHelper apiHelper = ApiHelper();
  StringWidget({Key key, this.str, this.vi, this.query}) : super(key: key);




       Widget newListView(List<Song> song){
            return ListView.separated(
                      separatorBuilder: (context, index) => Divider(
                            color: Colors.white38
                          ),
                      itemCount: 
                      song.length == 0 
                      ? 0
                      : song.length,
                      itemBuilder: (context, position) {
                        return WidgetANimator(  
                        Slidable(
                              
                          actions: 
                              song[position].fromDB == 'online'
                                ? 
                          <Widget>[
                            
                                IconSlideAction(
                                  
                                  iconWidget: Icon(Icons.favorite, color:
                            
                                      song[position].favorite == 1
                                      ? Colors.pinkAccent
                                      :
                                    Colors.white
                                
                                    ),
                                  caption: 'Favorite',
                                  color: Colors.pinkAccent,
                                  onTap: () {
                               
                               
                                   actionsController.saveAndFavorite(song[position].id, song[position].title, song[position].bods, song[position].artist, 1);
                                         actionsController.snackBarContent("Sucesfully set to favorite", Icons.favorite, Colors.pinkAccent, context);
                                 
                                  //  songDBP.searchSong(query);
                                            
                                  }
                                ), IconSlideAction(
                                    
                                  iconWidget: Icon(Icons.save, color:
                            
                                      song[position].favorite == 1
                                      ? Colors.pinkAccent
                                      :
                                    Colors.white
                                
                                    ),
                                  caption: 'Save',
                                  color: Colors.blue,
                                  onTap: () {
                                    actionsController.saveAndFavorite(song[position].id, song[position].title, song[position].bods, song[position].artist, 0);
                                         actionsController.snackBarContent("Sucesfully saved", Icons.save, Colors.blue, context);
                                
                                 
                                    
                                  }
                                )
                                
                          ]
                          :
                          <Widget>[
                            
                                IconSlideAction(
                                  
                                  iconWidget: Icon(Icons.favorite, color:
                            
                                      song[position].favorite == 1
                                      ? Colors.pinkAccent
                                      :
                                    Colors.white
                                
                                    ),
                                  caption: 'Favorite',
                                  color: Colors.pinkAccent,
                                  onTap: () {
                                   
                                       actionsController.snackBarContent("Sucesfully set to favorite", Icons.favorite, Colors.pinkAccent, context);
                               
                                      apiHelper.setFavorite(song[position].title, song[position].bods, song[position].artist, song[position].id);
                                      //songDBP.searchSong(query);
                                            
                                  }
                                )            
                                
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
                            subtitle: Text(
                            song[position].artist != null
                            ? song[position].artist
                            :
                            ''
                            ,
                            style: TextStyle( 
                                  fontSize: 10.0,
                                    color: Colors.pinkAccent,
                                  ),
                      
                            ),
                            trailing: Column(
                              children: <Widget>[
                                
                                  Container(
                                    padding: EdgeInsets.all(3),
                                    width: 35,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      color: song[position].fromDB == 'online'
                                      ? Colors.greenAccent
                                      :
                                      Colors.grey

                                    ),
                                    
                                    child:
                                    Text(song[position].fromDB == 'online'
                                      ?'Online'
                                      : 'Offline',

                                     style: TextStyle(
                                  fontSize: 8.0,
                                    color: Colors.white,
                                  ),
                            
                                  )
                                  ),
                                    Icon(Icons.arrow_forward, color: Colors.white30,),
                                  
                              ]
                            ),
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
    return Center(
      child: FutureBuilder(
  //  future:  songDBP.searchSong(query),
     future: apiHelper.searchBOTH(query),
        builder: (context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('Search Song...');
            case ConnectionState.active:
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            case ConnectionState.done:
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else if (snapshot.hasData)
                return  newListView(snapshot.data);
              else
                return Text('Search Song...');
          }
          return Text('Search Song...'); // unreachable
        },
      ),
    );
  }
}
