import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/use_cases/basic_use_cases.dart';
import '/feature/domain/repositories/person_repository.dart';

import '../../../core/error/failure.dart';
import '../entities/person_entity.dart';

class SearchPerson extends BasicUseCase<List<PersonEntity>,SearchPersonParams>  {
  final PersonRepository personRepository;
  SearchPerson(this.personRepository);

  @override
  Future<Either<Failure,List<PersonEntity>>> call (SearchPersonParams params) async {
    return await personRepository.searchPerson(params.query);
  }
}
class SearchPersonParams extends Equatable {
  final String query;

  const SearchPersonParams({required this.query});

  @override
  List<Object?> get props => [query];

}
