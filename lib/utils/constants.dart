import 'package:flutter/material.dart';

const List<String> wordExceptions = [
  'a',
  'e',
  'g',
  'i',
  'an',
  'pl',
  'the',
  'smb',
  'etc',
  'smth',
  'sing',
];

const String kBaseCourse = 'tote-2';

const String kAppTitle = 'Ase-English';

const String gradientDarkBlue =
    'assets/images/icons/cource/gradientDarkBlue.png';
const String gradientOrange = 'assets/images/icons/cource/gradientOrange.png';
const String gradientViolet = 'assets/images/icons/cource/gradientViolet.png';
const String gradientBlue = 'assets/images/icons/cource/gradientBlue.png';

const String kBkgImgBackground = 'assets/images/background/basic.jpeg';
const String kBkgImgLogo = 'assets/images/background/logo_big.png';

const String kBkgImgTitle = 'assets/images/background/textName.png';
const String kBkgImgCompany = 'assets/images/background/aseEnglish.png';

const String kBkgImgCourseHome = 'assets/images/background/bkg_course_home.png';
const String kBkgImgAuthScreen = 'assets/images/background/bkg_auth_screen.png';
const String kBkgImgCardScreen = 'assets/images/background/bkg_card_screen.png';
const String kBkgImgResScreen = 'assets/images/background/bkg_res_screen.png';

const String kImgCircleLearned = 'assets/images/background/i_circle_learn.png';
const String kImgCircleRepeat = 'assets/images/background/i_circle_repit.png';
const String kImgCircleResult = 'assets/images/background/i_circle_result.png';

const String kIconCurrectAnswer = 'assets/images/icons/current_answer.png';
const String kIconIncurrectAnswer = 'assets/images/icons/incorrect_answer.png';
const String kIconAudioPlay = 'assets/images/icons/sound.png';
const String kIconAudioPause = 'assets/images/icons/pause.png';

// Colors
const Color kAppBarColor = Color(0xAAF8F8F8);
const Color kCatalogBackgroundColor = Color(0xAAD9E7F9);

// База - база
const Color kWhite100 = Colors.white;
const Color kBlack100 = Colors.black;
const Color kGrey100 = Colors.grey;

// Основные цвета
const Color kStandartBlueColor = Color(0xAA007AFF);
const Color kStandartGreyColor = Color(0xAA999999);
const Color kStandartYellowColor = Color(0xAAF7FF00);
const Color kStandartYellowColor20 = Color(0x33F7FF00);
const Color kStandartGreenColor = Color(0xAA45D22A);
const Color kStandartLightRedColor = Color(0xAAFE7052);
const Color kStandartRedColor = Color(0xAAE2083A);

// Цвета под вопросом.
const Color kPeacockBlue100 = Color(0xAA025EA1);
const Color kPowderBlue100 = Color(0xAABCE0FD);
const Color kLogoBlue = Color(0xAA004E93);
const Color kDividerCorotGrey = Color(0xAA313133);
const Color kTextGreyColor = Color(0xAA7F7F7F);
const Color kWordSizeBasckground = Color(0xAAC2CBD4);
const Color kIconGreyColor = Color(0xAA8E959B);
const Color kGreyBackground80 = Color(0xAAEFEFF4);
const Color kGreyBackground = Color(0xFFEFEFF4);
const Color kBlueBackground = Color(0xAAEAF5FF);
const Color kBlueBackgroundX50 = Color(0x50999999);

const Color kGreyBorderColor = Color(0x993C3C3C);

const Color kPeacockBlue85 = Color(0xCC025EA1);

// Prefix UID
const String kPrefixRandom = '9990';
const String kPrefixAudit = '9999';
const String kPrefixCourse = '1000';
const String kPrefixTopic = '2000';
const String kPrefixCards = '3000';
const String kPrefixIncorrects = '3100';
const String kPrefixSourse = '3200';
const String kPrefixProcess = '5000';

// FontStile
// !!!Шрифты под вопросом, возможно Катя из заменит!!!!
// ------------------------------------------------------
// size 8sp, peacock_blue
const TextStyle kInfoTextStyle02 = TextStyle(
  fontFamily: 'SFPro-Regular',
  letterSpacing: 0.2,
  fontSize: 14.0,
  color: kPeacockBlue100,
);
// size 9sp, spacing 4sp, peacock_blue
const TextStyle kInfoTextStyle01 = TextStyle(
  fontFamily: 'SFPro-Regular',
  fontSize: 16.0,
  wordSpacing: 4.0,
  color: kPeacockBlue100,
);
// size 14sp, spacing 2sp, powder_blue
const TextStyle kEditTextStyle = TextStyle(
  fontFamily: 'SFPro-Regular',
  fontSize: 24.0,
  color: kPowderBlue100,
);
const TextStyle kButtonWhiteTextStyle = TextStyle(
  fontFamily: 'SFPro-Regular',
  fontSize: 16.0,
  color: kWhite100,
);
// ------------------------------------------------------

