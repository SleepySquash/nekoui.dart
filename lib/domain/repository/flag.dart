enum Flags {
  geolocationAsked,
}

abstract class AbstractFlagRepository {
  bool? get(Flags flag);
  Future<void> set(Flags flag, bool value);
}
