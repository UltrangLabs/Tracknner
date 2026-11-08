import '../../../../core/domain/use_cases/interfaces/structure_use_case.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/query_user_repository.dart';

typedef ExecuteGetUserAlreadyHaveAnAccountUseCase = Future<User?> Function(
  NoParams params,
);

class GetUserAlreadyHaveAnAccountUseCase
    implements UseCaseStructure<User?, NoParams> {
  final QueryUserRepository _queryUser;

  GetUserAlreadyHaveAnAccountUseCase({required this._queryUser});

  @override
  Future<User?> execute(NoParams params) async {
    return await _queryUser.userAlreadyHaveAnAccount();
  }
}
