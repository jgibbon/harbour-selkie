#include "browserapp.h"
#include "AdBlock/AdBlockManager.h"
//#include "BlockedSchemeHandler.h"
//#include "BookmarkManager.h"
//#include "CookieJar.h"
//#include "CookieWidget.h"
//#include "DatabaseFactory.h"
#include "Downloads/DownloadManager.h"
//#include "ExtStorage.h"
//#include "FaviconStorage.h"
//#include "HistoryManager.h"
//#include "HistoryWidget.h"
//#include "MainWindow.h"
//#include "SearchEngineManager.h"
#include "Settings/Settings.h"
#include "Network/NetworkAccessManager.h"
#include "Network/RequestInterceptor.h"
//#include "UserAgentManager.h"
//#include "UserScriptManager.h"
//#include "ViperSchemeHandler.h"
//#include "WebPage.h"

#include <vector>
#include <QDir>
#include <QUrl>
#include <QDebug>
#include <QWebEngineCookieStore>
#include <QQuickWebEngineProfile>
#include <QQuickWebEngineScript>
//#include <QQuickWebEngineScriptCollection>

BrowserApplication::BrowserApplication(int &argc, char **argv) :
    QGuiApplication(argc, argv)
{
    QCoreApplication::setOrganizationName(QLatin1String("Vaccarelli"));
    QCoreApplication::setApplicationName(QLatin1String("Viper Browser"));
    QCoreApplication::setApplicationVersion(QLatin1String("0.8"));

    setAttribute(Qt::AA_EnableHighDpiScaling, true);
    setAttribute(Qt::AA_UseHighDpiPixmaps, true);
    setAttribute(Qt::AA_DontShowIconsInMenus, false);

//    setWindowIcon(QIcon(QLatin1String(":/logo.png")));

    // Get default profile and private profile
    auto webProfile = QQuickWebEngineProfile::defaultProfile();
    m_privateProfile = new QQuickWebEngineProfile(this);

    // Instantiate request interceptor
    m_requestInterceptor = new RequestInterceptor(this);

    // Instantiate scheme handlers
//    m_viperSchemeHandler = new ViperSchemeHandler(this);
//    m_blockedSchemeHandler = new BlockedSchemeHandler(this);

    // Attach request interceptor and scheme handlers to web profiles
    webProfile->setRequestInterceptor(m_requestInterceptor);
//    webProfile->installUrlSchemeHandler("viper", m_viperSchemeHandler);
//    webProfile->installUrlSchemeHandler("blocked", m_blockedSchemeHandler);

    m_privateProfile->setRequestInterceptor(m_requestInterceptor);
//    m_privateProfile->installUrlSchemeHandler("viper", m_viperSchemeHandler);
//    m_privateProfile->installUrlSchemeHandler("blocked", m_blockedSchemeHandler);

    // Load settings
//    m_settings = std::make_shared<Settings>();
    m_settings = new Settings(this);

    m_requestInterceptor->setSettings(m_settings);

//    // Initialize favicon storage module
//    m_faviconStorage = DatabaseFactory::createWorker<FaviconStorage>(m_settings->getPathValue(BrowserSetting::FaviconPath));

//    // Initialize bookmarks manager
//    m_bookmarks = DatabaseFactory::createWorker<BookmarkManager>(m_settings->getPathValue(BrowserSetting::BookmarkPath));

//    // Initialize cookie jar and cookie manager UI
//    const bool enableCookies = m_settings->getValue(BrowserSetting::EnableCookies).toBool();
//    m_cookieJar = new CookieJar(enableCookies, false);
//    m_cookieJar->setThirdPartyCookiesEnabled(m_settings->getValue(BrowserSetting::EnableThirdPartyCookies).toBool());

//    m_cookieUI = new CookieWidget();
//    webProfile->cookieStore()->loadAllCookies();

    // Initialize download manager
    m_downloadMgr = new DownloadManager;
    m_downloadMgr->setDownloadDir(m_settings->getValue(Settings::BrowserSetting::DownloadDir).toString());
//    connect(webProfile, &QQuickWebEngineProfile::downloadRequested, m_downloadMgr, &DownloadManager::onDownloadRequest);
//    connect(m_privateProfile, &QQuickWebEngineProfile::downloadRequested, m_downloadMgr, &DownloadManager::onDownloadRequest);

//    // Instantiate the history manager
//    m_historyMgr = DatabaseFactory::createWorker<HistoryManager>(m_settings->getPathValue(Settings::BrowserSetting::HistoryPath));
//    m_historyWidget = nullptr;

    // Create network access managers
    m_networkAccessMgr = new NetworkAccessManager;
//    m_networkAccessMgr->setCookieJar(m_cookieJar);

    m_downloadMgr->setNetworkAccessManager(m_networkAccessMgr);

    m_privateNetworkAccessMgr = new NetworkAccessManager;
//    CookieJar *privateJar = new CookieJar(enableCookies, true);
//    m_privateNetworkAccessMgr->setCookieJar(privateJar);

    // Setup user agent manager before settings
//    m_userAgentMgr = new UserAgentManager(m_settings);

    // Setup user script manager
//    m_userScriptMgr = new UserScriptManager(m_settings);

    // Setup extension storage manager
//    m_extStorage = DatabaseFactory::createWorker<ExtStorage>(m_settings->getPathValue(BrowserSetting::ExtensionStoragePath));

    // Apply global web scripts
    installGlobalWebScripts();

    // Apply web settings
//    m_settings->applyWebSettings();

    // Load search engine information
//    SearchEngineManager::instance().loadSearchEngines(m_settings->getPathValue(BrowserSetting::SearchEnginesFile));

    // Load ad block subscriptions (will do nothing if disabled)
    AdBlockManager::instance().loadSubscriptions();

    // Set browser's saved sessions file
//    m_sessionMgr.setSessionFile(m_settings->getPathValue(BrowserSetting::SessionFile));

    // Connect aboutToQuit signal to browser's session management slot
    connect(this, &BrowserApplication::aboutToQuit, this, &BrowserApplication::beforeBrowserQuit);

    // TODO: check if argument has been given (argc > 1) and load the resource into a new window
}

