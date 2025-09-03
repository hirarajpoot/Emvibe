import 'package:flutter/material.dart'; // 🔹 Yahan 'material.dart' import kiya gaya hai
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BanUserController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final RxList<Map<String, dynamic>> searchResults = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Jab search bar mein kuch type ho, to search function call karen
    ever(searchController.obs, (callback) {
      if (searchController.text.isNotEmpty) {
        searchUsers(searchController.text);
      } else {
        searchResults.clear();
      }
    });
  }

  // 🔹 Firebase se user ko search karne ka function
  Future<void> searchUsers(String query) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isGreaterThanOrEqualTo: query)
          .where('email', isLessThanOrEqualTo: query + '\uf8ff')
          .get();

      searchResults.value = querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'email': doc['email'],
          'isBanned': doc.data().containsKey('isBanned') ? doc['isBanned'] : false,
        };
      }).toList();
    } catch (e) {
      errorMessage.value = 'Failed to search users: $e';
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  // 🔹 User ko ban ya unban karne ka function
  Future<void> toggleUserBanStatus(String userId, bool isBanned) async {
    isLoading.value = true;
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'isBanned': !isBanned,
      });

      // UI ko update karne ke liye searchResults list ko update karen
      final index = searchResults.indexWhere((user) => user['id'] == userId);
      if (index != -1) {
        searchResults[index]['isBanned'] = !isBanned;
        searchResults.refresh();
      }

      Get.snackbar(
        'Success',
        !isBanned ? 'User has been banned.' : 'User has been unbanned.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      errorMessage.value = 'Failed to update user status: $e';
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }
}