.phony: gen-splash, gen-icon, rename

gen-splash:
	dart run flutter_native_splash:create

gen-icon:
	dart run flutter_launcher_icons

rename:
	dart pub global run rename setAppName --value "Noimann Academy" --targets ios,android,windows,macos
