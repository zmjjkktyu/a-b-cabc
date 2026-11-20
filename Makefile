export THEOS_PACKAGE_SCHEME = rootless
TARGET := iphone:clang:16.5:14.0
ARCHS = arm64 arm64e
INSTALL_TARGET_PROCESSES = Tips

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Tips18
Tips18_FILES = Tweak.xm
Tips18_CFLAGS = -fobjc-arc
Tips18_FRAMEWORKS = UIKit QuartzCore
Tips18_PRIVATE_FRAMEWORKS = FrontBoardServices

include $(THEOS_MAKE_PATH)/tweak.mk
