---
name: create-new-use-case
description: Guía paso a paso y estándar obligatorio para diseñar, implementar y registrar un nuevo Caso de Uso en Tracknner, abarcando desde los contratos en domain, validación de DTOs con LucidValidator en application, implementación de repositorios y datasources en infrastructure (con validaciones de integridad actuando como backend), hasta la inyección de dependencias y exposición de acciones ejecutables mediante GetIt.
---

# 🛠️ Skill: Creación de un Nuevo Caso de Uso (Tracknner)

Esta guía define el flujo obligatorio de desarrollo para crear un nuevo Caso de Uso en Tracknner. Cubre desde el diseño de contratos puros en `domain/`, la validación y orquestación en `application/`, la implementación de persistencia en `infrastructure/`, hasta el registro de inyección de dependencias en `di/`.

> [!NOTE]
> Este documento excluye deliberadamente la capa de `presentation/` y la generación de tests, ya que corresponden a responsabilidades y ciclos de desarrollo independientes.

---

## 🧭 Flujo Arquitectónico General

```
[Invocador / Acción]
        │
        ▼
1. application/use_cases/               ◄─── (Nivel 2: Orquestación pura: valida DTO y delega al repo)
        │
        ├────► application/dtos/in/     ◄─── (Nivel 1: Validación Estructural / DTO)
        │            │
        │            ▼
        │      LucidValidator Schema
        │
        ▼
2. domain/repositories/ (Contrato puro)
        │
        ▼
3. infrastructure/repositories/ (Implementación)
        │
        ▼
4. domain/datasources/ (Contrato)
        │
        ▼
5. infrastructure/datasources/ (Local/Remote) ◄── (Nivel 3: Backend / Consultas / Integridad de BD)
        │
        ├────► infrastructure/mappers/        ◄─── (Conversión DB/API ◄► Entidades)
        │            │
        │            ▼
        │      domain/mappers/ (Contrato)
        │
        ▼
6. di/ (Registro en GetIt / sl)
```

---

## 🧱 Las Reglas de los 3 Niveles de Validación

Tracknner opera con una base de datos local SQLite que simula ser un servidor Backend (Offline-First). Las validaciones deben respetar estrictamente su nivel:

| Nivel | Capa Responsable | Qué se valida | Regla Clave |
|---|---|---|---|
| **Nivel 1** | `application/dtos/in/` + `validators/schemas/` | Estructura y formato crudo del dato (longitud, caracteres, formato, no vacío). | Ocurre en la frontera con `ValidatorAdapter`. Si falla, rechaza de inmediato con `CustomError.badRequest`. |
| **Nivel 2** | `application/use_cases/` | Orquestación limpia de la operación. | **⛔ REGLA DE ORO:** Un Caso de Uso **NUNCA** debe hacer consultas previas a la base de datos (ni `query`, ni `get`, ni `find`). El caso de uso valida su DTO de entrada y delega inmediatamente al repositorio: `return _repository.accion(dto);`. |
| **Nivel 3** | `infrastructure/datasources/` | Lógica de servidor Backend: verificación de saldos, consultas previas, conflictos de unicidad, inserciones y actualizaciones. | El Datasource actúa como Backend: consulta la base de datos, valida la integridad y lanza `CustomError.badRequest`, `CustomError.conflict` o `CustomError.notFound`. |

---

## 📋 Paso a Paso para Crear un Caso de Uso

---

### Paso 1: Definir Contratos en `domain/`

La capa de dominio no depende de Flutter ni de paquetes externos (Dart puro).

#### 1.1. Contrato del DTO de entrada (`domain/dtos/in/create_pet_dto.dart`)
```dart
import '../../../../../core/domain/types/app_uuid.dart';

abstract interface class CreatePetDto {
  AppUuid get userId;
  String get name;
  String get breed;
  String get imageAssetName;
}
```

#### 1.2. Contrato del Repositorio (`domain/repositories/pet_repository.dart`)
```dart
import '../../../../../core/domain/types/app_uuid.dart';
import '../dtos/in/create_pet_dto.dart';
import '../entities/pet.dart';

abstract class PetRepository {
  Future<Pet> create(CreatePetDto dto);
  Future<Pet?> findByUser(AppUuid userId);
}
```

#### 1.3. Contrato del Datasource (`domain/datasources/pet_datasource.dart`)
```dart
import '../../../../../core/domain/types/app_uuid.dart';
import '../dtos/in/create_pet_dto.dart';
import '../entities/pet.dart';

abstract class PetDatasource {
  Future<Pet> create(CreatePetDto dto);
  Future<Pet?> findByUser(AppUuid userId);
}
```

