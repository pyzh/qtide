
VERSION = 1.0.21
FHS = 1            # ignored except linux
JDLLVER = 8.0.1    # ignored if FHS == 0

android: {
          !equals(QT_MAJOR_VERSION, 5): error(requires Qt5)
          CONFIG += mobility
          MOBILITY +=
          QT -= webkit
          QT -= opengl
          TEMPLATE = lib
          TARGET = jqt }
else: {   TEMPLATE = lib
          QT += webkit
          QT += opengl
          TARGET = jqt }

# to exclude QtWebKit, uncomment the following line
# QT -= webkit
# to exclude OpenGL, uncomment the following line
# QT -= opengl

CONFIG(debug, debug|release) {
rel = debug
} else {
rel = release
}

linux-g++: QMAKE_TARGET.arch = $$QMAKE_HOST.arch
linux-g++-32: QMAKE_TARGET.arch = x86
linux-g++-64: QMAKE_TARGET.arch = x86_64
linux-cross: QMAKE_TARGET.arch = x86
win32-cross-32: QMAKE_TARGET.arch = x86
win32-cross: QMAKE_TARGET.arch = x86_64
win32-g++: QMAKE_TARGET.arch = $$QMAKE_HOST.arch
android: QMAKE_TARGET.arch = arm
linux-raspi: QMAKE_TARGET.arch = arm

win32: arch = win-$$QMAKE_TARGET.arch
android: arch = android-$$QMAKE_TARGET.arch
macx: arch = mac-$$QMAKE_TARGET.arch
unix:!macx: arch = linux-$$QMAKE_TARGET.arch
android: arch = android-$$QMAKE_TARGET.arch

BUILDROOT = build/$$arch/$$rel
TARGETROOT = ../bin/$$arch/$$rel
DESTDIR = $$TARGETROOT
DLLDESTDIR = $$TARGETROOT

OBJECTS_DIR = $$BUILDROOT/obj
MOC_DIR = $$BUILDROOT/moc
RCC_DIR = $$BUILDROOT/rcc
UI_DIR = $$BUILDROOT/ui

linux-raspi: DEFINES += RASPI
unix:!macx {
DEFINES += FHS=$$FHS
} else {
DEFINES += FHS=0
}
DEFINES += JDLLVER=\\\"$$JDLLVER\\\"

win32:CONFIG += dll console
win32-msvc*:DEFINES += _CRT_SECURE_NO_WARNINGS
equals(QT_MAJOR_VERSION, 5): QT += widgets
CONFIG+= release
DEPENDPATH += .
INCLUDEPATH += .

DEFINES += APP_VERSION=\\\"$$VERSION\\\"
DEFINES += "JQT"
!contains(QT,webkit) {
DEFINES += QT_NO_WEBKIT
DEFINES -= QT_WEBKIT
} else {
equals(QT_MAJOR_VERSION, 5) QT += webkitwidgets
!contains(DEFINES,QT_WEBKIT): DEFINES += QT_WEBKIT
}
!contains(QT,opengl) {
DEFINES += QT_NO_OPENGL
DEFINES -= QT_OPENGL
} else {
android: DEFINES += QT_OPENGL_ES_2
!contains(DEFINES,QT_OPENGL): DEFINES += QT_OPENGL
}
greaterThan(QT_VERSION,4.7.0): DEFINES += QT47
greaterThan(QT_VERSION,4.8.0): DEFINES += QT48
equals(QT_MAJOR_VERSION, 5): DEFINES += QT50

