import 'dart:convert';

//import 'package:apiapps/utils/database_helper.dart';

import 'dart:io';
import 'package:guitar/Controllers/database.dart';
import 'package:http/http.dart' as http;
//import 'package:shared_preferences/shared_preferences.dart';

class ApiHelper {
  var client = http.Client();
  SongDatabaseProvider songDatabaseProvider = SongDatabaseProvider();
  bool isLoading = false;
  int addedSong = 0;
  List<Song> _listOnline;
  List<Song> _listOffline;
  int _pilaOnline = 0;

  Future<List<Song>> fetchSong(String query) async {
    List<Song> list = [];

    try {
      String search = Uri.encodeFull(query);

      final response = await client.get(
        "http://api.guitarparty.com/v2/songs/?query=$search",
        headers: {
          'Guitarparty-Api-Key': '4a87833fefa3d9d903b8858511416ad6e715d805'
        },
      );

      if (200 == response.statusCode) {
        final responseJson = json.decode(response.body);
        var rest = responseJson["objects"] as List;

        list = rest.map<Song>((json) => Song.fromMap(json, 'online')).toList();
        print("List Size Online: ${list.length}");
        this._pilaOnline = list.length;

        return list;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    } finally {
      client.close();
    }
  }

  Future<List<Song>> searchBOTH(String query) async {
    List<Song> listFinal;
    if (query != '') {
      var offlineRes =
          await songDatabaseProvider.searchSong(query).then((onValue) {
        _listOffline = onValue;
        return onValue;
      });
      var onlineRes = await fetchSong(query).then((onValue) {
        _listOnline = onValue;
        return _listOnline;
      });

      print("Online pila1: " + this._pilaOnline.toString());
      if (this._pilaOnline != 0) {
        listFinal = onlineRes + offlineRes;

        return listFinal;
      } else {
        return offlineRes;
      }
    }
    return null;
  }

  Future<void> synchronizingDB() async {
    List<Song> list;
    final response = await http.get(
      "http://192.168.43.63:8000/getData",
      headers: {},
    );
    final responseJson = json.decode(response.body);
    var rest = responseJson["objects"] as List;
    list = rest.map<Song>((json) => Song.fromJson(json)).toList();
    print(list.length);

    for (var n in list) {
      songDatabaseProvider.syncSongToDatabase(n);

      print('Added : ${addedSong++}');
    }
  }

  Future<void> setFavorite(
      String title, String body, String artist, int id) async {
    var songinfo = Song(
        //    idSong: idSong,
        id: id,
        title: title,
        artist: artist,
        bods: body,
        favorite: 1);

    var songId = await songDatabaseProvider.setFavorite(songinfo);
  }

  Future<void> removeFavorite(String title, String body, int id) async {
    var songinfo = Song(
        //    idSong: idSong,
        id: id,
        title: title,
        bods: body,
        favorite: 0);

    var songId = await songDatabaseProvider.setFavorite(songinfo);
  }
}

class Author {
  final String name;
  final String uri;
  Author({this.name, this.uri});
  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(uri: json['uri'], name: json['name']);
  }
}

class Chords {
  final String name;
  final String imageUrl;
  int idSong;
  Song song;

  Chords({this.name, this.imageUrl, this.idSong});
  factory Chords.fromJson(Map<String, dynamic> json) {
    return Chords(imageUrl: json['image_url'], name: json['name']);
  }

  //Database
  Map<String, dynamic> toMap() => {
        "song_id": this.idSong,
        "name": this.name,
      };
  factory Chords.fromMap(Map<String, dynamic> json) {
    return Chords(
      idSong: json['id_song'],
      name: json["name"],
    );
  }
}

class Song {
  SongDatabaseProvider songDatabaseProvider = SongDatabaseProvider();
  int id;
  int favorite;
  final String bods;
  final String artist;

  final List<String> tags;
  final String title;
  final String uri;
  final List<Author> authors;
  final int songID;
  int idSong;
  String dbTitle;
  String dbBody;
  String fromDB;

  final List<Chords> chords;

  Song(
      {this.bods,
      this.tags,
      this.title,
      this.songID,
      this.uri,
      this.authors,
      this.chords,
      this.id,
      this.dbTitle,
      this.dbBody,
      this.idSong,
      this.favorite,
      this.artist,
      this.fromDB});

  factory Song.fromJson(Map<String, dynamic> json) => Song(
      bods: json['body_chords_html'],
      songID: json['id'],
      artist: json['excerpt'],
      title: json['title'],
      uri: json['uri'],
      id: json["id"],
      favorite: 0);

  List<Chords> chordsFile(int idSong) {}

  static List<String> parseTags(tagsJson) {
    List<String> tagsList = new List<String>.from(tagsJson);
    return tagsList;
  }

  static List<String> parseAuthor(authorJson) {
    List<String> authorList = new List<String>.from(authorJson);
    return authorList;
  }

//Database

  Map<String, dynamic> toSync() => {
        "idSong": this.songID,
        "title": this.title,
        "body": this.bods,
        "artist": this.artist
      };

  Map<String, dynamic> saveAndFavorite() => {
        "idSong": this.songID,
        "title": this.title,
        "body": this.bods,
        "artist": this.artist,
        "favorite": this.favorite
      };

  Map<String, dynamic> toMap() => {
        "id": this.id,
        "title": this.title,
        "body": this.bods,
        "artist": this.artist,
        "favorite": this.favorite
      };
  factory Song.fromMap(Map<String, dynamic> json, String from) => new Song(
      fromDB: from,
      id: json["id"],
      title: json["title"],
      bods: from == 'offline' ? json["body"] : json['body_chords_html'],
      artist: from == 'offline'
          ? json["artist"]
          : json['authors'][0]["name"].toString(),
      favorite: from == 'offline' ? json["favorite"] : 0);
}

class SongSaved {
  SongSaved();

  int id;
  String title;
  String body;
  int chordId;
  ChordsSaved chordsSaved;

  static final columns = ["id", "title", "body", "chordId"];

  Map toMap() {
    Map map = {
      "title": title,
      "body": body,
      "chordId": chordId,
    };

    if (id != null) {
      map["id"] = id;
    }

    return map;
  }

  static fromMap(Map map) {
    SongSaved songSaved = new SongSaved();
    songSaved.id = map["id"];
    songSaved.title = map["title"];
    songSaved.body = map["body"];
    songSaved.chordId = map["chordId"];

    return songSaved;
  }
}

class ChordsSaved {
  ChordsSaved();

  int id;
  String name;

  static final columns = ["id", "name"];

  Map toMap() {
    Map map = {
      "name": name,
    };

    if (id != null) {
      map["id"] = id;
    }

    return map;
  }

  static fromMap(Map map) {
    ChordsSaved chordsSaved = new ChordsSaved();
    chordsSaved.id = map["id"];
    chordsSaved.name = map["name"];

    return chordsSaved;
  }
}
