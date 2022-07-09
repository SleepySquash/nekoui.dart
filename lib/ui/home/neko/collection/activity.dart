import 'package:novel/novel.dart';

import '../controller.dart';
import '/domain/model/topic.dart';

extension ActivityExtension on NekoController {
  static List<TalkTopic> activities(String? name) {
    return [
      TalkTopic(
        'Сходить в парк',
        [
          BackgroundLine('park.jpg', wait: false),
          CharacterLine('person.png'),
          DialogueLine('Вау, тут так красиво!', by: name),
          DialogueLine('Спасибо, что сходил со мной!! :3', by: name),
        ],
        type: TopicType.casual,
      ),
      TalkTopic(
        'Cмотреть анимки',
        [DialogueLine('Ух ты!', by: name)],
        type: TopicType.casual,
      ),
    ];
  }
}
