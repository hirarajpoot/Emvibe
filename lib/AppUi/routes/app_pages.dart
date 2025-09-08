import 'package:get/get.dart';
import 'app_routes.dart';

// Auth Screens
import '../AppScreens/Auth/SplashScreen.dart';
import '../AppScreens/Auth/LoginScreen.dart';
import '../AppScreens/Auth/SignupScreen.dart';
import '../AppScreens/Auth/ResetPasswordScreen.dart';

// Main App Screens
import '../AppScreens/DashboardScreen/dashboard_screen.dart';
import '../AppScreens/chatbot/chatbot_page.dart';
import '../AppScreens/ProfileScreen/ProfileScreen.dart';

// Profile Sub-screens
import '../AppScreens/ProfileScreen/GeneralSettings/GeneralSettingsPage.dart';
import '../AppScreens/ProfileScreen/PersonaSettingsPage.dart';
import '../AppScreens/ProfileScreen/ProductivityToolsPage/ProductivityToolsPage.dart';
import '../AppScreens/ProfileScreen/SubscriptionPage/SubscriptionPage.dart';
import '../AppScreens/ProfileScreen/SubscriptionPage/UpgradeScreen.dart';

// Notes Screens
import '../AppScreens/ProfileScreen/ProductivityToolsPage/Notes/create_note_page.dart';
import '../AppScreens/ProfileScreen/ProductivityToolsPage/Notes/delete_note_page.dart';
import '../AppScreens/ProfileScreen/ProductivityToolsPage/Notes/get_notes_page.dart';

// Reminder Screens
import '../AppScreens/ProfileScreen/ProductivityToolsPage/Reminder/Reminders_page.dart';
import '../AppScreens/ProfileScreen/ProductivityToolsPage/Reminder/Tasks/create_reminder_page.dart';
import '../AppScreens/ProfileScreen/ProductivityToolsPage/Reminder/Tasks/delete_reminder_page.dart';
import '../AppScreens/ProfileScreen/ProductivityToolsPage/Reminder/Tasks/GetRemindersPage.dart';

// Todo Screens
import '../AppScreens/ProfileScreen/ProductivityToolsPage/Todo/add_todo_page.dart';
import '../AppScreens/ProfileScreen/ProductivityToolsPage/Todo/edit_todo_page.dart';
import '../AppScreens/ProfileScreen/ProductivityToolsPage/Todo/update_todo_page.dart';
import '../AppScreens/ProfileScreen/ProductivityToolsPage/Todo/get_todos_page.dart';

// Admin Panel Screens
import '../AppScreens/Auth/Adminpanal/admin_panel_screen.dart';
import '../AppScreens/Auth/Adminpanal/ban_user_screen.dart';
import '../AppScreens/Auth/Adminpanal/manage_server_load_screen.dart';
import '../AppScreens/Auth/Adminpanal/update_knowledge_base_screen.dart';
import '../AppScreens/Auth/Adminpanal/user_analytics_screen.dart';

class AppPages {
  static final pages = [
    // Auth Routes
    GetPage(
      name: Routes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: Routes.signup,
      page: () => const SignupScreen(),
    ),
    GetPage(
      name: Routes.resetPassword,
      page: () => const ResetPasswordScreen(),
    ),
    
    // Main App Routes
    GetPage(
      name: Routes.dashboard,
      page: () => const DashboardScreen(),
    ),
    GetPage(
      name: Routes.chat,
      page: () => const ChatBotPage(),
    ),
    GetPage(
      name: Routes.profile,
      page: () => const ProfileScreen(),
    ),
    
    // Profile Sub-routes
    GetPage(
      name: Routes.generalSettings,
      page: () => const GeneralSettingsPage(),
    ),
    GetPage(
      name: Routes.personaSettings,
      page: () => const PersonaSettingsPage(),
    ),
    GetPage(
      name: Routes.productivityTools,
      page: () => const ProductivityToolsPage(),
    ),
    GetPage(
      name: Routes.subscription,
      page: () => const SubscriptionPage(),
    ),
    GetPage(
      name: Routes.upgrade,
      page: () => const UpgradeScreen(),
    ),
    
    // Notes Routes
    GetPage(
      name: Routes.createNote,
      page: () => const CreateNotePage(),
    ),
    GetPage(
      name: Routes.deleteNote,
      page: () => const DeleteNotesPage(),
    ),
    GetPage(
      name: Routes.getNotes,
      page: () => const GetNotesPage(),
    ),
    
    // Reminder Routes
    GetPage(
      name: Routes.reminders,
      page: () => const CreateReminderPage(),
    ),
    GetPage(
      name: Routes.createReminder,
      page: () => const CreateReminderTaskPage(),
    ),
    GetPage(
      name: Routes.deleteReminder,
      page: () => const DeleteReminderPage(),
    ),
    GetPage(
      name: Routes.getReminders,
      page: () => const GetRemindersPage(),
    ),
    
    // Todo Routes
    GetPage(
      name: Routes.addTodo,
      page: () => const AddTodoPage(),
    ),
    GetPage(
      name: Routes.editTodo,
      page: () => EditTodoPage(todo: Get.arguments),
    ),
    GetPage(
      name: Routes.updateTodo,
      page: () => const UpdateTodoPage(),
    ),
    GetPage(
      name: Routes.getTodos,
      page: () => const GetTodosPage(),
    ),
    
    // Admin Panel Routes
    GetPage(
      name: Routes.adminPanel,
      page: () => const AdminPanelScreen(),
    ),
    GetPage(
      name: Routes.banUser,
      page: () => const BanUserScreen(),
    ),
    GetPage(
      name: Routes.manageServerLoad,
      page: () => const ManageServerLoadScreen(),
    ),
    GetPage(
      name: Routes.updateKnowledgeBase,
      page: () => const UpdateKnowledgeBaseScreen(),
    ),
    GetPage(
      name: Routes.userAnalytics,
      page: () => const UserAnalyticsScreen(),
    ),
  ];
}
