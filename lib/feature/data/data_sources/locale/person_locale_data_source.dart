import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '/core/error/exception.dart';

import '../../../../core/constants/locale_keys.dart';
import '/feature/data/models/person_model.dart';

abstract class PersonLocaleDataSource {
  Future<List<PersonModel>> getLastPersonsFromCache();
  Future<void> personsToCache(List<PersonModel> persons);
}

class PersonLocaleDataSourceImpl extends PersonLocaleDataSource {
  final SharedPreferences sharedPreferences;

  PersonLocaleDataSourceImpl({
    required this.sharedPreferences,
  });

  @override
  Future<List<PersonModel>> getLastPersonsFromCache() {
    final jsonPersons = sharedPreferences.getStringList(LocaleKeys.personsKey);
    if (jsonPersons != null) {
      return Future.value(jsonPersons
          .map((person) => PersonModel.formJson(json.decode(person)))
          .toList());
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> personsToCache(List<PersonModel> persons) {
    List<String> jsonPersons =
        persons.map((person) => json.encode(person.toJson())).toList();
    sharedPreferences.setStringList(LocaleKeys.personsKey, jsonPersons);
    return Future.value(jsonPersons);
  }
}
