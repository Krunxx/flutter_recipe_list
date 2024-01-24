class ApiUrls {
  // BASE URL
  static const String baseUrl = "http://192.168.254.100/recipe_api/";

  static const String register = baseUrl + "register.php";        //API ENDPOINT
  static const String addRecipe = baseUrl + "imageupload.php";    //API ENDPOINT
  static const String login = baseUrl + "login_user.php";         //API ENDPOINT
  static const String viewRecipe = baseUrl + "viewimage.php";     //API ENDPOINT
  static const String updateRecipe = baseUrl + "update_image.php";//API ENDPOINT
  static const String deleteRecipe = baseUrl + "deleteimage.php"; //API ENDPOINT
  static const String checkUser = baseUrl + "check_user.php";     //API ENDPOINT


  /*
  The static keyword is used to define class-level constants,
  which are associated with the class and can be accessed directly
  using the class name, without creating an instance of the class.
   */
}
