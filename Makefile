TARGET := iphone:clang:latest:11.0
PACKAGE_VERSION = 1.0.2
ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = uYouCompat

uYouCompat_FILES = Tweak.x
uYouCompat_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
