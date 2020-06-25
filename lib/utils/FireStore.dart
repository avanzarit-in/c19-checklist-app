import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class FireStore {
  ///Making the class singleton
  static FireStore _instance = FireStore.internal();
  FireStore.internal();
  factory FireStore() => _instance;

  Future getDocumentFromCollectionWithParams(
      String paramName, String coll) async {
    var doc = await Firestore.instance.collection(coll).getDocuments();
    return doc;
  }

  ///[data] argument is of type Object i.e Map in flutter
  ///Add a new document
  Future addData(data, collection) async {
    try {
      final docRef = await Firestore.instance.collection(collection).add(data);
      return docRef;
    } on PlatformException {
      return false;
    }
  }

  ///[data] argument is single param used for fetching data
  ///Fetch a single data
  Future getDataFromSingleClause(data, clauseName, collection) async {
    try {
      CollectionReference col = Firestore.instance.collection(collection);
      Query qry = col.where(clauseName.toString(), isEqualTo: data);
      return await qry.getDocuments();
    } on PlatformException {
      return false;
    }
  }
}
