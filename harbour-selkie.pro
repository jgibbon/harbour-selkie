QT += core quick webengine
CONFIG += c++14

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        src/main.cpp \
    src/Settings/Settings.cpp \
    src/browserhelper.cpp \
#    src/AdBlock/AdBlockButton.cpp \
    src/AdBlock/AdBlockFilter.cpp \
    src/AdBlock/AdBlockFilterParser.cpp \
    src/AdBlock/AdBlockManager.cpp \
    src/AdBlock/AdBlockModel.cpp \
#    src/AdBlock/AdBlockSubscribeDialog.cpp \
    src/AdBlock/AdBlockSubscription.cpp \
#    src/AdBlock/AdBlockWidget.cpp \
#    src/AdBlock/CustomFilterEditor.cpp \
#    src/Network/AuthDialog.cpp \
#    src/Network/BlockedSchemeHandler.cpp \
#    src/Network/CertificateGeneralTab.cpp \
#    src/Network/CertificateViewer.cpp \
#    src/Network/HttpRequest.cpp \
    src/Network/NetworkAccessManager.cpp \
    src/Network/RequestInterceptor.cpp \
#    src/Network/SecurityInfoDialog.cpp \
#    src/Network/SecurityManager.cpp \
    src/Network/ViperNetworkReply.cpp \
#    src/Network/ViperSchemeHandler.cpp \
    src/Web/URL.cpp \
#    src/Web/WebActionProxy.cpp \
#    src/Web/WebDialog.cpp \
#    src/Web/WebHitTestResult.cpp \
#    src/Web/WebPage.cpp \
#    src/Web/WebView.cpp \
#    src/Web/WebWidget.cpp
    src/qobjecttest.cpp \
#    src/Downloads/DownloadItem.cpp \
    src/Downloads/DownloadManager.cpp \
    src/Downloads/InternalDownloadItem.cpp \
    src/browserapp.cpp \
    src/AdBlock/adblockqquickhelper.cpp

RESOURCES += qml/qml.qrc \
    images/images.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    src/Settings/Settings.h \
    src/browserhelper.h \
#    src/AdBlock/AdBlockButton.h \
    src/AdBlock/AdBlockFilter.h \
    src/AdBlock/AdBlockFilterParser.h \
    src/AdBlock/AdBlockManager.h \
    src/AdBlock/AdBlockModel.h \
#    src/AdBlock/AdBlockSubscribeDialog.h \
    src/AdBlock/AdBlockSubscription.h \
#    src/AdBlock/AdBlockWidget.h \
#    src/AdBlock/CustomFilterEditor.h \
#    src/Network/AuthDialog.h \
#    src/Network/BlockedSchemeHandler.h \
#    src/Network/CertificateGeneralTab.h \
#    src/Network/CertificateViewer.h \
#    src/Network/HttpRequest.h \
    src/Network/NetworkAccessManager.h \
    src/Network/RequestInterceptor.h \
#    src/Network/SecurityInfoDialog.h \
#    src/Network/SecurityManager.h \
    src/Network/ViperNetworkReply.h \
#    src/Network/ViperSchemeHandler.h \
    src/Cache/LRUCache.h \
    src/Web/URL.h \
#    src/Web/WebActionProxy.h \
#    src/Web/WebDialog.h \
#    src/Web/WebHitTestResult.h \
#    src/Web/WebPage.h \
#    src/Web/WebView.h \
#    src/Web/WebWidget.h
    src/qobjecttest.h \
#    src/Downloads/DownloadItem.h \
    src/Downloads/DownloadManager.h \
    src/Downloads/InternalDownloadItem.h \
    src/browserapp.h \
    src/AdBlock/adblockqquickhelper.h
