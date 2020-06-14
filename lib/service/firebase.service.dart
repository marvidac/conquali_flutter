import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  Firestore _firestore;
  CollectionReference _collection;

  FirebaseService(String nomeDocument) {
    this._firestore = Firestore.instance;
    this._collection = this._firestore.collection(nomeDocument);
  }

  Future save(DocumentSnapshot document) async {

    if(document == null) return null;

    //Verifica se existe id do Firebase para apenas alterar o document
    if(document.documentID!=null) {
      return await this._collection.document(document.documentID).setData(document.data);
    } else {
      return await this._collection.add(document.data);
    }
  }

  Future saveMap(Map map) async {
    return await this._collection.add(map);
  }



  getDocument() {
    return this._collection;
  }



}