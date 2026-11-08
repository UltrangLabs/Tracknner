import '../../../../core/domain/types/unknown_type.dart';
import '../../../../core/domain/use_cases/interfaces/structure_use_case.dart';
import '../../../../core/infrastructure/adapters/validator_adapter.dart';

import '../../domain/dtos/in/create_user_dto.dart';
import '../../domain/dtos/in/looking_user_exist_dto.dart';
import '../../domain/repositories/mutation_user_repository.dart';

import '../dtos/in/create_user_dto.dart';

typedef ExecuteCreateUserUseCase = Future<void> Function(Unknown rawData);

typedef DtosCreated = ({
  CreateUserDto createUserDto,
  LookingUserDto lookingForUserExist,
});

class CreateUserUseCase implements UseCaseStructure<void, Unknown> {
  final MutationUserRepository _mutationUserRepository;
  final ValidatorAdapter<CreateUserDto> _userValidator;

  CreateUserUseCase({
    required this._mutationUserRepository,
    required this._userValidator,
  });

  @override
  Future<void> execute(Unknown rawData) async {
    final createUserDto = CreateUserDtoImpl.create(
      rawData: rawData,
      validator: _userValidator,
    );

    await _mutationUserRepository.createUser(dto: createUserDto);
  }
}
