import '../../domain/datasources/mutation_user_datarource.dart';
import '../../domain/dtos/in/create_user_dto.dart';
import '../../domain/repositories/mutation_user_repository.dart';

class MutationUserLocalRepository implements MutationUserRepository {
  final MutationUserDatarource mutationDatasource;

  MutationUserLocalRepository({required this.mutationDatasource});

  @override
  Future<void> createUser({required CreateUserDto dto}) {
    return mutationDatasource.createUser(dto: dto);
  }
}
