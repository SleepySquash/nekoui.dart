// Copyright © 2022 NIKITA ISAENKO, <https://github.com/SleepySquash>
//
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU Affero General Public License v3.0 as published by the
// Free Software Foundation, either version 3 of the License, or (at your
// option) any later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License v3.0 for
// more details.
//
// You should have received a copy of the GNU Affero General Public License v3.0
// along with this program. If not, see
// <https://www.gnu.org/licenses/agpl-3.0.html>.

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
