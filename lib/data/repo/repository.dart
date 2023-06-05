import 'package:aseforenglish/utils/enums.dart';

import '../databases/db_content.dart';
import '../databases/db_user_data.dart';
import '../models/audit.dart';
import '../models/card.dart';
import '../models/course.dart';
import '../models/incorrect.dart';
import '../models/sourse.dart';
import '../models/topic.dart';
import '../models/user.dart';
import '../models/process_learning.dart';
import './../../utils/constants.dart';

/// [RepositoryLocal] - Вспомогательный класс репозиторий для получения
/// `локальных` данных в приложении из `локальной базы данных`
///
/// хранит в ссебе инстансы локальных баз данных `DBUserDataProvider` и `DBContentProvider`
/// в `_dbUserData` и `_dbContentProvider`
class RepositoryLocal {
  DBUserDataProvider _dbUserData;
  DBContentProvider _dbContentProvider;

  // Класс Репозиторий - одиночка.
  // ----
  RepositoryLocal._();
  static final RepositoryLocal _repo = RepositoryLocal._();
  factory RepositoryLocal() {
    _repo._dbUserData = DBUserDataProvider.db;
    _repo._dbContentProvider = DBContentProvider.db;
    return _repo;
  }

  Future closeDB() async {
    await _repo._dbUserData.close();
    await _repo._dbContentProvider.close();
  }
  // ----

  /// Получить все доступные аудит записи.
  Future<List<Audit>> getAudits() async {
    return await _dbUserData.getAuditDAO().getAudits();
  }

  /// Получить последнюю запись аудита.
  Future<Audit> getLastAuth() async {
    return await _dbUserData.getAuditDAO().getLastAudit();
  }

  /// Метод очистки данных, так как у нас на 1 устройстве по  умолчанию
  /// 1 пользолватель, при выходи из приложения, чистим аудит, и делов
  Future audinDeleteData() async {
    await _dbUserData.getAuditDAO().audinDeleteData();
  }

  /// Получить последнего пользователя из аудита.
  Future<User> getLastAuthUser() async {
    var audit = await getLastAuth();
    return await _dbContentProvider
        .getUserDAO()
        .getUser(audit == null ? '' : audit.userID);
  }

  /// Получить пользователя, по логину.
  ///
  /// [login] - логин пользователя, по которому нужно его получить из БД
  Future<User> getUser(String login) async {
    return await _dbContentProvider.getUserDAO().getUser(login);
  }

  /// Получить все доступные курсы.
  Future<List<Course>> getAllCourse() async {
    return await _dbContentProvider.getCourseDAO().getAllCourse();
  }

  /// Получить конкрентный курс по идентификатору
  ///
  /// [uid] - идентификатор курса
  Future<Course> getCourse(String courseID) async {
    return await _dbContentProvider.getCourseDAO().getCourse(courseID);
  }

  /// Получить все темы типа `GROUP` по выбранному курсу.
  ///
  /// [courseID] - идентификатор курса
  Future<List<Topic>> getParentTopics(String courseID) async {
    return await _dbContentProvider.getTopicDAO().getParentTopics(courseID);
  }

  /// Метод получения Темы по идентификатору.
  ///
  /// [uid] - идентификатор интересуемой темы.
  Future<Topic> getTopic(String uid) async {
    return await _dbContentProvider.getTopicDAO().getTopic(uid);
  }

  /// Получить все темы типа `TOPIC` по выбранному курсу.
  ///
  /// [courseID] - идентификатор курса
  Future<List<Topic>> getTopics(String courseID) async {
    return await _dbContentProvider.getTopicDAO().getTopics(courseID);
  }

  /// Получить все группы наслудуемые от GROUP топика.
  ///
  /// [parentID] - идентификатор групповой темы.
  Future<List<Topic>> getParentTopicsChild(String topicID) async {
    return await _dbContentProvider.getTopicDAO().getParentTopicsChild(topicID);
  }

  /// Получить все карточи топика ио идентификатору.
  ///
  /// [topicID] - идентификатор топика, по которуму делается выборка из таблицы базы данных.
  Future<List<Card>> getAllCardsTopic(String topicID) async {
    return await _dbContentProvider.getCardDAO().getAllCardsTopic(topicID);
  }

  /// Получить все карточи топика ио идентификатору.
  ///
  /// [topicID] - идентификатор топика, по которуму делается выборка из таблицы базы данных.
  Future<List<Card>> findCards(String likeWord) async {
    return await _dbContentProvider.getCardDAO().findCards(likeWord);
  }

  /// Получить количество слов в калоде по текущей теме.
  ///
  /// [topicID] - идентификатор темы, для которой необходимо получить количество
  /// слов в калоде данной темы
  Future<int> getCountCardsInTopic(String topicID) async {
    return await _dbContentProvider.getCardDAO().getCountCardsInTopic(topicID);
  }

  /// Получить варианты не верных ответов слов для механик М1 и М2
  ///
  /// [cardID] - идентификатор слова, к которому необходимо подобрать неверные варианты ответов.
  Future<List<Card>> getIncorrectCards(String cardID) async {
    return await _dbContentProvider.getCardDAO().getIncorrectCards(cardID);
  }

  /// Получить последний доступный курс, если его нет, то курс по умолчанию.
  Future<Course> getLastCourse() async {
    var lastAuth = await getLastAuth();
    return await getCourse(lastAuth == null ? kBaseCourse : lastAuth.courseID);
  }

