import 'package:cloud_firestore/cloud_firestore.dart';

/// Service for Firestore database operations
class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Collection references
  CollectionReference get gamesCollection => _firestore.collection('games');

  /// Get subcollection reference for players in a game
  CollectionReference playersCollection(String gameId) =>
      gamesCollection.doc(gameId).collection('players');

  /// Generic create document
  Future<void> createDocument({
    required CollectionReference collection,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    await collection.doc(docId).set(data);
  }

  /// Generic update document
  Future<void> updateDocument({
    required CollectionReference collection,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    await collection.doc(docId).update(data);
  }

  /// Generic set document (create or overwrite)
  Future<void> setDocument({
    required CollectionReference collection,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    await collection.doc(docId).set(data);
  }

  /// Generic get document
  Future<DocumentSnapshot> getDocument({
    required CollectionReference collection,
    required String docId,
  }) async {
    return await collection.doc(docId).get();
  }

  /// Generic delete document
  Future<void> deleteDocument({
    required CollectionReference collection,
    required String docId,
  }) async {
    await collection.doc(docId).delete();
  }

  /// Generic watch document
  Stream<DocumentSnapshot> watchDocument({
    required CollectionReference collection,
    required String docId,
  }) {
    return collection.doc(docId).snapshots();
  }

  /// Generic query collection
  Future<QuerySnapshot> queryCollection({
    required CollectionReference collection,
    Query Function(CollectionReference)? queryBuilder,
  }) async {
    Query query = collection;
    if (queryBuilder != null) {
      query = queryBuilder(collection);
    }
    return await query.get();
  }

  /// Generic watch collection
  Stream<QuerySnapshot> watchCollection({
    required CollectionReference collection,
    Query Function(CollectionReference)? queryBuilder,
  }) {
    Query query = collection;
    if (queryBuilder != null) {
      query = queryBuilder(collection);
    }
    return query.snapshots();
  }

  /// Batch write operations
  WriteBatch batch() => _firestore.batch();

  /// Transaction operations
  Future<T> runTransaction<T>(
    Future<T> Function(Transaction transaction) updateFunction,
  ) async {
    return await _firestore.runTransaction(updateFunction);
  }

  /// Generate unique document ID
  String generateId([CollectionReference? collection]) {
    collection ??= _firestore.collection('temp');
    return collection.doc().id;
  }

  /// Check if document exists
  Future<bool> documentExists({
    required CollectionReference collection,
    required String docId,
  }) async {
    final doc = await collection.doc(docId).get();
    return doc.exists;
  }

  /// Get server timestamp
  FieldValue get serverTimestamp => FieldValue.serverTimestamp();

  /// Array union operation
  FieldValue arrayUnion(List elements) => FieldValue.arrayUnion(elements);

  /// Array remove operation
  FieldValue arrayRemove(List elements) => FieldValue.arrayRemove(elements);

  /// Increment operation
  FieldValue increment(num value) => FieldValue.increment(value);
}
