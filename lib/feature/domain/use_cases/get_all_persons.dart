import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:the_clean_architecture/core/use_cases/basic_use_cases.dart';
import '/feature/domain/repositories/person_repository.dart';

import '../../../core/error/failure.dart';
import '../entities/person_entity.dart';

class GetAllPersons extends BasicUseCase<List<PersonEntity>,PagePersonParams>  {
  final PersonRepository personRepository;
  GetAllPersons(this.personRepository);

  @override
  Future<Either<Failure,List<PersonEntity>>> call (PagePersonParams params) async {
    return await personRepository.getAllPersons(params.page);
  }

}

class PagePersonParams extends Equatable {
  final int page;

  const PagePersonParams({required this.page});

  @override
  List<Object?> get props => [page];

}
