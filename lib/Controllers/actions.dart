


import 'package:guitar/Controllers/apiHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:guitar/Controllers/database.dart';


class ActionsController{

SongDatabaseProvider songDatabaseProvider = SongDatabaseProvider();
void showDialogSuccess(String _msgResponse, BuildContext context){
  
     showGeneralDialog(
       
    barrierColor: Colors.black.withOpacity(0.5),
    transitionBuilder: (context, a1, a2, widget) {
      final curvedValue = Curves.easeInOutBack.transform(a1.value) -   1.0;
      return Transform(
        transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
        child: Opacity(
          opacity: a1.value,
          child: AlertDialog(
            backgroundColor: Color.fromRGBO(92, 184, 92, 0.9),
              
            shape: OutlineInputBorder(
              
                borderRadius: BorderRadius.circular(16.0)
                
                ),
                title: Text(
                  'Loading', style: new TextStyle(
                  color: Colors.white
                ),),
                  content: Text(_msgResponse, style: new TextStyle(
                color: Colors.white70
              ),),
          ),
        ),
      );
    },
    transitionDuration: Duration(milliseconds: 1000),
    barrierDismissible: true,
    
    barrierLabel: '',
    context: context,
   
    pageBuilder: (BuildContext context, animation1, animation2) {});
   }

   
void snackBarContent(String msg, IconData icond, Color colorIcon, BuildContext context){
  
    final snackBar = SnackBar(content: 
                                       Container(
                                         height:50,
                                        
                                         child:
                                          Column(
                                            
                                        
                                          children: <Widget>[
                                            Icon(icond, color: colorIcon),
                                            Text(msg),

                                          ]
                                        )
                                       )
                                        
                  );
 
                                       
 Scaffold.of(context).showSnackBar(snackBar);
  
}


saveAndFavorite(int songId, String title, String bods, String artist, int favorite)
{
  var saveInfo= Song(
  songID: songId,
  title: title,
  bods: bods,
  artist: artist,
  favorite: favorite
  );
  
   songDatabaseProvider.saveAndfavorite(saveInfo);
               
}
}