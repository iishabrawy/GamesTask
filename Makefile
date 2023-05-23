RUBY := $(shell command -v ruby 2>/dev/null)
HOMEBREW := $(shell command -v brew 2>/dev/null)
BUNDLER := $(shell command -v bundle 2>/dev/null)

# Default target, if no is provided
default: prepareApp

setup: pre_setup check_for_ruby check_for_homebrew

prepareApp: setup all

# Pre-setup steps
pre_setup:
	@echo "iOS project setup ..."

# Check if Ruby is installed
check_for_ruby:
	@echo "Checking for Ruby ..."
ifeq ($(RUBY),)
	$(error Ruby is not installed)
endif

# Check if Homebrew is available
check_for_homebrew:
	@echo "Checking for Homebrew ..."
ifeq ($(HOMEBREW),)
	$(error Homebrew is not installed)
endif

# Install Ruby Gems
install_ruby_gems:
	@echo "Install RubyGems ..."
	@bundle install

install_arkana:
	@echo "Checking if Arkana is installed..."
	@gem list -i arkana || gem install arkana
	@echo "Arkana installation complete."

run_arkana:
	@echo "Run Arkana command..."
	@cd "Games Keys" && arkana -c Games.arkana.yml -e .env -f Games

open_project:
	@echo "Open project..."
	@open Games.xcodeproj

all: \
    install_arkana \
    run_arkana \
    open_project
