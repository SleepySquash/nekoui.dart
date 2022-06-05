import 'package:get/get.dart';

import 'model/object.dart';
import 'model/scenario.dart';

class NovelController extends GetxController {
  NovelController(this.scenario, {this.onEnd});

  /// [Scenario] being read in this [NovelController].
  final Scenario scenario;

  /// Currently executed [NovelLine] of the [scenario].
  final RxInt currentLine = RxInt(0);

  /// [NovelObject]s to display in the view.
  final RxList<NovelObject> objects = RxList();

  /// Callback, called when the [Novel] ends reading its [scenario].
  ///
  /// Calls the [Navigator.pop], if `null`.
  final void Function()? onEnd;

  @override
  void onInit() {
    thread();
    super.onInit();
  }

  Future<void> thread() async {
    ScenarioLine? line;

    do {
      line = scenario.at(currentLine.value);
      currentLine.value = currentLine.value + 1;

      print('line is $line');

      if (line is ScenarioAddLine) {
        objects.add(line.object);
      }

      if (line is WaitableMixin) {
        if (line.wait) {
          await line.execute();
        }
      }
    } while (line != null);

    onEnd?.call();
  }
}
