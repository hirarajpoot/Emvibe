import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateKnowledgeBaseController extends GetxController {
  final articles = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchArticles();
  }

  // 🔹 Fetch all articles from Firestore
  Future<void> fetchArticles() async {
    isLoading.value = true;
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('knowledge_base').get();
      articles.value = querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'title': doc['title'],
          'content': doc['content'],
        };
      }).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch articles: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // 🔹 Add or update an article
  Future<void> saveArticle({String? id, required String title, required String content}) async {
    try {
      if (id == null) {
        // Add a new article
        await FirebaseFirestore.instance.collection('knowledge_base').add({
          'title': title,
          'content': content,
          'createdAt': FieldValue.serverTimestamp(),
        });
        articles.refresh(); // 💡 Yahan refresh add kiya gaya hai
        Get.snackbar('Success', 'Article added successfully!', backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        // Update an existing article
        await FirebaseFirestore.instance.collection('knowledge_base').doc(id).update({
          'title': title,
          'content': content,
          'updatedAt': FieldValue.serverTimestamp(),
        });
        Get.snackbar('Success', 'Article updated successfully!', backgroundColor: Colors.green, colorText: Colors.white);
      }
      fetchArticles(); // Refresh the list after any change
    } catch (e) {
      Get.snackbar('Error', 'Failed to save article: $e');
    }
  }

  // 🔹 Delete an article
  Future<void> deleteArticle(String id) async {
    try {
      // 💡 Document ko delete karne se pehle get() call kiya gaya hai taake deletion ki confirmation ho
      final docRef = FirebaseFirestore.instance.collection('knowledge_base').doc(id);
      await docRef.get(); // Ensure the document exists before deleting
      await docRef.delete();
      articles.removeWhere((article) => article['id'] == id);
      articles.refresh(); // 💡 Yahan refresh add kiya gaya hai
      Get.snackbar('Success', 'Article deleted successfully!', backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete article: $e');
    }
  }
}