class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://rickandmortyapi.com/api/character/';

  static String getAllPersonUrl(int page) {
    return "$baseUrl?page=$page";
  }
  static String searchPersonUrl(String query) {
    return "$baseUrl?name=$query";
  }
}