  /// Пполучить все процессы без исключения
  ///
  /// Используется для получения всех уникальных идентификаторов в системе.
  /// Возможно не оптимальное решение.
  Future<List<ProcessLearning>> getAllProcess() async {
    return await _dbUserData.getProcessLearningDAO().getAllProcess();
  }

  /// Метод позволяющий получить все доступные головные процессы типа `HEAD` по курсу
  Future<List<ProcessLearning>> getHeadProcess(String courseID) async {
    return await _dbUserData.getProcessLearningDAO().getHeadProcess(courseID);
  }

  /// Получить последний (а он должен быть всего один) процесс типа `HEAD` для выбранной темы.
  ///
  /// [topicID] - идентификатор топика, по которому необходимо получить выбьрку процессов
  Future<ProcessLearning> getHeadProcessInTopic(String topicID) async {
    return await _dbUserData
        .getProcessLearningDAO()
        .getHeadProcessInTopic(topicID);
  }

  /// Метод позволяющий получить последний открытый процесс по  выбранной теме
  ///
  /// [topicID] - идентификатор необходимой темы, по которой нужно получить последний открытый процесс
  Future<ProcessLearning> getLastProcess(String topicID) async {
    ProcessLearning lastProc =
        await _dbUserData.getProcessLearningDAO().getLastProc(topicID);
    return lastProc;
  }

  /// Метод получения всех `открытых` процессов по данному курсу `текущей` и `прошедшей` датой,
  /// не показываются процессы типа `HEAD` и `LEARNING`
  ///
  /// [courseID] - Идентификатор курса, по которому необходимо получить все доступные процессы.
  Future<List<ProcessLearning>> getPrevRepeats(String courseID) async {
    return await _dbUserData.getProcessLearningDAO().getPrevRepeat(courseID);
  }

  /// Метод получения информации, находится ди указанная тема сегодня на повторении
  ///
  /// [topicID] - Идентификатор тебы, которая нас интересует
  Future<bool> isTopicInRepeateNow(String topicID) async {
    var result =
        await _dbUserData.getProcessLearningDAO().getTopicInRepeateNow(topicID);
    return result != null;
  }

  /// Метод получения всех `открытых` процессов по данному курсу `Будущей` датой,
  /// не показываются процессы типа `HEAD` и `LEARNING`
  ///
  /// [courseID] - Идентификатор курса, по которому необходимо получить все доступные процессы.
  Future<List<ProcessLearning>> getNextRepeats(String courseID) async {
    return await _dbUserData.getProcessLearningDAO().getNextRepeat(courseID);
  }

  /// Метод получения количества слов `в процессе обучения` по выбранному курсу
  ///
  /// [courseID] - Идентификатор курса, по которому необходимо получить все доступные процессы.
  Future<int> getWordSizeInProcess(String courseID) async {
    return await _dbUserData
        .getProcessLearningDAO()
        .getWordSizeInProcess(courseID);
  }

  /// Метод получения количества слов `изученных за все время` по выбранному курсу
  /// (не считая сброшенный прогресс)
  ///
  /// [courseID] - Идентификатор курса, по которому необходимо получить все доступные процессы.
  Future<int> getWordSizeLearned(String courseID) async {
    return await _dbUserData
        .getProcessLearningDAO()
        .getWordSizeLearned(courseID);
  }

  /// Метод получения количества слов в курсе
  ///
  /// [courseID] - Идентификатор курса, по которому необходимо получить все доступные процессы.
  Future<int> getWordSizeInCourse(String courseID) async {
    return await _dbContentProvider
        .getCourseDAO()
        .getWordSizeInCourse(courseID);
  }

  //------------------------------------------------------------
  /// TODO необходимо это разработать, Так же нужно получать эти данные по типам источникам и Инекорректам.
  /// Получаем доступные неверные варианты ответов для карточки.
  Future<List<Incorrect>> getCardIncorrects(String cardID) async {
    //TODO необходимо реализовать данный метод
    return null;
  }

  /// Получаем доступные источники по карточке.
  Future<List<Sourse>> getCardSourse(String cardID) async {
    //TODO необходимо реализовать данный метод
    return null;
  }

  /// Метод для получения источникиов типа `AUDIO` для конкретной карточки.
  ///
  /// [parentID] - идентификатор карточки, для которой нужно получить источники
  Future<Sourse> getSourseAudioType(String cardID) async {
    Sourse result =
        await _dbContentProvider.getSourseDAO().getSourseAudioType(cardID);
    return result;
  }

  /// Метод для получения источникиов типа `AUDIO` для конкретной карточки.
  ///
  /// [parentID] - идентификатор карточки, для которой нужно получить источники
  Future<Sourse> getSourseWithType(String cardID, SuourceType type) async {
    String typeString = getSourseTypeToString(type);
    Sourse result = await _dbContentProvider
        .getSourseDAO()
        .getSourseType(cardID, typeString);
    return result;
  }
  //------------------------------------------------------------

  /// Добавить запись захода в приложение и выбор курсов в базу.
  ///
  /// [audit] - Аудит, который требуется записать в таблицу.
  Future insertAudit(Audit audit) => _dbUserData.getAuditDAO().insert(audit);

  /// Метод добавления записи типа `ProcessLearning` в базу данных
  ///
  /// [proc] - Объект типа `ProcessLearning` который необходимо добавить.
  Future insertProcess(ProcessLearning process) =>
      _dbUserData.getProcessLearningDAO().insert(process);

  /// Метод обновления записи типа `ProcessLearning` в базе данных
  ///
  /// [proc] - Объект типа `ProcessLearning` который необходимо обновить.
  Future updateProcess(ProcessLearning process) =>
      _dbUserData.getProcessLearningDAO().update(process);
}