#### 1.4. Contrato del Mapper (`domain/mappers/pet_mapper.dart`)
Aísla las transformaciones entre base de datos/API y entidades de dominio, evitando acoplar el Datasource con esquemas o nombres de columnas:
```dart
import '../../../../../core/domain/types/unknown_type.dart';
import '../dtos/in/create_pet_dto.dart';
import '../entities/pet.dart';

abstract class PetMapper {
  Pet fromDbToEntity(Unknown dbData);
  Unknown fromEntityToDb(Pet pet);
  Pet fromCreateDtoToEntity(CreatePetDto dto);
}
```

---

### Paso 2: Implementar DTO y Esquema en `application/`

#### 2.1. Esquema de Validación con `LucidValidator` (`application/validators/schemas/create_pet_schema.dart`)
```dart
import 'package:lucid_validation/lucid_validation.dart';
import '../../../domain/dtos/in/create_pet_dto.dart';

class CreatePetValidateSchema extends LucidValidator<CreatePetDto> {
  static const int _minLength = 2;
  static const int _maxLength = 50;
  static const String _safeTextPattern = r'^[a-zA-Z0-9\s\-_.,!¡?¿@ñÑáéíóúÁÉÍÓÚ]+$';

  CreatePetValidateSchema() {
    // Seguridad: Mensaje genérico para identificadores internos
    ruleFor((dto) => dto.userId.value, key: 'userId')
        .notEmpty(message: 'Parámetro inválido');

    ruleFor((dto) => dto.name, key: 'name')
        .notEmpty(message: 'El nombre es requerido')
        .minLength(_minLength, message: 'El nombre es muy corto')
        .maxLength(_maxLength, message: 'El nombre es muy largo')
        .matchesPattern(_safeTextPattern, message: 'El nombre contiene caracteres inválidos');

    ruleFor((dto) => dto.breed, key: 'breed')
        .notEmpty(message: 'La raza es requerida');

    ruleFor((dto) => dto.imageAssetName, key: 'imageAssetName')
        .notEmpty(message: 'La imagen es requerida');
  }
}
```

#### 2.2. Implementación del DTO (`application/dtos/in/create_pet_dto.dart`)
```dart
import '../../../../../../core/domain/types/app_uuid.dart';
import '../../../../../../core/domain/types/unknown_type.dart';
import '../../../../../../core/infrastructure/adapters/validator_adapter.dart';
import '../../../domain/dtos/in/create_pet_dto.dart';

typedef ValidatorCreatePetDto = ValidatorAdapter<CreatePetDto>;

class CreatePetDtoImpl implements CreatePetDto {
  @override
  final AppUuid userId;
  @override
  final String name;
  @override
  final String breed;
  @override
  final String imageAssetName;

  const CreatePetDtoImpl._({
    required this.userId,
    required this.name,
    required this.breed,
    required this.imageAssetName,
  });

  static CreatePetDto create({
    required Unknown rawData,
    required ValidatorCreatePetDto validator,
  }) {
    final unvalidatedDto = _mapFromRaw(rawData);
    return validator.validate(unvalidatedDto);
  }

  static CreatePetDto _mapFromRaw(Unknown rawData) {
    return CreatePetDtoImpl._(
      userId: AppUuid(rawData['userId']?.toString() ?? ''),
      name: rawData['name']?.toString() ?? '',
      breed: rawData['breed']?.toString() ?? '',
      imageAssetName: rawData['imageAssetName']?.toString() ?? '',
    );
  }
}
```

---

### Paso 3: Crear el Caso de Uso en `application/` (`application/use_cases/create_pet_use_case.dart`)

Reglas:
- Recibe `Unknown rawData` (evita acoplamiento con la fuente de entrada).
- Implementa `UseCaseStructure<ReturnType, Unknown>`.
- Expone un `typedef Execute*UseCase`.
- **Limpio y directo:** No consulta la base de datos para comprobar saldos, existencias o duplicados. Valida el DTO de entrada y delega al repositorio.

