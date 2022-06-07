//ignore_for_file: constant_identifier_names

class Api {
  static const API_URL = 'https://taltech.akaver.com/api/v1/';

  static const LOGIN_URL = API_URL + 'Account/Login';
  static const REGISTER_URL = API_URL + 'Account/Register';

  static const TASKS_URL = API_URL + 'TodoTasks/';
  static const PRIORITIES_URL = API_URL + 'TodoPriorities/';
  static const CATEGORIES_URL = API_URL + 'TodoCategories/';
}
