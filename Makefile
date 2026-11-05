.PHONY: build

FLUTTER := fvm flutter

clean:
	@$(FLUTTER) pub run build_runner clean
	@$(FLUTTER) clean
	@rm -rf .dart_tool/build

deep-clean:
	@no | dart pub cache clean
	@make clean

install:
	@$(FLUTTER) pub get
	@cd ios && pod install && cd ..

build:
	@dart run build_runner build

clean-build:
	@make clean
	@make install
	@make build

format:
	@$(FLUTTER) dart format .

# Format and analyze
fa-check:
	@$(FLUTTER) dart format --output=none --set-exit-if-changed .
	@$(FLUTTER) analyze --fatal-infos --fatal-warnings

run-debug:
	@$(FLUTTER) run --debug

run-profile:
	@$(FLUTTER) run --profile

run-release:
	@$(FLUTTER) run --release
