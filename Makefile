GODOT = godot
VERSION = $(shell grep "config/version" project.godot | cut -d'"' -f2)
BIN_DIR = bin

GREEN      := \033[0;32m
CYAN       := \033[0;36m
YELLOW     := \033[0;33m
RED        := \033[0;31m
NC         := \033[0m

all:
	@$(MAKE) check_dir
	@$(MAKE) linux
	@$(MAKE) windows
	@$(MAKE) android
	@echo -e "$(GREEN)All builds finished!$(NC)"

linux: check_dir
	@echo -e "$(CYAN)--- Building Linux v$(VERSION) ---$(NC)"
	@mkdir -p $(BIN_DIR)/linux
	@$(GODOT) --headless --export-release "Linux x86_64" $(BIN_DIR)/linux/catucatch_$(VERSION).x86_64 || echo -e "$(RED)Error building Linux$(NC)"

windows: check_dir
	@echo -e "$(CYAN)--- Building Windows v$(VERSION) ---$(NC)"
	@mkdir -p $(BIN_DIR)/windows
	@$(GODOT) --headless --export-release "Windows Desktop" $(BIN_DIR)/windows/catucatch_$(VERSION).exe || echo -e "$(RED)Error building Windows$(NC)"

android: check_dir
	@echo -e "$(CYAN)--- Building Android v$(VERSION) ---$(NC)"
	@mkdir -p $(BIN_DIR)/android
	@$(GODOT) --headless --export-release "Android" $(BIN_DIR)/android/catucatch_$(VERSION).apk || echo -e "$(RED)Error building Android$(NC)"

check_dir:
	@if [ ! -d "$(BIN_DIR)" ]; then \
		echo -e "$(YELLOW)Warning: Directory '$(BIN_DIR)' not found.$(NC)"; \
		echo -e "$(GREEN)Creating $(NC)'$(BIN_DIR)'$(GREEN) and its subdirectories..."; \
		mkdir -p $(BIN_DIR)/linux $(BIN_DIR)/windows $(BIN_DIR)/android; \
	fi

check:
	@echo -e "$(CYAN)Project Version: $(GREEN)$(VERSION)$(NC)"
	@if [ -d "$(BIN_DIR)" ]; then echo -e "$(CYAN)Bin directory: $(GREEN)OK$(NC)"; else echo "$(CYAN)Bin directory: $(YELLOW)MISSING$(NC)"; fi

clean:
	@if [ -d "$(BIN_DIR)" ]; then \
		rm -rf $(BIN_DIR); \
		echo -e "$(CYAN)--- Cleaned up all builds ---$(NC)"; \
	else \
		echo -e "$(YELLOW)Nothing to clean.$(NC)"; \
	fi

.PHONY: all linux windows android clean check check_dir help
