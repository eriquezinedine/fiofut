.PHONY: init fix-isar

ISAR_DIR = $(HOME)/.pub-cache/hosted/pub.dev/isar_flutter_libs-3.1.0+1/android

init:
	@echo ">> pub get: packages/model"
	@cd packages/model && flutter pub get
	@echo ">> pub get: packages/app_core"
	@cd packages/app_core && flutter pub get
	@echo ">> pub get: packages/app_ui"
	@cd packages/app_ui && flutter pub get
	@echo ">> pub get: packages/authentication"
	@cd packages/authentication && flutter pub get
	@echo ">> pub get: app"
	@flutter pub get
	@echo ">> done"

fix-isar:
	@echo ">> Patching isar_flutter_libs for AGP 8+..."
	@sed -i '' 's/package="dev.isar.isar_flutter_libs" //' $(ISAR_DIR)/src/main/AndroidManifest.xml
	@grep -q 'namespace' $(ISAR_DIR)/build.gradle || sed -i '' 's/android {/android {\n    namespace "dev.isar.isar_flutter_libs"/' $(ISAR_DIR)/build.gradle
	@echo ">> done"
