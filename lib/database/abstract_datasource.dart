class AbstractDatasource {
  Future<void> saveData(String data) async {
    throw UnimplementedError();
  }
  Future<String> loadData() async {
    throw UnimplementedError();
  }
}