const TextStyle kSFProR_Blue_18 = TextStyle(
  fontFamily: 'SFPro-Regular',
  fontSize: 18.0,
  color: kStandartBlueColor,
);

const TextStyle kSFProR_Green_18 = TextStyle(
  fontFamily: 'SFPro-Regular',
  fontSize: 18.0,
  color: Color(0xff4caf50),
);

const TextStyle kSFProR_LightRed_18 = TextStyle(
  fontFamily: 'SFPro-Regular',
  fontSize: 18.0,
  color: kStandartLightRedColor,
);

const TextStyle kCardTranslateTextStyle = TextStyle(
  fontSize: 21.9,
  fontFamily: 'SFPro-Regular',
  color: kGrey100,
);
const TextStyle kSFProR_Grey_18 = TextStyle(
  fontFamily: 'SFPro-Regular',
  fontSize: 18.0,
  color: kGrey100,
);
const TextStyle kCardDescriptionTextStyle = TextStyle(
  fontSize: 17.1,
  fontFamily: 'SFPro-Regular',
  color: kGrey100,
);
const TextStyle kSFProR_Grey_14 = TextStyle(
  fontFamily: 'SFPro-Regular',
  fontSize: 14.0,
  color: kGrey100,
);

const TextStyle kSFProR_Black_34 = TextStyle(
  fontFamily: 'SFPro-Regular',
  fontSize: 34.0,
  color: kBlack100,
);
const TextStyle kSFProR_Black_34_Bold = TextStyle(
  fontFamily: 'SFPro-Regular',
  fontWeight: FontWeight.bold,
  fontSize: 34.0,
  color: kBlack100,
);
const TextStyle kSFProR_BLack_21 = TextStyle(
  fontSize: 21.0,
  fontFamily: 'SFPro-Regular',
  color: kBlack100,
);
const TextStyle kSFProR_Black_18 = TextStyle(
  fontFamily: 'SFPro-Regular',
  fontSize: 18.0,
  color: kBlack100,
);
const TextStyle kSFProR_Black_18_Bold = TextStyle(
  fontFamily: 'SFPro-Regular',
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
  color: kBlack100,
);
const TextStyle kSFProR_Black_14 = TextStyle(
  fontFamily: 'SFPro-Regular',
  fontSize: 14.0,
  color: kBlack100,
);

const TextStyle kSFProR_White_34 = TextStyle(
  fontFamily: 'SFPro-Regular',
  fontSize: 34.0,
  color: kWhite100,
);
const TextStyle kSFProR_White_34_Bold = TextStyle(
  fontFamily: 'SFPro-Regular',
  fontWeight: FontWeight.bold,
  fontSize: 34.0,
  color: kWhite100,
);
const TextStyle kSFProR_White_16 = TextStyle(
  fontFamily: 'SFPro-Regular',
  fontSize: 16.0,
  color: kWhite100,
);

const TextStyle kErrorTextStyle_17 = TextStyle(
  fontSize: 17.0,
  fontFamily: 'SFPro-Regular',
  color: kStandartRedColor,
);

const TextStyle kSFProR_Blue_16 = TextStyle(
  fontFamily: 'SFPro-Regular',
  fontSize: 16.0,
  color: kPeacockBlue100,
);
const TextStyle kSFProR_Blue_30 = TextStyle(
  fontFamily: 'SFPro-Regular',
  fontSize: 30.0,
  color: kPeacockBlue100,
);
const TextStyle kSFProR_Blue_30_Bold = TextStyle(
  fontFamily: 'SFPro-Regular',
  fontWeight: FontWeight.bold,
  fontSize: 30.0,
  color: kPeacockBlue100,
);
const TextStyle kSFProR_Blue_52 = TextStyle(
  fontFamily: 'SFPro-Regular',
  fontSize: 52.0,
  color: kPeacockBlue100,
);
//
const TextStyle rosatomR45 = TextStyle(
  fontFamily: 'RosatomR45',
  fontSize: 22.0,
  color: kBlack100,
);

const TextStyle rosatomR56 = TextStyle(
  fontFamily: 'RosatomR56',
  fontSize: 18.0,
  color: kBlack100,
);

const TextStyle rosatomR75 = TextStyle(
  fontFamily: 'RosatomR75',
  fontSize: 28.0,
  color: kBlack100,
);
