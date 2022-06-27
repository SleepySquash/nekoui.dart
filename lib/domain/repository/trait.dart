import '/domain/model/trait.dart';
import '/util/obs/obs.dart';

abstract class AbstractTraitRepository {
  RxObsMap<Traits, Trait> get traits;
  void add(Traits trait, [int amount]);
  void remove(Traits trait, [int? amount]);
}