BrowserApplication::~BrowserApplication()
{
//    for (int i = 0; i < m_browserWindows.size(); ++i)
//    {
//        QPointer<MainWindow> m = m_browserWindows.at(i);
//        if (!m.isNull())
//            delete m.data();
//    }

    delete m_downloadMgr;
    delete m_networkAccessMgr;
    delete m_privateNetworkAccessMgr;
//    delete m_historyWidget;
//    delete m_userAgentMgr;
//    delete m_userScriptMgr;
    delete m_privateProfile;
    delete m_requestInterceptor;
//    delete m_viperSchemeHandler;
//    delete m_blockedSchemeHandler;
//    delete m_cookieUI;
}

BrowserApplication *BrowserApplication::instance()
{
    return static_cast<BrowserApplication*>(QGuiApplication::instance());
}

//BookmarkManager *BrowserApplication::getBookmarkManager()
//{
//    return m_bookmarks.get();
//}

//CookieJar *BrowserApplication::getCookieJar()
//{
//    return m_cookieJar;
//}

Settings *BrowserApplication::getSettings()
{
    return m_settings;
}

DownloadManager *BrowserApplication::getDownloadManager()
{
    return m_downloadMgr;
}

//FaviconStorage *BrowserApplication::getFaviconStorage()
//{
//    return m_faviconStorage.get();
//}

//HistoryManager *BrowserApplication::getHistoryManager()
//{
//    return m_historyMgr.get();
//}

//HistoryWidget *BrowserApplication::getHistoryWidget()
//{
////    if (!m_historyWidget)
////    {
////        m_historyWidget = new HistoryWidget;
////        m_historyWidget->setHistoryManager(m_historyMgr.get());
////    }

//    return m_historyWidget;
//}

NetworkAccessManager *BrowserApplication::getNetworkAccessManager()
{
    return m_networkAccessMgr;
}

NetworkAccessManager *BrowserApplication::getPrivateNetworkAccessManager()
{
    return m_privateNetworkAccessMgr;
}

QQuickWebEngineProfile *BrowserApplication::getPrivateBrowsingProfile()
{
    return m_privateProfile;
}

UserAgentManager *BrowserApplication::getUserAgentManager()
{
    return m_userAgentMgr;
}

UserScriptManager *BrowserApplication::getUserScriptManager()
{
    return m_userScriptMgr;
}

CookieWidget *BrowserApplication::getCookieManager()
{
//    m_cookieUI->resetUI();
    return m_cookieUI;
}
QString BrowserApplication::getHostFromUrl(QUrl url) {
    return url.host();
}
//QString getAllScriptsFor(QUrl url)
//{
//    return "";
//}


//ExtStorage *BrowserApplication::getExtStorage()
//{
//    return m_extStorage.get();
//}

//MainWindow *BrowserApplication::getNewWindow()
//{
//    bool firstWindow = m_browserWindows.empty();

//    MainWindow *w = new MainWindow(m_settings, m_bookmarks.get(), m_faviconStorage.get(), false);
//    m_browserWindows.append(w);
//    connect(w, &MainWindow::aboutToClose, this, &BrowserApplication::maybeSaveSession);
//    connect(w, &MainWindow::destroyed, [this, w](){
//        if (m_browserWindows.contains(w))
//            m_browserWindows.removeOne(w);
//    });

//    w->show();

//    // Check if this is the first window since the application has started - if so, handle
//    // the startup mode behavior depending on the user's configuration setting
//    if (firstWindow)
//    {
//        StartupMode mode = static_cast<StartupMode>(m_settings->getValue(BrowserSetting::StartupMode).toInt());
//        switch (mode)
//        {
//            case StartupMode::LoadHomePage:
//                w->loadUrl(QUrl::fromUserInput(m_settings->getValue(BrowserSetting::HomePage).toString()));
//                break;
//            case StartupMode::LoadBlankPage:
//                w->loadBlankPage();
//                break;
//            case StartupMode::RestoreSession:
//                m_sessionMgr.restoreSession(w);
//                break;
//        }

