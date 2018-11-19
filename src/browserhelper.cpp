//#include "browserhelper.h"


//#include "Downloads/DownloadManager.h"
//#include "Network/NetworkAccessManager.h"

//BrowserHelper::BrowserHelper()
//{

//}
//BrowserHelper *BrowserHelper::instance()
//{
//    static BrowserHelper *helperInstance;
//    return new BrowserHelper helperInstance();
//}
//void BrowserHelper::init() {

//    // Get default profile and private profile

////    auto webProfile = QWebEngineProfile::defaultProfile();

//    webProfile = new QQuickWebEngineProfile();
//    privateProfile = new QQuickWebEngineProfile();


//    // Instantiate request interceptor
//    requestInterceptor = new RequestInterceptor();

//    // Load settings
////    settings = std::make_shared<Settings>();
//    settings = new Settings();

//    requestInterceptor->setSettings(settings);


//    webProfile->setRequestInterceptor(requestInterceptor);
//    privateProfile->setRequestInterceptor(requestInterceptor);

//    webProfile->setStorageName("Profile");
//    privateProfile->setOffTheRecord(true);


//    // Initialize download manager
//    m_downloadMgr = new DownloadManager;
//    m_downloadMgr->setDownloadDir(settings->getValue(Settings::BrowserSetting::DownloadDir).toString());
////    connect(webProfile, &QWebEngineProfile::downloadRequested, m_downloadMgr, &DownloadManager::onDownloadRequest);
////    connect(m_privateProfile, &QWebEngineProfile::downloadRequested, m_downloadMgr, &DownloadManager::onDownloadRequest);



//    // Create network access managers
//    m_networkAccessMgr = new NetworkAccessManager;
////    m_networkAccessMgr->setCookieJar(m_cookieJar);

//    m_downloadMgr->setNetworkAccessManager(m_networkAccessMgr);

//    m_privateNetworkAccessMgr = new NetworkAccessManager;
////    CookieJar *privateJar = new CookieJar(enableCookies, true);
////    m_privateNetworkAccessMgr->setCookieJar(privateJar);

//    qDebug() << "browserhelper awesome! ";

//    // Load ad block subscriptions (will do nothing if disabled)
////    m_adblockMgr = new AdBlockManager(this);
////    AdBlockManager::instance().loadSubscriptions();

////    m_requestInterceptor->setSettings(m_settings);
//}
//QQuickWebEngineProfile *BrowserHelper::getWebProfile()
//{
//    return this->webProfile;
//}
//QQuickWebEngineProfile *BrowserHelper::getPrivateProfile()
//{
//    return this->privateProfile;
//}

//DownloadManager *BrowserHelper::getDownloadManager()
//{
//    return m_downloadMgr;
//}

////AdBlockManager *BrowserHelper::getAdBlockManager()
////{
////    return m_adblockMgr;
////}


//NetworkAccessManager *BrowserHelper::getNetworkAccessManager()
//{
//    return m_networkAccessMgr;
//}

//NetworkAccessManager *BrowserHelper::getPrivateNetworkAccessManager()
//{
//    return m_privateNetworkAccessMgr;
//}
//Settings *BrowserHelper::getSettings()
//{
//    return settings;
//}
