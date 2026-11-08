abstract interface class UseCaseStructure<TypeRes, Params> {
  Future<TypeRes> execute(Params params);
}

class NoParams {
  const NoParams();
}
