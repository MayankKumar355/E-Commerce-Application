class ApiConnection {

  //web
 // static const String baseUrl = "http://127.0.0.1:5000";


  //mobile
  static const String baseUrl = "http://192.168.1.29:5000";

  //auth login signup
  static const String registerUrl = "${baseUrl}/api/auth/register";
  static const String loginUrl = "${baseUrl}/api/auth/login";

  //auth forget password
  static const String forgetPasswordUrl = "${baseUrl}/api/auth/forget-password";

  //auth resetPassword and verify email and resend verification email
  static const String resetPasswordUrl = "${baseUrl}/api/auth/reset-password";
  static const String verifyEmailUrl = "${baseUrl}/api/auth/resend-verification";
  static const String resendVerificationUrl = "${baseUrl}/api/auth/verify-email";

  //category
  static const String categoryUrl = "${baseUrl}/api/categories/create";
  static const String categoryAllUrl = "${baseUrl}/api/categories/all";
  static const String categoryFeaturedUrl = "${baseUrl}/api/categories/featured";
  static const String subCategoryProductsUrl = "${baseUrl}/api/categories/products/";

  //Baner
  static const String bannerActiveUrl = "${baseUrl}/api/banners/active";
  static const String bannerCreatedUrl = "${baseUrl}/api/banners/create";

  //Brand
  static const String getAllBrandsUrl = "${baseUrl}/api/brands/";
  static const String getFeaturedBrandsUrl = "${baseUrl}/api/brands/featured";
  static const String createBrandUrl = "${baseUrl}/api/brands/";

  //Products
  static const String productCreateUrl = "${baseUrl}/api/products/create";//post
  static const String productPopularUrl = "${baseUrl}/api/products/popular"; //get

  // address
  static const String addressAddUrl = "${baseUrl}/api/addresses/add";
  static const String addressAllUrl = "${baseUrl}/api/addresses/all";
  static const String addressFetchUrl = "${baseUrl}/api/addresses/toggle-select";

  //orders
  static const String ordersCreateUrl = "${baseUrl}/api/orders/";
  static const String ordersFetchUrl = "${baseUrl}/api/orders/";









}
