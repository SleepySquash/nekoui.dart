import 'package:nekoui/ui/novel/novel.dart';

import '../controller.dart';

extension TopicExtension on NekoController {
  static List<TalkTopic> topics(String? name) {
    return [
      TalkTopic(
        'Мне нравится твоя улыбка',
        [DialogueLine('Ух ты!', by: name)],
        type: TopicType.romantic,
      ),
      TalkTopic(
        'Как дела с учёбой?',
        [DialogueLine('Ух ты!', by: name)],
        type: TopicType.study,
      ),
      TalkTopic(
        'Проголодалась?',
        [DialogueLine('Ух ты!', by: name)],
        type: TopicType.food,
      ),
      TalkTopic(
        'Хочешь чем-нибудь заняться?',
        [DialogueLine('Ух ты!', by: name)],
        type: TopicType.together,
      ),
      TalkTopic(
        'Про теорему Пифагора?',
        [
          DialogueLine(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi cursus velit magna.',
            by: name,
          ),
        ],
        type: TopicType.study,
      ),
      TalkTopic(
        'Выглядишь мило >3<',
        [DialogueLine('Ух ты!', by: name)],
      ),
      TalkTopic(
        'Как ты себя чувствуешь?',
        [DialogueLine('Ух ты!', by: name)],
      ),
      TalkTopic(
        'Твой любимый цвет?',
        [DialogueLine('Ух ты!', by: name)],
      ),
      TalkTopic(
        'Твоя любимая еда?',
        [DialogueLine('Ух ты!', by: name)],
      ),
      TalkTopic(
        'Твой нелюбимый цвет?',
        [DialogueLine('Ух ты!', by: name)],
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
      ),
      TalkTopic(
        'Иногда я хочу быть вертолётом...',
        [DialogueLine('Ух ты!', by: name)],
      ),
      TalkTopic(
        'В чём смысл жизни?',
        [DialogueLine('Ух ты!', by: name)],
      ),
      TalkTopic(
        'Ты меня заводишь...',
        [DialogueLine('Но... п-папа...', by: name)],
        type: TopicType.romantic,
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
