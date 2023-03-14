// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Find a course you want to learn`
  String get findMsg {
    return Intl.message(
      'Find a course you want to learn',
      name: 'findMsg',
      desc: '',
      args: [],
    );
  }

  /// `Search here..`
  String get search {
    return Intl.message(
      'Search here..',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Dashboard`
  String get dashboard {
    return Intl.message(
      'Dashboard',
      name: 'dashboard',
      desc: '',
      args: [],
    );
  }

  /// `My Courses`
  String get myCourses {
    return Intl.message(
      'My Courses',
      name: 'myCourses',
      desc: '',
      args: [],
    );
  }

  /// `Downloads`
  String get downloads {
    return Intl.message(
      'Downloads',
      name: 'downloads',
      desc: '',
      args: [],
    );
  }

  /// `Qr Scanner`
  String get qrScanner {
    return Intl.message(
      'Qr Scanner',
      name: 'qrScanner',
      desc: '',
      args: [],
    );
  }

  /// `Community`
  String get community {
    return Intl.message(
      'Community',
      name: 'community',
      desc: '',
      args: [],
    );
  }

  /// `Hi, `
  String get hi {
    return Intl.message(
      'Hi, ',
      name: 'hi',
      desc: '',
      args: [],
    );
  }

  /// `My Course`
  String get myCourse {
    return Intl.message(
      'My Course',
      name: 'myCourse',
      desc: '',
      args: [],
    );
  }

  /// `Ongoing`
  String get ongoing {
    return Intl.message(
      'Ongoing',
      name: 'ongoing',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get completed {
    return Intl.message(
      'Completed',
      name: 'completed',
      desc: '',
      args: [],
    );
  }

  /// `Notification`
  String get notification {
    return Intl.message(
      'Notification',
      name: 'notification',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get today {
    return Intl.message(
      'Today',
      name: 'today',
      desc: '',
      args: [],
    );
  }

  /// `Academic Calender`
  String get academicCalender {
    return Intl.message(
      'Academic Calender',
      name: 'academicCalender',
      desc: '',
      args: [],
    );
  }

  /// `Calender`
  String get calender {
    return Intl.message(
      'Calender',
      name: 'calender',
      desc: '',
      args: [],
    );
  }

  /// `Fill Your Profile`
  String get fillYourProfile {
    return Intl.message(
      'Fill Your Profile',
      name: 'fillYourProfile',
      desc: '',
      args: [],
    );
  }

  /// `Enter name`
  String get enterName {
    return Intl.message(
      'Enter name',
      name: 'enterName',
      desc: '',
      args: [],
    );
  }

  /// `Enter mobile number`
  String get enterMobileNo {
    return Intl.message(
      'Enter mobile number',
      name: 'enterMobileNo',
      desc: '',
      args: [],
    );
  }

  /// `No course available`
  String get noCourseAvailable {
    return Intl.message(
      'No course available',
      name: 'noCourseAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Help Center`
  String get helpCenter {
    return Intl.message(
      'Help Center',
      name: 'helpCenter',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get changePassword {
    return Intl.message(
      'Change Password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to log out?`
  String get msgLogout {
    return Intl.message(
      'Are you sure you want to log out?',
      name: 'msgLogout',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Yes, logOut`
  String get yesLogout {
    return Intl.message(
      'Yes, logOut',
      name: 'yesLogout',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Name is Required`
  String get nameIsRequired {
    return Intl.message(
      'Name is Required',
      name: 'nameIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `BirthDate is Required`
  String get birthIsRequired {
    return Intl.message(
      'BirthDate is Required',
      name: 'birthIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Email is Required`
  String get emailIsRequired {
    return Intl.message(
      'Email is Required',
      name: 'emailIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid Email`
  String get validEmail {
    return Intl.message(
      'Please enter a valid Email',
      name: 'validEmail',
      desc: '',
      args: [],
    );
  }

  /// `Mobile is Required`
  String get mobileIsRequired {
    return Intl.message(
      'Mobile is Required',
      name: 'mobileIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid mobile number`
  String get validMobileNo {
    return Intl.message(
      'Please enter a valid mobile number',
      name: 'validMobileNo',
      desc: '',
      args: [],
    );
  }

  /// `Password is Required`
  String get passRequired {
    return Intl.message(
      'Password is Required',
      name: 'passRequired',
      desc: '',
      args: [],
    );
  }

  /// `Password at least 6 character`
  String get validPassword {
    return Intl.message(
      'Password at least 6 character',
      name: 'validPassword',
      desc: '',
      args: [],
    );
  }

  /// `SAVE`
  String get save {
    return Intl.message(
      'SAVE',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Lessons`
  String get lessons {
    return Intl.message(
      'Lessons',
      name: 'lessons',
      desc: '',
      args: [],
    );
  }

  /// `Certificates`
  String get certificates {
    return Intl.message(
      'Certificates',
      name: 'certificates',
      desc: '',
      args: [],
    );
  }

  /// `Course Completed`
  String get courseCompleted {
    return Intl.message(
      'Course Completed',
      name: 'courseCompleted',
      desc: '',
      args: [],
    );
  }

  /// `PDF`
  String get pdf {
    return Intl.message(
      'PDF',
      name: 'pdf',
      desc: '',
      args: [],
    );
  }

  /// `VIDEO`
  String get video {
    return Intl.message(
      'VIDEO',
      name: 'video',
      desc: '',
      args: [],
    );
  }

  /// `Write Review`
  String get writeReview {
    return Intl.message(
      'Write Review',
      name: 'writeReview',
      desc: '',
      args: [],
    );
  }

  /// `Please write review`
  String get validReview {
    return Intl.message(
      'Please write review',
      name: 'validReview',
      desc: '',
      args: [],
    );
  }

  /// `Add community`
  String get addCommunity {
    return Intl.message(
      'Add community',
      name: 'addCommunity',
      desc: '',
      args: [],
    );
  }

  /// `Edit community`
  String get editCommunity {
    return Intl.message(
      'Edit community',
      name: 'editCommunity',
      desc: '',
      args: [],
    );
  }

  /// `Title is Required`
  String get validCommunityTitle {
    return Intl.message(
      'Title is Required',
      name: 'validCommunityTitle',
      desc: '',
      args: [],
    );
  }

  /// `Description is Required`
  String get validCommunityDec {
    return Intl.message(
      'Description is Required',
      name: 'validCommunityDec',
      desc: '',
      args: [],
    );
  }

  /// `UPDATE`
  String get update {
    return Intl.message(
      'UPDATE',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `Find topic that you like to read`
  String get findTopic {
    return Intl.message(
      'Find topic that you like to read',
      name: 'findTopic',
      desc: '',
      args: [],
    );
  }

  /// `Trending Questions`
  String get trendingPosts {
    return Intl.message(
      'Trending Questions',
      name: 'trendingPosts',
      desc: '',
      args: [],
    );
  }

  /// `Popular Topics`
  String get popularTopics {
    return Intl.message(
      'Popular Topics',
      name: 'popularTopics',
      desc: '',
      args: [],
    );
  }

  /// `votes`
  String get votes {
    return Intl.message(
      'votes',
      name: 'votes',
      desc: '',
      args: [],
    );
  }

  /// `replies`
  String get replies {
    return Intl.message(
      'replies',
      name: 'replies',
      desc: '',
      args: [],
    );
  }

  /// `views`
  String get views {
    return Intl.message(
      'views',
      name: 'views',
      desc: '',
      args: [],
    );
  }

  /// `Your Answer`
  String get yourAnswer {
    return Intl.message(
      'Your Answer',
      name: 'yourAnswer',
      desc: '',
      args: [],
    );
  }

  /// `No any user community added`
  String get emptyCommunity {
    return Intl.message(
      'No any user community added',
      name: 'emptyCommunity',
      desc: '',
      args: [],
    );
  }

  /// `No any user answer added`
  String get emptyAnswer {
    return Intl.message(
      'No any user answer added',
      name: 'emptyAnswer',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `DELETE`
  String get delete {
    return Intl.message(
      'DELETE',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure \nyou want to delete community?`
  String get deleteMsg {
    return Intl.message(
      'Are you sure \nyou want to delete community?',
      name: 'deleteMsg',
      desc: '',
      args: [],
    );
  }

  /// `Enter title`
  String get enterTitle {
    return Intl.message(
      'Enter title',
      name: 'enterTitle',
      desc: '',
      args: [],
    );
  }

  /// `Enter description`
  String get enterDec {
    return Intl.message(
      'Enter description',
      name: 'enterDec',
      desc: '',
      args: [],
    );
  }

  /// `Ok`
  String get ok {
    return Intl.message(
      'Ok',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Success!`
  String get success {
    return Intl.message(
      'Success!',
      name: 'success',
      desc: '',
      args: [],
    );
  }

  /// `Alert!`
  String get alert {
    return Intl.message(
      'Alert!',
      name: 'alert',
      desc: '',
      args: [],
    );
  }

  /// `Enroll Course Successful!`
  String get enrollCourseSuccessful {
    return Intl.message(
      'Enroll Course Successful!',
      name: 'enrollCourseSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `You have successfully made payment and enrolled the course`
  String get enrollCourseMsg {
    return Intl.message(
      'You have successfully made payment and enrolled the course',
      name: 'enrollCourseMsg',
      desc: '',
      args: [],
    );
  }

  /// `View Course`
  String get viewCourse {
    return Intl.message(
      'View Course',
      name: 'viewCourse',
      desc: '',
      args: [],
    );
  }

  /// `View E-Receipt`
  String get viewEReceipt {
    return Intl.message(
      'View E-Receipt',
      name: 'viewEReceipt',
      desc: '',
      args: [],
    );
  }

  /// `Recent Questions`
  String get recentQuestion {
    return Intl.message(
      'Recent Questions',
      name: 'recentQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Replies`
  String get replies1 {
    return Intl.message(
      'Replies',
      name: 'replies1',
      desc: '',
      args: [],
    );
  }

  /// `Votes`
  String get votes1 {
    return Intl.message(
      'Votes',
      name: 'votes1',
      desc: '',
      args: [],
    );
  }

  /// `Start Course Again`
  String get startCourseAgain {
    return Intl.message(
      'Start Course Again',
      name: 'startCourseAgain',
      desc: '',
      args: [],
    );
  }

  /// `View Question`
  String get viewQuestion {
    return Intl.message(
      'View Question',
      name: 'viewQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure \nyou want to delete answer?`
  String get deleteAnswerMsg {
    return Intl.message(
      'Are you sure \nyou want to delete answer?',
      name: 'deleteAnswerMsg',
      desc: '',
      args: [],
    );
  }

  /// `Reply message`
  String get replyMessage {
    return Intl.message(
      'Reply message',
      name: 'replyMessage',
      desc: '',
      args: [],
    );
  }

  /// `Continue With App`
  String get continueWithApp {
    return Intl.message(
      'Continue With App',
      name: 'continueWithApp',
      desc: '',
      args: [],
    );
  }

  /// `Hello !`
  String get hello {
    return Intl.message(
      'Hello !',
      name: 'hello',
      desc: '',
      args: [],
    );
  }

  /// `The best place to boost your grades and guarantee your success in national exams`
  String get welcomeMsg {
    return Intl.message(
      'The best place to boost your grades and guarantee your success in national exams',
      name: 'welcomeMsg',
      desc: '',
      args: [],
    );
  }

  /// `LOGIN`
  String get login {
    return Intl.message(
      'LOGIN',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `SIGN UP`
  String get signUp {
    return Intl.message(
      'SIGN UP',
      name: 'signUp',
      desc: '',
      args: [],
    );
  }

  /// `Welcome!`
  String get welcome {
    return Intl.message(
      'Welcome!',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Sign in to continue`
  String get signInToContinue {
    return Intl.message(
      'Sign in to continue',
      name: 'signInToContinue',
      desc: '',
      args: [],
    );
  }

  /// `Enter email`
  String get enterEmail {
    return Intl.message(
      'Enter email',
      name: 'enterEmail',
      desc: '',
      args: [],
    );
  }

  /// `Enter password`
  String get enterPassword {
    return Intl.message(
      'Enter password',
      name: 'enterPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email`
  String get enterYourEmail {
    return Intl.message(
      'Enter your email',
      name: 'enterYourEmail',
      desc: '',
      args: [],
    );
  }

  /// `SUBMIT`
  String get submit {
    return Intl.message(
      'SUBMIT',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot Password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// ` or `
  String get or {
    return Intl.message(
      ' or ',
      name: 'or',
      desc: '',
      args: [],
    );
  }

  /// `Social Media Login`
  String get socialMediaLogin {
    return Intl.message(
      'Social Media Login',
      name: 'socialMediaLogin',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get doNotHaveAccount {
    return Intl.message(
      'Don\'t have an account?',
      name: 'doNotHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// ` Sign up`
  String get signUp1 {
    return Intl.message(
      ' Sign up',
      name: 'signUp1',
      desc: '',
      args: [],
    );
  }

  /// `Hi!`
  String get hi1 {
    return Intl.message(
      'Hi!',
      name: 'hi1',
      desc: '',
      args: [],
    );
  }

  /// `Create a new account`
  String get createNewAccount {
    return Intl.message(
      'Create a new account',
      name: 'createNewAccount',
      desc: '',
      args: [],
    );
  }

  /// `Enter birthdate`
  String get enterBirthdate {
    return Intl.message(
      'Enter birthdate',
      name: 'enterBirthdate',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get alreadyHaveAccount {
    return Intl.message(
      'Already have an account?',
      name: 'alreadyHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// ` Sign in`
  String get signIn {
    return Intl.message(
      ' Sign in',
      name: 'signIn',
      desc: '',
      args: [],
    );
  }

  /// `Login successfully!`
  String get loginSuccessfully {
    return Intl.message(
      'Login successfully!',
      name: 'loginSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Your account is ready to use, You will be redirected to Home page in a few seconds`
  String get loginRedirected {
    return Intl.message(
      'Your account is ready to use, You will be redirected to Home page in a few seconds',
      name: 'loginRedirected',
      desc: '',
      args: [],
    );
  }

  /// `Congratulations!`
  String get congratulations {
    return Intl.message(
      'Congratulations!',
      name: 'congratulations',
      desc: '',
      args: [],
    );
  }

  /// `Enter old password`
  String get enterOldPassword {
    return Intl.message(
      'Enter old password',
      name: 'enterOldPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter new password`
  String get enterNewPassword {
    return Intl.message(
      'Enter new password',
      name: 'enterNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Form`
  String get form {
    return Intl.message(
      'Form',
      name: 'form',
      desc: '',
      args: [],
    );
  }

  /// `Form Details`
  String get formDetails {
    return Intl.message(
      'Form Details',
      name: 'formDetails',
      desc: '',
      args: [],
    );
  }

  /// `Phone no`
  String get phoneNo {
    return Intl.message(
      'Phone no',
      name: 'phoneNo',
      desc: '',
      args: [],
    );
  }

  /// `Subject`
  String get subject {
    return Intl.message(
      'Subject',
      name: 'subject',
      desc: '',
      args: [],
    );
  }

  /// `Message`
  String get message {
    return Intl.message(
      'Message',
      name: 'message',
      desc: '',
      args: [],
    );
  }

  /// `Live chat`
  String get liveChat {
    return Intl.message(
      'Live chat',
      name: 'liveChat',
      desc: '',
      args: [],
    );
  }

  /// `Subject is Required`
  String get subjectIsRequired {
    return Intl.message(
      'Subject is Required',
      name: 'subjectIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Message is Required`
  String get messageIsRequired {
    return Intl.message(
      'Message is Required',
      name: 'messageIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `School name is Required`
  String get schoolNameIsRequired {
    return Intl.message(
      'School name is Required',
      name: 'schoolNameIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Sub division is Required`
  String get subdivisionIsRequired {
    return Intl.message(
      'Sub division is Required',
      name: 'subdivisionIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Enter school name`
  String get enterSchoolName {
    return Intl.message(
      'Enter school name',
      name: 'enterSchoolName',
      desc: '',
      args: [],
    );
  }

  /// `Enter sub division`
  String get enterSubDivision {
    return Intl.message(
      'Enter sub division',
      name: 'enterSubDivision',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Birthdate`
  String get birthdate {
    return Intl.message(
      'Birthdate',
      name: 'birthdate',
      desc: '',
      args: [],
    );
  }

  /// `Mobile no`
  String get mobileNo {
    return Intl.message(
      'Mobile no',
      name: 'mobileNo',
      desc: '',
      args: [],
    );
  }

  /// `School name`
  String get schoolName {
    return Intl.message(
      'School name',
      name: 'schoolName',
      desc: '',
      args: [],
    );
  }

  /// `Sub division`
  String get subDivision {
    return Intl.message(
      'Sub division',
      name: 'subDivision',
      desc: '',
      args: [],
    );
  }

  /// `Ask a Question`
  String get askQuestion {
    return Intl.message(
      'Ask a Question',
      name: 'askQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Questions`
  String get questions {
    return Intl.message(
      'Questions',
      name: 'questions',
      desc: '',
      args: [],
    );
  }

  /// `No question available`
  String get noQuestionAvailable {
    return Intl.message(
      'No question available',
      name: 'noQuestionAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Edit Description`
  String get editDec {
    return Intl.message(
      'Edit Description',
      name: 'editDec',
      desc: '',
      args: [],
    );
  }

  /// `Enter Tag, To Add multiple tag add ',' between to text`
  String get enterTag {
    return Intl.message(
      'Enter Tag, To Add multiple tag add \',\' between to text',
      name: 'enterTag',
      desc: '',
      args: [],
    );
  }

  /// `View Image`
  String get viewImage {
    return Intl.message(
      'View Image',
      name: 'viewImage',
      desc: '',
      args: [],
    );
  }

  /// `No any download`
  String get noAnyDownload {
    return Intl.message(
      'No any download',
      name: 'noAnyDownload',
      desc: '',
      args: [],
    );
  }

  /// `Please leave a review\nfor your course`
  String get reviewDec {
    return Intl.message(
      'Please leave a review\nfor your course',
      name: 'reviewDec',
      desc: '',
      args: [],
    );
  }

  /// `Enter course review`
  String get enterReview {
    return Intl.message(
      'Enter course review',
      name: 'enterReview',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get deleteAccount {
    return Intl.message(
      'Delete Account',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `By deleting this account your course and app data will be removed from this platform.`
  String get deleteAccountMsg {
    return Intl.message(
      'By deleting this account your course and app data will be removed from this platform.',
      name: 'deleteAccountMsg',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete your easy grade account?`
  String get deleteAccountSureMsg {
    return Intl.message(
      'Are you sure you want to delete your easy grade account?',
      name: 'deleteAccountSureMsg',
      desc: '',
      args: [],
    );
  }

  /// `Exit App`
  String get exitApp {
    return Intl.message(
      'Exit App',
      name: 'exitApp',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure \nyou want to exit the app?`
  String get exitAppMsg {
    return Intl.message(
      'Are you sure \nyou want to exit the app?',
      name: 'exitAppMsg',
      desc: '',
      args: [],
    );
  }

  /// `No Internet Connection`
  String get noInternetConnection {
    return Intl.message(
      'No Internet Connection',
      name: 'noInternetConnection',
      desc: '',
      args: [],
    );
  }

  /// `No internet connection, Please check your connection.`
  String get noInternetConnectionMsg {
    return Intl.message(
      'No internet connection, Please check your connection.',
      name: 'noInternetConnectionMsg',
      desc: '',
      args: [],
    );
  }

  /// `Take a photo`
  String get takeAPhoto {
    return Intl.message(
      'Take a photo',
      name: 'takeAPhoto',
      desc: '',
      args: [],
    );
  }

  /// `Choose from library`
  String get chooseFromLibrary {
    return Intl.message(
      'Choose from library',
      name: 'chooseFromLibrary',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en', countryCode: 'US'),
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'fr', countryCode: 'CA'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
