#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtWebEngine>
#include <QSharedPointer>


#include <QAbstractItemModel>

#include "browserapp.h"
//#include "browserhelper.h"
#include "Settings/Settings.h"
#include "AdBlock/AdBlockManager.h"
#include "AdBlock/adblockqquickhelper.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

//    QCoreApplication::setOrganizationName(QLatin1String("Gibbon"));
//    QCoreApplication::setApplicationName(QLatin1String("Selkie Browser"));

    BrowserApplication app(argc, argv);

    QtWebEngine::initialize();


//    BrowserHelper *helper = sBrowserApplication;//new BrowserHelper();
//    helper->init();


    QQmlApplicationEngine engine;
//    AdBlockModel *adblockModel = AdBlockManager::instance().getModel();

//    QSortFilterProxyModel proxyModel;
//    proxyModel.setSortRole(AdBlockModel::Name)
//    proxyModel.setSourceModel(adblockModel)
//    QVariant adData = adblockModel->data();
//    Settings *settings = app.getSettings();
//    QSharedPointer settingsPointer = new QSharedPointer(sBrowserApplication->getSettings());
//    engine.setObjectOwnership(, QQmlApplicationEngine::CppOwnership);
    qmlRegisterType<AdBlockQQuickHelper>("selkie.helpers",1,0,"AdBlockQQuickHelper");
    qmlRegisterType<Settings>("selkie.settings", 1, 0, "Settings");
//    engine.rootContext()->setContextProperty("app", app);
    engine.rootContext()->setContextProperty("webProfile", QQuickWebEngineProfile::defaultProfile());
    engine.rootContext()->setContextProperty("privateProfile", app.getPrivateBrowsingProfile());

//    engine.rootContext()->setContextProperty("BrowserSetting", BrowserSetting);
    engine.rootContext()->setContextProperty("csettings", sBrowserApplication->getSettings());
//    engine.rootContext()->setContextProperty("adblockModel", sBrowserApplication->getAdblockModel());
    engine.rootContext()->setContextProperty("app", sBrowserApplication);


    engine.load(QUrl(QStringLiteral("qrc:/pages/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    // Load settings
//    m_settings = std::make_shared<Settings>();
    return app.exec();
}
