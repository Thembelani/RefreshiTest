# Refreshi

Web-first Flutter checkout slice (catalog → checkout → order summary). Architecture and assignment notes are in [SOLUTION.md](SOLUTION.md).

## Run

Use **FVM Flutter 3.38.5 / Dart 3.10.4** only (`fvm flutter`). Generated files are gitignored, so run code generation after `pub get`.

```sh
fvm flutter pub get
fvm flutter pub run build_runner build
fvm flutter run -d chrome
```

iOS / Android from the same codebase:

```sh
fvm flutter run
```

Makefile equivalents: `make install`, `make build`, `make run-debug`.

### Sign-in

- Email: `test@user.com`
- Password: `Test1234`

### Tests

```sh
fvm flutter test
```
