# 冒頭にこれを追加（iOS 16対応のため）
TARGET := iphone:clang:latest:15.0
THEOS_PACKAGE_SCHEME = rootless
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = MGSpoofHelper
MGSpoofHelper_FILES = $(wildcard *.m)
MGSpoofHelper_FRAMEWORKS = UIKit CoreGraphics
MGSpoofHelper_LIBRARIES = MobileGestalt
MGSpoofHelper_CFLAGS = -fobjc-arc
# Rootlessではエンタイトルメントの扱いが厳しいため、そのまま残します
MGSpoofHelper_CODESIGN_FLAGS = -Sent.xml

include $(THEOS_MAKE_PATH)/application.mk

# Rootless環境では install.exec が無いことが多いため、エラー防止で整理
after-install::
	install.exec "killall -9 MGSpoofHelper" || true