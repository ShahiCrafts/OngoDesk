class ApiConstant {
  ApiConstant._();

  static const connectionTimeoutDuration = Duration(seconds: 1000);
  static const recieveTimeoutDuration = Duration(seconds: 1000);

  static const String serverUri = 'http://192.168.1.7:8080';

  static const String baseUrl = '$serverUri/api/';

  // To authenticate user and support logging in.
  static const String login = 'auth/login';

  // To send, verify otp and register an user account.
  static const String sendOtpCode = 'auth/send-verification-code';
  static const String verifyOtpCode = 'auth/verify-code';
  static const String register = 'auth/register';

  // To create, update, report, and delete a post.
  static const String createPost = 'posts/create';
  static const String deletePost = 'posts/delete/:id';
  static const String updatePost = 'posts/update/:id';
  static const String getPostById = 'posts/fetch/:id';
  static const String getAllPosts = 'posts/fetch/all';
  static const String flagReported = 'posts/:id/report';

  // To fetch, admin created tags.
  static const String fetchTags = 'admin/tags/fetch/all';
  static const String updateTags = 'admin/tags/update/:id';

  static const String fetchCategories = 'admin/categories/fetch/all';
}
