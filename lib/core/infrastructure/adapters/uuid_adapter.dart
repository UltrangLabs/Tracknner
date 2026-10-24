import 'package:uuid/uuid.dart';

import '../../domain/types/app_uuid.dart';

const Uuid _uuidGenerator = Uuid();

AppUuid generateUuidV4() {
  return AppUuid(_uuidGenerator.v4());
}

AppUuid parseUuid(String incomingString) {
  return AppUuid(incomingString);
}
