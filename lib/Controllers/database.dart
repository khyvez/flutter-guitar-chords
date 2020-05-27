import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:guitar/Controllers/apiHelper.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:sqflite/sqflite.dart';

class SongDatabaseProvider {

 // SongDatabaseProvider._();

  //
  //static final SongDatabaseProvider db = SongDatabaseProvider._();

  Database _database;

	static SongDatabaseProvider _databaseHelper;  


  SongDatabaseProvider._createInstance(); // Named constructor to create instance of DatabaseHelper


	factory SongDatabaseProvider() {


		if (_databaseHelper == null) {
			_databaseHelper = SongDatabaseProvider._createInstance(); // This is executed only once, singleton object

		}
		return _databaseHelper;
	}


  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await getDatabaseInstance();
    return _database;
  }

  Future<Database> getDatabaseInstance() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "Song.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version)
        
         async {
          await db.execute('PRAGMA foreign_keys = ON');

      await db.execute("CREATE TABLE Song ("

          "id integer primary key AUTOINCREMENT,"
          "idSong integer unique,"
          "title TEXT,"
          "body TEXT,"
          "artist TEXT,"
          "favorite integer default 0"
          
          ")");
      await db.execute("CREATE TABLE Chord ("
          "id integer primary key,"
          "song_id integer,"

          "name TEXT,"
           "FOREIGN KEY (song_id) REFERENCES Song (id) ON DELETE NO ACTION ON UPDATE NO ACTION"      


          ")");
 
  
    });
  }
  Future<int> allSongCount()
  async {
        final db = await database;
     int response = Sqflite.firstIntValue(await db.rawQuery("SELECT Count(id) from Song"));
      print(response);
     return response;

  }

   syncSongToDatabase(Song song) async {

    final db = await database;
    var raw = await db.insert(
      "Song",

      song.toSync(),

      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  
    return raw;
  }
  saveAndfavorite(Song song) async {

    final db = await database;
    var raw = await db.insert(
      "Song",

      song.saveAndFavorite(),

      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  
    return raw;
  }

  addSongToDatabase(Song song) async {

    final db = await database;
    var raw = await db.insert(
      "Song",

      song.toMap(),

      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  
    return raw;
  }

  addChordToDatabase(Chords chord) async {
    final db = await database;
    var raw = await db.insert(
      "Chord",
      chord.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  
    return raw;
  }
 getAllChords(int idSong) async {

    final db = await database;
    var response = await db.query("Chord", where: "idSong = ?", whereArgs: [idSong]);


  //  List<Chords> list = response.map((c) => Chords.fromMap(c)).toList();
 List<Chords> list = response.map<Chords>((json) => Chords.fromMap(json)).toList();

   //list = rest.map<Song>((json) => Song.fromJson(json)).toList();


 
   // print(list['name']);

    return list;

  }

  updateSong(Song song) async {



    final db = await database;
    var response = await db.update("Song", song.toMap(),


        where: "id = ?", whereArgs: [song.id]);

    return response;
  }
     Future<List<Song>> searchSong(String query) async {

    List<Song> list;
    var blanko = [];
       print(query);
      if(query != ''){
          
              final db = await database;
              var response = await db.rawQuery("SELECT * FROM Song where title LIKE '%$query%' or artist LIKE '%$query%' ");
             // print('DB:' + response.length.toString());
           
                  list  = response.map((c) => Song.fromMap(c, 'offline')).toList();
          print("List Size Offline: ${list.length}");
            return  list;
      }
      return [];
      

  }


  Future<Song> getSongWithId(int id) async {


    final db = await database;
    var response = await db.query("Song", where: "id = ?", whereArgs: [id]);

   // return response.isNotEmpty ? Song.fromMap(response.first) : null;

  }

  Future<List<Song>> getAllSongs() async {


    final db = await database;
    var response = await db.query("Song");

    List<Song> list = response.map((c) => Song.fromMap(c, 'offline')).toList();


   // print(list['name']);
    return list;
   //return json.decode(response.body);
  }

 Future<List<Song>> getAllFavorites() async {


    final db = await database;
    var response = await db.query("Song", where: "favorite = 1");

    List<Song> list = response.map((c) => Song.fromMap(c, 'offline')).toList();
    
    return list;
  
  }

  setFavorite(Song song) async {



    final db = await database;
    var response = await db.update("Song", song.toMap(),

        where: "id = ?", whereArgs: [song.id]);

    return response;
  }

  deleteSongWithId(int id) async {
    print(id);
    final db = await database;
    print("delete");
db.delete("Song", where: "id = ?", whereArgs: [id]);

  }

  deleteAllSongs() async {

    final db = await database;
    db.delete("Song");

  }

   Future<ChordsSaved> upsertUser(ChordsSaved chordsSaved) async {
    var count = Sqflite.firstIntValue(await _database.rawQuery("SELECT COUNT(*) FROM user WHERE username = ?", [chordsSaved.name]));
    if (count == 0) {
      chordsSaved.id = await _database.insert("sasd", chordsSaved.toMap());
    } else {
      await _database.update("Chord", chordsSaved.toMap(), where: "id = ?", whereArgs: [chordsSaved.id]);
    }

    return chordsSaved;
  }

   Future<SongSaved> upsertSongSaved(SongSaved songSaved) async {




    if (songSaved.id == null) {

      songSaved.id = await _database.insert("SongSaved", songSaved.toMap());



    } else {
      await _database.update("SongSaved", songSaved.toMap(), where: "id = ?", whereArgs: [songSaved.id]);



    }

    return songSaved;

  }

    Future<List<Chords>>fetchChordsAndSong(int songId) async {


   // List<Map> results  = await _database.query("Chord", where: "song_id = ?", whereArgs: [songId]);


  
  var results  = await _database.query("Chord", where: "song_id = ?", whereArgs: [songId]);


   List<Chords> chords = results.map((c) => Chords.fromMap(c)).toList();

  //  Chords chords = Chords.fromMap(results);
    chords[0].song = await fetchSong(songId);

    return chords;
  }
   Future<Song> fetchSong(int id) async {


    List<Map> results = await _database.query("Song", where: "id = ?", whereArgs: [id]);


    Song song = Song.fromMap(results[0], 'offline');




    return song;

  }
  

}