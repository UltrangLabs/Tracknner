dev:
	flutter run --dart-define-from-file=.env.dev

test:
	flutter test integration_test/app_test.dart --dart-define-from-file=.env.test

coverage:
	flutter test --coverage --dart-define-from-file=.env.test
	genhtml coverage/lcov.info -o coverage/html