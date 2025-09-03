import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../Controllers/Adminpanal/update_knowledge_base_controller.dart';

class UpdateKnowledgeBaseScreen extends StatelessWidget {
  const UpdateKnowledgeBaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateKnowledgeBaseController());

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: Text(
          "Update Knowledge Base",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1A237E),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(
        () {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.articles.isEmpty) {
            return const Center(child: Text("No articles found."));
          }
          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: controller.articles.length,
            itemBuilder: (context, index) {
              final article = controller.articles[index];
              return Card(
                elevation: 2,
                margin: EdgeInsets.symmetric(vertical: 8.h),
                child: ListTile(
                  title: Text(article['title']),
                  subtitle: Text(article['content'], maxLines: 2, overflow: TextOverflow.ellipsis),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showArticleForm(context, controller, article),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => controller.deleteArticle(article['id']),
                      ),
                    ],
                  ),
                  onTap: () => _showArticleForm(context, controller, article),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showArticleForm(context, controller),
        backgroundColor: const Color(0xFF1A237E),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showArticleForm(BuildContext context, UpdateKnowledgeBaseController controller, [Map<String, dynamic>? article]) {
    final titleController = TextEditingController(text: article?['title']);
    final contentController = TextEditingController(text: article?['content']);

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: SingleChildScrollView( // 🔹 Yahan SingleChildScrollView add kiya gaya hai
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                article == null ? "Add New Article" : "Edit Article",
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: const Color(0xFF1A237E)),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r))),
              ),
              SizedBox(height: 15.h),
              TextField(
                controller: contentController,
                decoration: InputDecoration(labelText: 'Content', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r))),
                maxLines: 5,
              ),
              SizedBox(height: 20.h),
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
                    controller.saveArticle(
                      id: article?['id'],
                      title: titleController.text,
                      content: contentController.text,
                    );
                    Get.back();
                  } else {
                    Get.snackbar('Error', 'Please fill all fields.');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A237E),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                ),
                child: Text(article == null ? "Add Article" : "Save Changes", style: TextStyle(fontSize: 16.sp)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}