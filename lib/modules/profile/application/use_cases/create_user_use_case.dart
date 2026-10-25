import '../../../../core/domain/types/unknown_type.dart';
import '../../../../core/infrastructure/adapters/validator_adapter.dart';
import '../../domain/dtos/in/create_user_dto.dart';
import '../../domain/repositories/mutation_user_repository.dart';
import '../dtos/in/create_user_dto.dart';

class CreateUserUseCase {
  final MutationUserRepository _mutationUserRepository;
  final ValidatorAdapter<CreateUserDto> _userValidator;

  CreateUserUseCase({
    required this._mutationUserRepository,
    required this._userValidator,
  });

  Future<void> execute({required Unknown rawData}) async {
    final dto = CreateUserDtoImpl.create(
      rawData: rawData,
      validator: _userValidator,
    );

    await _mutationUserRepository.createUser(dto: dto);
  }
}