//        AdBlockManager::instance().updateSubscriptions();
//    }

//    return w;
//}

//MainWindow *BrowserApplication::getNewPrivateWindow()
//{
//    MainWindow *w = new MainWindow(m_settings, m_bookmarks.get(), m_faviconStorage.get(), true);
//    m_browserWindows.append(w);
//    connect(w, &MainWindow::destroyed, [this, w](){
//        if (m_browserWindows.contains(w))
//            m_browserWindows.removeOne(w);
//    });

//    w->show();
//    return w;
//}

//void BrowserApplication::clearHistory(HistoryType histType, QDateTime start)
//{
//    // Check if browsing history flag is set
//    if ((histType & HistoryType::Browsing) == HistoryType::Browsing)
//    {
//        if (start.isNull())
//            m_historyMgr->clearAllHistory();
//        else
//            m_historyMgr->clearHistoryFrom(start);

//        emit resetHistoryMenu();
//    }

//    //todo: support clearing form and search data
//}

//void BrowserApplication::clearHistoryRange(HistoryType histType, std::pair<QDateTime, QDateTime> range)
//{
//    // Check for a valid start-end date-time pair
//    if (!range.first.isValid() || !range.second.isValid())
//        return;

//    // Check if browsing history flag is set
//    if ((histType & HistoryType::Browsing) == HistoryType::Browsing)
//    {
//        m_historyMgr->clearHistoryInRange(range);
//        emit resetHistoryMenu();
//    }

//    //todo: support clearing form and search data
//}

void BrowserApplication::installGlobalWebScripts()
{
//    QQuickWebEngineScript printScript;
//    printScript.setInjectionPoint(QQuickWebEngineScript::InjectionPoint::DocumentCreation);
//    printScript.setName(QLatin1String("viper-window-script"));
//    printScript.setRunOnSubframes(true);
//    printScript.setWorldId(QQuickWebEngineScript::MainWorld);
//    printScript.setSourceCode(QLatin1String("(function() { window.print = function() { "
//                                            "window.location = 'viper:print'; }; })()"));

//    QQuickWebEngineScript webChannel;
//    webChannel.setInjectionPoint(QQuickWebEngineScript::DocumentCreation);
//    webChannel.setName(QLatin1String("viper-web-channel"));
//    webChannel.setRunOnSubframes(true);
//    webChannel.setWorldId(QQuickWebEngineScript::ApplicationWorld);

//    QString webChannelJS;
//    QFile webChannelFile(QLatin1String(":/qtwebchannel/qwebchannel.js"));
//    if (webChannelFile.open(QIODevice::ReadOnly))
//        webChannelJS = webChannelFile.readAll();
//    webChannelFile.close();

//    QString webChannelScript;
//    QFile webChannelSetupFile(QLatin1String(":/WebChannelSetup.js"));
//    if (webChannelSetupFile.open(QIODevice::ReadOnly))
//    {
//        webChannelScript = webChannelSetupFile.readAll();
//        webChannelScript = webChannelScript.arg(webChannelJS);
//    }
//    webChannelSetupFile.close();
//    webChannel.setSourceCode(webChannelScript);

//    auto scriptCollection = QQuickWebEngineProfile::defaultProfile()->userScripts();
//    auto privateScriptCollection = m_privateProfile->userScripts();

//    scriptCollection.append(printScript);
//    scriptCollection.append(webChannel);

//    privateScriptCollection.append(printScript);
//    privateScriptCollection.append(webChannel);
}

void BrowserApplication::beforeBrowserQuit()
{
//    StartupMode mode = static_cast<StartupMode>(m_settings->getValue(BrowserSetting::StartupMode).toInt());
//    if (mode != StartupMode::RestoreSession && m_sessionMgr.alreadySaved())
//        return;

//    // Get all windows that can be saved
//    std::vector<MainWindow*> windows;
//    for (int i = 0; i < m_browserWindows.size(); ++i)
//    {
//        QPointer<MainWindow> m = m_browserWindows.at(i);
//        if (!m.isNull() && !m->isPrivate())
//        {
//            windows.push_back(m.data());
//        }
//    }

//    if (!windows.empty())
//        m_sessionMgr.saveState(windows);


//#if (QTWEBENGINECORE_VERSION >= QT_VERSION_CHECK(5, 11, 0))
//    QWebEngineProfile::defaultProfile()->cookieStore()->setCookieFilter(nullptr);
//#endif
}

void BrowserApplication::maybeSaveSession()
{
//    // Note: don't need to check if startup mode is set to restore session, this slot will not be
//    //       activated unless that condition is already met
//    std::vector<MainWindow*> windows;
//    for (int i = 0; i < m_browserWindows.size(); ++i)
//    {
//        QPointer<MainWindow> m = m_browserWindows.at(i);
//        if (!m.isNull() && !m->isPrivate())
//        {
//            windows.push_back(m.data());
//        }
//    }

//    // Only save session in this method if there's one window left. Saving more than one window is
//    // handled by beforeBrowserQuit() method
//    if (windows.empty() || windows.size() > 1)
//        return;

//    m_sessionMgr.saveState(windows);
}