# Input
HEADERS += \
 base/base.h base/bedit.h base/comp.h base/dialog.h base/dirm.h base/dlog.h \
 base/fif.h base/fiw.h base/jsvr.h base/menu.h \
 base/nedit.h base/nmain.h base/note.h base/nside.h base/ntabs.h \
 base/pnew.h base/proj.h base/psel.h base/recent.h base/rsel.h \
 base/snap.h base/spic.h base/state.h base/style.h base/svr.h \
 base/tedit.h base/term.h base/util.h base/utils.h \
 base/view.h base/widget.h high/high.h high/highj.h \
 wd/bitmap.h wd/button.h wd/child.h wd/clipboard.h wd/cmd.h \
 wd/checkbox.h wd/combobox.h wd/dateedit.h wd/dspinbox.h wd/dummy.h \
 wd/edit.h wd/editm.h wd/edith.h wd/font.h wd/form.h \
 wd/gl2.h wd/glz.h wd/prtobj.h wd/image.h wd/isigraph.h \
 wd/isigraph2.h wd/layout.h wd/listbox.h \
 wd/menus.h wd/pane.h \
 wd/progressbar.h wd/radiobutton.h \
 wd/slider.h wd/spinbox.h wd/static.h wd/statusbar.h wd/table.h \
 wd/tabs.h wd/tabwidget.h \
 wd/timeedit.h wd/toolbar.h wd/wd.h \
 wd/ogl2.h wd/opengl.h wd/opengl2.h \
 wd/webview.h

!contains(QT,opengl): HEADERS -= wd/ogl2.h wd/opengl.h wd/opengl2.h
!contains(QT,webkit): HEADERS -= wd/webview.h
contains(DEFINES,QT_NO_PRINTER): HEADERS -= wd/glz.h wd/prtobj.h
android:HEADERS += base/qtjni.h

SOURCES += \
 base/comp.cpp base/bedit.cpp base/dialog.cpp \
 base/dirm.cpp base/dirmx.cpp base/dlog.cpp \
 base/fif.cpp base/fifx.cpp base/fiw.cpp base/jsvr.cpp \
 base/menu.cpp base/menuhelp.cpp \
 base/nedit.cpp base/nmain.cpp base/note.cpp base/nside.cpp base/ntabs.cpp \
 base/pnew.cpp base/proj.cpp base/psel.cpp base/recent.cpp base/rsel.cpp \
 base/run.cpp base/snap.cpp base/spic.cpp base/state.cpp base/statex.cpp \
 base/style.cpp base/svr.cpp base/tedit.cpp base/term.cpp \
 base/util.cpp base/utils.cpp base/view.cpp base/widget.cpp \
 high/highj.cpp \
 wd/bitmap.cpp wd/button.cpp wd/child.cpp wd/clipboard.cpp wd/cmd.cpp \
 wd/checkbox.cpp wd/combobox.cpp wd/dateedit.cpp wd/dspinbox.cpp \
 wd/dummy.cpp wd/edit.cpp wd/editm.cpp wd/edith.cpp wd/font.cpp \
 wd/form.cpp wd/gl2.cpp wd/glz.cpp wd/prtobj.cpp wd/image.cpp  \
 wd/isigraph.cpp wd/isigraph2.cpp wd/layout.cpp wd/listbox.cpp wd/mb.cpp \
 wd/menus.cpp wd/pane.cpp \
 wd/progressbar.cpp wd/radiobutton.cpp \
 wd/slider.cpp wd/spinbox.cpp wd/static.cpp wd/statusbar.cpp \
 wd/table.cpp wd/tabs.cpp wd/tabwidget.cpp \
 wd/timeedit.cpp wd/toolbar.cpp wd/wd.cpp \
 wd/ogl2.cpp  wd/opengl.cpp wd/opengl2.cpp \
 wd/webview.cpp

!contains(QT,opengl): SOURCES -= wd/ogl2.cpp wd/opengl.cpp wd/opengl2.cpp
!contains(QT,webkit): SOURCES -= wd/webview.cpp
contains(DEFINES,QT_NO_PRINTER ): SOURCES -= wd/glz.cpp wd/prtobj.cpp
android:SOURCES += base/qtjni.cpp ../main/main.cpp

RESOURCES += lib.qrc

win32:LIBS += -shared
win32-msvc*:LIBS += /DLL
unix:LIBS += -ldl
android:LIBS += -ldl

win32:QMAKE_LFLAGS += -static-libgcc
win32-msvc*:QMAKE_LFLAGS +=