```dart
import '../../../../../core/domain/types/unknown_type.dart';
import '../../../../../core/domain/use_cases/interfaces/structure_use_case.dart';
import '../../domain/entities/pet.dart';
import '../../domain/repositories/pet_repository.dart';
import '../dtos/in/create_pet_dto.dart';

typedef ExecuteCreatePetUseCase = Future<Pet> Function(Unknown rawData);

class CreatePetUseCase implements UseCaseStructure<Pet, Unknown> {
  final PetRepository _petRepository;
  final ValidatorCreatePetDto _createPetValidator;

  CreatePetUseCase({
    required this._petRepository,
    required this._createPetValidator,
  });

  @override
  Future<Pet> execute(Unknown rawData) async {
    final createPetDto = CreatePetDtoImpl.create(
      rawData: rawData,
      validator: _createPetValidator,
    );

    return _petRepository.create(createPetDto);
  }
}
```

---

### Paso 4: Implementar en `infrastructure/`

#### 4.1. Mapper de Persistencia (`infrastructure/mappers/pet_mapper.dart`)
Implementa el contrato de `domain/mappers/pet_mapper.dart`. Encapsula la conversión entre las filas de SQLite (o respuestas API) y las entidades de dominio:
```dart
import '../../../../../core/domain/errors/custom_error.dart';
import '../../../../../core/domain/types/app_uuid.dart';
import '../../../../../core/domain/types/unknown_type.dart';
import '../../../../../core/infrastructure/adapters/uuid_adapter.dart';
import '../../domain/constants/base_pet_values.dart';
import '../../domain/dtos/in/create_pet_dto.dart';
import '../../domain/entities/pet.dart';
import '../../domain/mappers/pet_mapper.dart';

class PetMapperImpl implements PetMapper {
  final GenerateUuIdV4 _generateUuIdV4;

  PetMapperImpl({this._generateUuIdV4 = generateUuidV4});

  @override
  Pet fromDbToEntity(Unknown dbData) {
    if (dbData.isEmpty) {
      throw CustomError.badRequest(
        payload: [(message: 'The data is Empty', path: 'Pet mapper')],
        path: 'mapper',
      );
    }

    return Pet(
      id: AppUuid(dbData['petId'] as String),
      userId: AppUuid(dbData['userId'] as String),
      name: dbData['petName'] as String,
      breed: dbData['petBreed'] as String,
      imageAssetName: dbData['imageAssetName'] as String,
      level: dbData['currentLevel'] as int,
      experience: dbData['currentExperience'] as int,
    );
  }

  @override
  Unknown fromEntityToDb(Pet pet) {
    return {
      'petId': pet.id.value,
      'userId': pet.userId.value,
      'petName': pet.name,
      'petBreed': pet.breed,
      'imageAssetName': pet.imageAssetName,
      'currentLevel': pet.level,
      'currentExperience': pet.experience,
    };
  }

  @override
  Pet fromCreateDtoToEntity(CreatePetDto dto) {
    return Pet(
      id: _generateUuIdV4(),
      userId: dto.userId,
      name: dto.name,
      breed: dto.breed,
      imageAssetName: dto.imageAssetName,
      level: kDefaultPetValues.level,
      experience: kDefaultPetValues.experience,
    );
  }
}
```

#### 4.2. Datasource Local (`infrastructure/datasources/pet_local_datasource.dart`)
Actúa como **Backend (Nivel 3)**: realiza consultas a la base de datos, valida existencias, saldos o duplicados, y delega todas las conversiones al Mapper (sin mapeo inline):
```dart
import '../../../../../core/domain/errors/custom_error.dart';
import '../../../../../core/domain/types/app_uuid.dart';
import '../../../../../core/infrastructure/database/interfaces/local_db_client.dart';
import '../../domain/datasources/pet_datasource.dart';
import '../../domain/dtos/in/create_pet_dto.dart';
import '../../domain/entities/pet.dart';
import '../../domain/mappers/pet_mapper.dart';

class PetLocalDatasource implements PetDatasource {
  static const String _tableName = 'Pet';
  static const String _errorPath = 'modules.game_engine.pet_core.pet_local_datasource';

  final LocalDbClient _dbClient;
  final PetMapper _petMapper;

  PetLocalDatasource({
    required this._dbClient,
    required this._petMapper,
  });

  @override
  Future<Pet> create(CreatePetDto dto) async {
    // 🛡️ Nivel 3: Validación de Integridad / Backend (SRP: delegada a método privado)
    await _validatePetDoesNotExist(dto);

    final pet = _petMapper.fromCreateDtoToEntity(dto);

    final insertedId = await _dbClient.insert(
      _tableName,
      _petMapper.fromEntityToDb(pet),
    );

    if (insertedId == 0) {
      throw CustomError.internalServer(
        message: 'Error al registrar la mascota',
        path: _errorPath,
      );
    }

    return pet;
  }

  Future<void> _validatePetDoesNotExist(CreatePetDto dto) async {
    final existing = await _dbClient.query(
      _tableName,
      conditions: (where: 'userId = ?', whereArgs: [dto.userId.value]),
      limit: 1,
    );

    if (existing.isNotEmpty) {
      throw CustomError.badRequest(
        payload: [(message: 'El usuario ya cuenta con una mascota', path: 'userId')],
        path: _errorPath,
      );
    }
  }

  @override
  Future<Pet?> findByUser(AppUuid userId) async {
    final rows = await _dbClient.query(
      _tableName,
      conditions: (where: 'userId = ?', whereArgs: [userId.value]),
      limit: 1,
    );

    return rows.isEmpty ? null : _petMapper.fromDbToEntity(rows.first);
  }
}
```

