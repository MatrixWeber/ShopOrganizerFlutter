
import 'package:shop_organizer/login_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  test('empty email returns error string', () {

    final result = emailValidator('');
    expect(result, 'Email can\'t be empty');
  });

  test('non-empty email returns null', () {

    final result = emailValidator('email');
    expect(result, null);
  });

  test('empty password returns error string', () {

    final result = pwdValidator('');
    expect(result, 'Password can\'t be empty');
  });

  test('non-empty password returns null', () {

    final result = pwdValidator('password');
    expect(result, null);
  });
}