import 'package:dartz/dartz.dart';

import '/core/error/exception.dart';
import '/core/error/failure.dart';
import '/core/platform/network_info.dart';
import '/feature/data/data_sources/locale/person_locale_data_source.dart';
import '/feature/data/data_sources/remote/person_remote_data_source.dart';
import '/feature/data/models/person_model.dart';
import '/feature/domain/repositories/person_repository.dart';

class PersonRepositoryImpl implements PersonRepository {
  final PersonRemoteDataSource personRemoteDataSource;
  final PersonLocaleDataSource personLocaleDataSource;
  final NetworkInfo networkInfo;

  PersonRepositoryImpl({
    required this.personRemoteDataSource,
    required this.personLocaleDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<PersonModel>>> getAllPersons(int page) async {
    return await _getPerson(
      () {
        return personRemoteDataSource.getAllPerson(page);
      },
    );
  }

  @override
  Future<Either<Failure, List<PersonModel>>> searchPerson(String query) async {
    return await _getPerson(
      () {
        return personRemoteDataSource.searchPerson(query);
      },
    );
  }

  Future<Either<Failure, List<PersonModel>>> _getPerson(
      Future<List<PersonModel>> Function() getPerson) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await getPerson();
        personLocaleDataSource.personsToCache(remoteData);
        return Right(remoteData);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localData =
            await personLocaleDataSource.getLastPersonsFromCache();
        return Right(localData);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
