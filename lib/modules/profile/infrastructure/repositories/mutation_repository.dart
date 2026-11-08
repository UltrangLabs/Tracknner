import '../../domain/datasources/mutation_user_datarource.dart';
import '../../domain/dtos/in/create_user_dto.dart';
import '../../domain/repositories/mutation_user_repository.dart';

class MutationUserRepositoryImpl implements MutationUserRepository {
  final MutationUserDatarource mutationDatasource;

  MutationUserRepositoryImpl({required this.mutationDatasource});

  @override
  Future<void> createUser({required CreateUserDto dto}) {
    return mutationDatasource.createUser(dto: dto);
  }
}
