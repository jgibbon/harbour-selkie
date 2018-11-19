//#ifndef BROWSERHELPER_H
//#define BROWSERHELPER_H

//#include <QObject>
//#include <QList>
//#include <QPointer>
//#include <QDebug>
//#include <QQuickWebEngineProfile>
////#include <QWebEngineCookieStore>
////#include <QQuickWebEngineScript>
//#include "Network/RequestInterceptor.h"

//#include "AdBlock/AdBlockManager.h"
//#include "Settings/Settings.h"
//class QWebEngineProfile;

//class DownloadManager;
//class NetworkAccessManager;
//class BrowserHelper : public QObject
//{

//    Q_OBJECT
//public:
//    BrowserHelper();

//    /// Returns the browser application singleton
//    static BrowserHelper *instance();
//    void init();

//    /// Returns a pointer to the private web browsing profile
//    QQuickWebEngineProfile *getPrivateBrowsingProfile();

//    /// Private browsing profile
//    QQuickWebEngineProfile *privateProfile;

//    /// Private browsing profile
//    QQuickWebEngineProfile *webProfile;

//    /// Request interceptor
//    RequestInterceptor *requestInterceptor;
//    QQuickWebEngineProfile *getWebProfile();
//    QQuickWebEngineProfile *getPrivateProfile();



//    /// Returns the network access manager
//    NetworkAccessManager *getNetworkAccessManager();

//    /// Returns a network access manager for private browsing
//    NetworkAccessManager *getPrivateNetworkAccessManager();

//    /// Returns the download manager
//    DownloadManager *getDownloadManager();

//    /// Returns the adblock manager
////    AdBlockManager *getAdBlockManager();

//    /// Application settings
////    std::shared_ptr<Settings> settings;
//    Settings *settings;
//    Settings *getSettings();
//private:
//    static BrowserHelper m_instance;
//    /// Download manager
//    DownloadManager *m_downloadMgr;

//    /// Network access manager
//    NetworkAccessManager *m_networkAccessMgr;

//    /// Private browsing network access manager
//    NetworkAccessManager *m_privateNetworkAccessMgr;

//    /// Adblock manager
////    AdBlockManager *m_adblockMgr;
//};

////#define sBrowserApplication BrowserHelper::instance()
//#endif // BROWSERHELPER_H
