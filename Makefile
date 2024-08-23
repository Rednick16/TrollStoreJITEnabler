ARCHS = arm64 arm64e
TARGET := iphone:clang:latest:8.0

DEBUG = 0
FINAL_PACKAGE = 1
FOR_RELEASE = 1
GO_EASY_ON_ME = 0

include $(THEOS)/makefiles/common.mk

EXTERNAL_FILES = 
INTERNAL_FILES = $(wildcard *.m)

LIBRARY_NAME = TrollStoreJITEnabler

$(LIBRARY_NAME)_FILES = $(INTERNAL_FILES) $(EXTERNAL_FILES)
$(LIBRARY_NAME)_CFLAGS = -fobjc-arc -fvisibility=hidden
$(LIBRARY_NAME)_FRAMEWORKS = Security UIKit Foundation
$(LIBRARY_NAME)_INSTALL_PATH = @rpath/Frameworks

include $(THEOS_MAKE_PATH)/library.mk
