import 'package:novel/novel.dart';

import '/domain/model/topic.dart';
import '../controller.dart';

extension TopicExtension on NekoController {
  static List<TalkTopic> topics(String? name) {
    return [
      TalkTopic(
        'Мне нравится твоя улыбка',
        [DialogueLine('Ух ты!', by: name)],
        type: TopicType.romance,
      ),
      TalkTopic(
        'Как дела с учёбой?',
        [DialogueLine('Ух ты!', by: name)],
        type: TopicType.profession,
      ),
      TalkTopic(
        'Проголодалась?',
        [DialogueLine('Ух ты!', by: name)],
        type: TopicType.preference,
      ),
      TalkTopic(
        'Хочешь чем-нибудь заняться?',
        [DialogueLine('Ух ты!', by: name)],
        type: TopicType.casual,
      ),
      TalkTopic(
        'Про теорему Пифагора?',
        [
          DialogueLine(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi cursus velit magna.',
            by: name,
          ),
        ],
        type: TopicType.profession,
      ),
      TalkTopic(
        'Выглядишь мило',
        [DialogueLine('Ух ты!', by: name)],
        type: TopicType.romance,
      ),
      TalkTopic(
        'Как ты себя чувствуешь?',
        [DialogueLine('Ух ты!', by: name)],
      ),
      TalkTopic(
        'Твой любимый цвет?',
        [DialogueLine('Ух ты!', by: name)],
        type: TopicType.preference,
      ),
      TalkTopic(
        'Твоя любимая еда?',
        [DialogueLine('Ух ты!', by: name)],
        type: TopicType.preference,
      ),
      TalkTopic(
        'Твой нелюбимый цвет?',
        [DialogueLine('Ух ты!', by: name)],
        type: TopicType.preference,
      ),
      TalkTopic(
        'Ща такую шутку расскажу...',
        [DialogueLine('Ух ты!', by: name)],
      ),
      TalkTopic(
        'Меня звать Алан...',
        [DialogueLine('Ух ты!', by: name)],
      ),
      TalkTopic(
        'Коммунизм - это хорошо?',
        [DialogueLine('Ух ты!', by: name)],
        type: TopicType.preference,
      ),
      TalkTopic(
        'Иногда я хочу быть вертолётом...',
        [DialogueLine('Ух ты!', by: name)],
      ),
      TalkTopic(
        'В чём смысл жизни?',
        [DialogueLine('Ух ты!', by: name)],
        type: TopicType.preference,
      ),
      TalkTopic(
        'Ты меня заводишь...',
        [DialogueLine('Но... п-папа...', by: name)],
        type: TopicType.romance,
      ),
      TalkTopic(
        'Это выбор Врат Штейна!!',
        [DialogueLine('Ух ты!', by: name)],
      ),
      TalkTopic(
        'Я твой отец, Люк...',
        [DialogueLine('Ух ты!', by: name)],
      ),
    ];
  }
}
