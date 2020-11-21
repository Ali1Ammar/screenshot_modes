
class ApiService{
  static Future<List<int>> getData() async {
    await Future.delayed(Duration(milliseconds:  50));
    return [34,4,5,6,1];
  }
}