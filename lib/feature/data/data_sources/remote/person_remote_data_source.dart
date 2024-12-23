import 'dart:convert';

import '/core/constants/api_constants.dart';
import '/core/constants/status_code.dart';
import '/core/error/exception.dart';

import '/feature/data/models/person_model.dart';
import 'package:http/http.dart' as http;

abstract class PersonRemoteDataSource {
  /// Calls the https://rickandmortyapi.com/api/character/?page=1 endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<PersonModel>> getAllPerson(int page);

  /// Calls the https://rickandmortyapi.com/api/character/?name=rick endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<PersonModel>> searchPerson(String query);
}

class PersonRemoteDataSourceImpl implements PersonRemoteDataSource {
  final http.Client client;

  PersonRemoteDataSourceImpl({required this.client});

  @override
  Future<List<PersonModel>> getAllPerson(int page) =>
      _getPersonFromUrl(ApiConstants.getAllPersonUrl(page));

  @override
  Future<List<PersonModel>> searchPerson(String query) =>
      _getPersonFromUrl(ApiConstants.searchPersonUrl(query));

  Future<List<PersonModel>> _getPersonFromUrl(String url) async {
    final response = await client.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      final decode = json.decode(response.body);
      return (decode['results'] as List)
          .map((person) => PersonModel.formJson(person))
          .toList();
    } else {
      throw ServerException();
    }
  }
}
