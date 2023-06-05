// course.dart
import 'package:flutter/material.dart';

import './../dao/course_dao.dart';
import './../../utils/constants.dart';
import './../../utils/ase_random.dart';

/// [Course] - кдасс для хранения данных по курсу.
///
/// поля:
///
/// [uid] - Идентификатор записи, для каждой записи идентификатор в системе задан при составлении контента
///
/// [name] - Обязательное поле. Хранить в себе название курса.
///
/// [image] - Пока не используемое поле, в планах использовать для хранения ссылки на изображения.
///
/// [grade] - Хранит в себе данные по уровню данного курса.
///
/// [position] - Позиция курса при выборке курсов из базы данных, БД сортирует таблицу по данному полю.
///
class Course {
  String uid;
  String name;
  String image;
  String grade;
  int position;

  Course({
    this.uid,
    @required this.name,
    this.grade,
    this.image = '',
    this.position = 0,
  }) {
    if (uid == null) uid = getRandomUID(kPrefixCourse);
  }

  factory Course.fromMap(Map<String, dynamic> json) => new Course(
        uid: json[CourseDAO.COLUMN_UID],
        name: json[CourseDAO.COLUMN_NAME],
        grade: json[CourseDAO.COLUMN_GRADE],
        image: json[CourseDAO.COLUMN_IMAGE],
        position: json[CourseDAO.COLUMN_POSITION],
      );

  Map<String, dynamic> toMap() => {
        CourseDAO.COLUMN_UID: uid,
        CourseDAO.COLUMN_NAME: name,
        CourseDAO.COLUMN_GRADE: grade,
        CourseDAO.COLUMN_IMAGE: image,
        CourseDAO.COLUMN_POSITION: position,
      };
}
