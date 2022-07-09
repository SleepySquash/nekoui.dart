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
