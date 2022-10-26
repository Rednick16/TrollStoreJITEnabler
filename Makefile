ARCHS = arm64 arm64e
TARGET := iphone:clang:latest:8.0

DEBUG = 0
FINAL_PACKAGE = 1
FOR_RELEASE = 1
GO_EASY_ON_ME = 1

include $(THEOS)/makefiles/common.mk

EXTERNAL_FILES = $(wildcard fishhook/*.c)
INTERNAL_FILES = $(wildcard *.m)

LIBRARY_NAME = TrollStoreJitEnabler

TrollStoreJitEnabler_FILES = $(INTERNAL_FILES) $(EXTERNAL_FILES)
TrollStoreJitEnabler_CFLAGS = -fobjc-arc -fvisibility=hidden
TrollStoreJitEnabler_FRAMEWORKS = Security UIKit Foundation
TrollStoreJitEnabler_INSTALL_PATH = @rpath/Frameworks

include $(THEOS_MAKE_PATH)/library.mk