#### 4.3. Repositorio (`infrastructure/repositories/pet_repository_impl.dart`)
Implementa el contrato de dominio y delega al datasource:
```dart
import '../../../../../core/domain/types/app_uuid.dart';
import '../../domain/datasources/pet_datasource.dart';
import '../../domain/dtos/in/create_pet_dto.dart';
import '../../domain/entities/pet.dart';
import '../../domain/repositories/pet_repository.dart';

class PetRepositoryImpl implements PetRepository {
  final PetDatasource _petDatasource;

  PetRepositoryImpl({required this._petDatasource});

  @override
  Future<Pet> create(CreatePetDto dto) {
    return _petDatasource.create(dto);
  }

  @override
  Future<Pet?> findByUser(AppUuid userId) {
    return _petDatasource.findByUser(userId);
  }
}
```

---

### Paso 5: Registro e Inyección de Dependencias en `di/` (`di/pet_core_di.dart`)

```dart
import '../../../../core/di/injection_container.dart';
import '../../../../core/infrastructure/adapters/validator_adapter.dart';
import '../../../../core/infrastructure/database/interfaces/local_db_client.dart';
import '../application/use_cases/create_pet_use_case.dart';
import '../application/validators/schemas/create_pet_schema.dart';
import '../domain/dtos/in/create_pet_dto.dart';
import '../infrastructure/datasources/pet_local_datasource.dart';
import '../infrastructure/mappers/pet_mapper.dart';
import '../infrastructure/repositories/pet_repository_impl.dart';

void initPetCoreDi() {
  //* DB
  late final dbClient = sl.get<LocalDbClient>();

  //* Schemas
  late final createPetValidateSchema = CreatePetValidateSchema();

  //* Validators
  late final createPetValidator = ValidatorAdapter<CreatePetDto>(
    createPetValidateSchema,
  );

  //* Mappers
  late final petMapper = PetMapperImpl();

  //* Datasources
  late final petDatasource = PetLocalDatasource(
    dbClient: dbClient,
    petMapper: petMapper,
  );

  //* Repositories
  late final petRepository = PetRepositoryImpl(petDatasource: petDatasource);

  //* Use Cases
  late final createPet = CreatePetUseCase(
    petRepository: petRepository,
    createPetValidator: createPetValidator,
  );

  //* Actions (Exposición para consumo externo)
  sl.registerLazySingleton<ExecuteCreatePetUseCase>(
    () => createPet.execute,
  );
}
```

---

## 🛡️ Checklist de Verificación de Calidad

Antes de dar por terminado el nuevo Caso de Uso:
- [ ] **Sin consultas en el UseCase:** El Caso de Uso **NO consulta** a la base de datos (sin `getCoins`, `findByUser`, `query`, etc.). Únicamente valida el DTO y delega al método mutador/ejecutor del Repositorio.
- [ ] **Datasource como Backend:** Toda consulta previa, verificación de existencia, chequeo de saldo o comprobación de duplicados se ejecuta en el **Datasource**.
- [ ] **Validación Nivel 1:** El DTO de entrada se valida en `Application` con `LucidValidator` mediante `ValidatorAdapter`.
- [ ] **IDs protegidos:** Mensaje genérico `'Parámetro inválido'` para identificadores internos (`userId`, `petId`).
- [ ] **Nomenclatura:** Repositorio nombrado `*RepositoryImpl`, datasource nombrado `*LocalDatasource`.
- [ ] **Constructores formales:** Uso de `required this._field` en todos los constructores.
- [ ] **Sin `dynamic`:** Uso de `Unknown` (`Map<String, dynamic>`) tipado.
- [ ] **GetIt Action:** Expuesto mediante `sl.registerLazySingleton<Execute*UseCase>(() => useCase.execute)`.
