
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:guitar/Controllers/actions.dart';
import 'package:guitar/Controllers/apiHelper.dart';
import 'package:guitar/view/animator.dart';
import 'package:kaaawebview_flutter/webview_flutter.dart';
import 'package:guitar/Controllers/database.dart';
import 'dart:io';
import 'package:http/http.dart' show get;
import 'package:path_provider/path_provider.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:path/path.dart' as p;
//import 'package:webview_flutter/webview_flutter.dart';




class DetailScreen extends StatefulWidget {

_DetailScreen createState() => _DetailScreen();
 

}



class _DetailScreen extends State<DetailScreen> {
  WebViewController _controller;
  @override
  



  SongDatabaseProvider songDatabaseProvider = SongDatabaseProvider();
OnScrollCallback onScrollCallback;
    ApiHelper apiHelper = ApiHelper();
    ActionsController actionsController = ActionsController();
    bool dataLoaded = false;

  Widget build(BuildContext context) {
   
   final Song todo = ModalRoute.of(context).settings.arguments;



    var stylesheet = '<style>.gt-chord {color: #FF00A1; display: inline-block; cursor: pointer; line-height: normal; margin-bottom: 3px; vertical-align: bottom;} .chordline span strong { display: inline-block; line-height: 2em; position: relative; width: 0; top: -1.3em; left: 0; font: bold 80%/1 sans-serif; color: #FF00A1;} .chordline>span {position: relative; color: #fff; font-weight: 400; line-height: 2.3em;} body{ background: #263859; color: #fff;}</style>';
    String  songTitle = '<h2> ${todo.title} </h2> <br><br>';
    String js = '<script> var elements = document.getElementsByClassName("chordline"); var myFunction = function() {alert("sample");}; for (var i = 0; i < elements.length; i++) {elements[i].addEventListener("click", myFunction, false);}</script>';
    String bodyhtml = '<body>' + songTitle  + todo.bods + ' ' + stylesheet + js + '</body>';
 //       _loadHtmlFromAssets(bodyhtml);

    return Scaffold(
      appBar: AppBar(
         backgroundColor: Color.fromRGBO(23,34,59, 1),

          actions:
          todo.fromDB == 'online'
          ? 
           <Widget>[
       
             IconButton(
              icon: Icon(Icons.favorite, color: Colors.pinkAccent,),
              onPressed: () {
                 actionsController.saveAndFavorite(todo.id, todo.title, todo.bods, todo.artist, 1);
                  actionsController.snackBarContent("Sucesfully set to favorite", Icons.favorite, Colors.pinkAccent,  context);
               
              },
            ),
               IconButton(
              icon: Icon(Icons.save, color: Colors.blue,),
              onPressed: () {
            
                  actionsController.saveAndFavorite(todo.id, todo.title, todo.bods, todo.artist, 0);
                  actionsController.snackBarContent("Sucesfully saved", Icons.save, Colors.blue, context);
  
              },
            ),

          ]
          :
           <Widget>[
        
             IconButton(
              icon: Icon(Icons.favorite, color: Colors.pinkAccent,),
              onPressed: () {

                apiHelper.setFavorite(todo.title, todo.bods, todo.artist, todo.id);
               actionsController.snackBarContent("Sucesfully set to favorite", Icons.favorite, Colors.pinkAccent, context);
  
              },
            ),
   
          ],


      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(10, 20, 10, 5),
        color: Color.fromRGBO(38,56,89, 1),
      
        child: Column(

          children: <Widget>[
       
            Expanded(
              flex: 8,
              child: 
              
             Builder(builder: (BuildContext context) {
               
                return 
                 
                  WebView(
                                      
                                  initialUrl: '',
                                 javascriptMode: JavascriptMode.unrestricted, 
                                 debuggingEnabled: true,
                                onScroll: (int x, int y){
                                  print("Scroll: " + x.toString() + " " + y.toString());
                                },
                           
                                 onWebViewCreated: (WebViewController webViewController) {
                                    _controller = webViewController;
                                          _controller = webViewController ;
                                  _loadHtmlFromAssets(bodyhtml);
                                   
                                  
                              
                        
                                  },
                                 
                       
                                  
                                );
                                

         
            
                }),
            ),
            Expanded(
                  flex: 0,
                  child: Container(
                    color: Colors.white,
                  )
            )
          ],
        ),
  


      )
      
      
    );

  }

  _loadHtmlFromAssets(String bodyHtml) async {

    final String contentBase64 =
        base64Encode(const Utf8Encoder().convert(bodyHtml));
    await _controller.loadUrl('data:text/html;base64,$contentBase64');
  
  }

}