class Routes {
  // Auth Routes
  static const splash = '/';
  static const login = '/login';
  static const signup = '/signup';
  static const resetPassword = '/reset-password';
  
  // Main App Routes
  static const dashboard = '/dashboard';
  static const chat = '/chat';
  static const profile = '/profile';
  
  // Profile Sub-routes
  static const generalSettings = '/profile/general-settings';
  static const personaSettings = '/profile/persona-settings';
  static const productivityTools = '/profile/productivity-tools';
  static const subscription = '/profile/subscription';
  static const upgrade = '/profile/subscription/upgrade';
  
  // Productivity Tools Sub-routes
  static const notes = '/profile/productivity-tools/notes';
  static const createNote = '/profile/productivity-tools/notes/create';
  static const deleteNote = '/profile/productivity-tools/notes/delete';
  static const getNotes = '/profile/productivity-tools/notes/get';
  
  static const reminders = '/profile/productivity-tools/reminders';
  static const createReminder = '/profile/productivity-tools/reminders/create';
  static const deleteReminder = '/profile/productivity-tools/reminders/delete';
  static const getReminders = '/profile/productivity-tools/reminders/get';
  
  static const todos = '/profile/productivity-tools/todos';
  static const addTodo = '/profile/productivity-tools/todos/add';
  static const editTodo = '/profile/productivity-tools/todos/edit';
  static const updateTodo = '/profile/productivity-tools/todos/update';
  static const getTodos = '/profile/productivity-tools/todos/get';
  
  // Admin Panel Routes
  static const adminPanel = '/admin/panel';
  static const banUser = '/admin/ban-user';
  static const manageServerLoad = '/admin/manage-server-load';
  static const updateKnowledgeBase = '/admin/update-knowledge-base';
  static const userAnalytics = '/admin/user-analytics';
}
