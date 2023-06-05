enum NotificationType {
  INACTIVE,
  ACTIVE,
  OVERDUE,
  PASSED,
}

enum TopicType {
  GROUP_OPEN,
  GROUP_CLOSE,
  TOPIC,
  TOPIC_LAST,
  TOPIC_REPEAT,
}

enum ButtonAnswerStatus {
  CURRECT_ANSWER, // Верный вариант.
  UNCURRECT_ANSWER, // Пользователь выбрал данный вариант, и он не верный.
  PASSIVE, // Пользователь не выбрал этот вариант, и он не верный.
  NOT_ACTION, // Состояние кнопки, пока не было выбора ответа.
}

/// Перечисление существующих механик в проекте.
/// [M1] - Механика Выбора перевода слова
/// [M2] - Механика Выбери верное слово\утверждение
/// [M3] - Механика Впиши пропущенное слово\утверждение
/// [M4] - Механика Правда или Ложь
/// [M5] - Механика Прослушай, Скажи, Проверь
enum Mechanics { M1, M2, M3, M4, M5 }

String getMechanicToString(Mechanics m) {
  String result;
  switch (m) {
    case Mechanics.M2:
      result = 'M2';
      break;
    case Mechanics.M3:
      result = 'M3';
      break;
    case Mechanics.M4:
      result = 'M4';
      break;
    case Mechanics.M5:
      result = 'M5';
      break;
    default:
      result = 'M1';
      break;
  }
  return result;
}

Mechanics getStringToMechanic(String m) {
  Mechanics result;
  switch (m) {
    case 'M2':
      result = Mechanics.M2;
      break;
    case 'M3':
      result = Mechanics.M3;
      break;
    case 'M4':
      result = Mechanics.M4;
      break;
    case 'M5':
      result = Mechanics.M5;
      break;
    default:
      result = Mechanics.M1;
      break;
  }
  return result;
}

// ------------------------------------
enum ProcessLevel {
  HEAD,
  LEARNING,
  REPEAT_01,
  REPEAT_02,
  REPEAT_03,
  REPEAT_04,
  REPEAT_05,
  REPEAT_06,
  REPEAT_07
}
int getProcessLevelToInt(ProcessLevel proc) {
  int result;
  switch (proc) {
    case ProcessLevel.LEARNING:
      result = 0;
      break;
    case ProcessLevel.REPEAT_01:
      result = 1;
      break;
    case ProcessLevel.REPEAT_02:
      result = 2;
      break;
    case ProcessLevel.REPEAT_03:
      result = 3;
      break;
    case ProcessLevel.REPEAT_04:
      result = 4;
      break;
    case ProcessLevel.REPEAT_05:
      result = 5;
      break;
    case ProcessLevel.REPEAT_06:
      result = 6;
      break;
    case ProcessLevel.REPEAT_07:
      result = 7;
      break;
    default:
      result = 10;
      break;
  }
  return result;
}

ProcessLevel getIntToProcessLevel(int proc) {
  ProcessLevel result;
  switch (proc) {
    case 0:
      result = ProcessLevel.LEARNING;
      break;
    case 1:
      result = ProcessLevel.REPEAT_01;
      break;
    case 2:
      result = ProcessLevel.REPEAT_02;
      break;
    case 3:
      result = ProcessLevel.REPEAT_03;
      break;
    case 4:
      result = ProcessLevel.REPEAT_04;
      break;
    case 5:
      result = ProcessLevel.REPEAT_05;
      break;
    case 6:
      result = ProcessLevel.REPEAT_06;
      break;
    case 7:
      result = ProcessLevel.REPEAT_07;
      break;
    default:
      result = ProcessLevel.HEAD;
      break;
  }
  return result;
}

int getIntervalRepeat(ProcessLevel proc) {
  int result = 0;
  switch (proc) {
    case ProcessLevel.REPEAT_02:
      result = 3;
      break;
    case ProcessLevel.REPEAT_03:
      result = 7;
      break;
    case ProcessLevel.REPEAT_04:
      result = 14;
      break;
    case ProcessLevel.REPEAT_05:
      result = 21;
      break;
    case ProcessLevel.REPEAT_06:
      result = 28;
      break;
    default:
      result = 1;
      break;
  }
  return result;
}

ProcessLevel getNextLevel(ProcessLevel proc) {
  ProcessLevel result;
  switch (proc) {
    case ProcessLevel.LEARNING:
      result = ProcessLevel.REPEAT_01;
      break;
    case ProcessLevel.REPEAT_01:
      result = ProcessLevel.REPEAT_02;
      break;
    case ProcessLevel.REPEAT_02:
      result = ProcessLevel.REPEAT_03;
      break;
    case ProcessLevel.REPEAT_03:
      result = ProcessLevel.REPEAT_04;
      break;
    case ProcessLevel.REPEAT_04:
      result = ProcessLevel.REPEAT_05;
      break;
    case ProcessLevel.REPEAT_05:
      result = ProcessLevel.REPEAT_06;
      break;
    default:
      result = ProcessLevel.REPEAT_07;
  }
  return result;
}

enum SuourceType {
  AUDIO,
  AUDIO_DESCRIPTION,
  IMAGE,
}

String getSourseTypeToString(SuourceType source) {
  String result = '';

  switch (source) {
    case SuourceType.AUDIO_DESCRIPTION:
      result = 'AUDIO_DESCRIPTION';
      break;
    case SuourceType.IMAGE:
      result = 'IMAGE';
      break;
    default:
      result = 'AUDIO';
      break;
  }

  return result;
}

SuourceType getStringToSourseType(String source) {
  SuourceType result;

  switch (source) {
    case 'AUDIO_DESCRIPTION':
      result = SuourceType.AUDIO_DESCRIPTION;
      break;
    case 'IMAGE':
      result = SuourceType.IMAGE;
      break;
    default:
      result = SuourceType.AUDIO;
      break;
  }

  return result;
}
// ------------------------------------
