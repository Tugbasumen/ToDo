import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

class TaskRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath = "tasks";

  Stream<List<Task>> getTasks() {
    return _firestore
        .collection(collectionPath)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Task.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<void> addTask(Task task) async {
    // Firestore otomatik ID oluşturacak
    final docRef = await _firestore
        .collection(collectionPath)
        .add(task.toMap());
    // İsteğe bağlı: task objesinin id alanını Firestore ID ile güncelle
    await docRef.update({'id': docRef.id});
  }

  Future<void> updateTask(Task task) async {
    await _firestore
        .collection(collectionPath)
        .doc(task.id)
        .update(task.toMap());
  }

  Future<void> deleteTask(String taskId) async {
    await _firestore.collection(collectionPath).doc(taskId).delete();
  }
}
