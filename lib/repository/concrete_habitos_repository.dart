import 'package:habitue_se/database/data_service.dart';
import 'package:habitue_se/infra/client_http.dart';
import 'package:habitue_se/models/habito.dart';
import 'package:habitue_se/models/registrados_do_dia.dart';
import 'package:habitue_se/models/response/habitos_registrados_percents.dart';
import 'package:habitue_se/repository/abstract_habitos_repository.dart';
import 'package:habitue_se/shared/constants.dart';

class ConcreteHabitosRepository implements AbstractHabitosRepository {
  DataService _dataService = DataService.instance;
  
  ClientHttp _client;

  ConcreteHabitosRepository(this._client);


  @override
  Future<void> add(Habito object) async {
    
    
    await _dataService.addhabito(object);
    
  }

  @override
  Future<void> delete(int object) async {
    // await _dataService.deleteFullHabito(object);
  }
  
  @override
  Future<void> deleteByDate(int object, DateTime date) async {
    // await _dataService.deleteFullHabito(object);
  }

  @override
  Future<List<Habito>> get({Object? data}) async {
    if(data == null) return [];
    DateTime dateTime = data as DateTime;
    try {
      var response = await _client.get('$BASE_URL/habito/', queryParameters: {
      'userEmail': 'gabriel@gabriel.com',
      'todayDate': dateTime.toIso8601String().split('T')[0]
      });
      
      return (response as List).map((e) => Habito.fromJson(e)).toList();
    } catch (e) {
      
    return await _dataService.getAllHabitos();
    }

  }

  @override
  Future<void> update(int object) {
    throw UnimplementedError();
  }

  @override
  Future<List<RegistradosDoDia>> getRegistradosDoDia(int userId, String todayDate) async {
    var response = await _client.get('$BASE_URL/habitos_registrados/', queryParameters: {
      'userId' : userId,
      'todayDate' : todayDate
    });
    List<RegistradosDoDia> registrados = (response as List).map((e) => RegistradosDoDia.fromMap(e)).toList();
    return registrados;
  }

  @override
  Future<List<HabitosRegistradosPercents>> getPercentsByMonth(String startDate, String endDate) async{
    var response = await _client.get('$BASE_URL/habitos_registrados/progress-period', queryParameters: {
      'userId' : 1,
      'startDate' : startDate,
      'endDate' : endDate
    });
    List<HabitosRegistradosPercents> registrados = (response as List).map((e) => HabitosRegistradosPercents.fromJson(e)).toList();
    return registrados;
  }

  @override
  Future<void> addRegistradosDoDia(RegistradosDoDia data) async {
    await _dataService.saveRegistrosDiarios(data);
  }

}
