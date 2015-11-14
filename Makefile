include $(THEOS)/makefiles/common.mk

# FOR_RELEASE=1
ARCHS = armv7 armv7s arm64
TARGET = iphone::8.4:8.4

TWEAK_NAME = PebbleDebug
PebbleDebug_FILES = Tweak.xm
PebbleDebug_FRAMEWORKS = UIKit

BUNDLE_NAME = com.fletchto99.pebbledebug
com.fletchto99.pebbledebug_INSTALL_PATH = /Library/MobileSubstrate/DynamicLibraries

include $(THEOS)/makefiles/bundle.mk
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 PebbleTime PebbleApp"