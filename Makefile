TARGET := iphone:clang:latest:15.0
THEOS_PACKAGE_SCHEME = rootless
ARCHS = arm64

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MGSpoof
MGSpoof_FILES = Tweak.xm
MGSpoof_CFLAGS = -fobjc-arc
MGSpoof_LIBRARIES = MobileGestalt

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += mgspoofhelper
include $(THEOS_MAKE_PATH)/aggregate.mk