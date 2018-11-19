#ifndef BROWSERAPPLICATION_H
#define BROWSERAPPLICATION_H

#include <memory>
#include <QGuiApplication>
#include <QDateTime>
#include <QList>
#include <QPointer>

//#include "BookmarkNode.h"
//#include "ClearHistoryOptions.h"
//#include "SessionManager.h"
#include "AdBlock/AdBlockModel.h"
#include "AdBlock/AdBlockSubscription.h"

class BlockedSchemeHandler;
class BookmarkManager;
class CookieJar;
class CookieWidget;
class DownloadManager;
class ExtStorage;
class FaviconStorage;
class HistoryManager;
class HistoryWidget;
class MainWindow;
class RequestInterceptor;
class Settings;
class UserAgentManager;
class UserScriptManager;
class NetworkAccessManager;
class ViperSchemeHandler;


class QQuickWebEngineProfile;

/// Potential modes of operation for the browser startup routine (ie load a home page, restore session, etc)
enum class StartupMode
{
    LoadHomePage   = 0,
    LoadBlankPage  = 1,
    RestoreSession = 2
};

Q_DECLARE_METATYPE(StartupMode)

/**
 * @class BrowserApplication
 * @brief Handles application functionality that is not confined to a single window
 */
class BrowserApplication : public QGuiApplication
{
    Q_OBJECT

    friend class HistoryManager;
    friend class MainWindow;

public:
    /// BrowserApplication constructor
    BrowserApplication(int &argc, char **argv);

    /// BrowserApplication destructor
    ~BrowserApplication();

    /// Returns the browser application singleton
    static BrowserApplication *instance();

//    /// Returns a pointer to the bookmark manager
//    BookmarkManager *getBookmarkManager();

//    /// Returns the cookie jar used for standard (non-private) browsing mode
//    CookieJar *getCookieJar();

    /// Returns a shared pointer to the application settings object
//    std::shared_ptr<Settings> getSettings();
    Settings *getSettings();

    /// Returns the download manager
    DownloadManager *getDownloadManager();

//    /// Returns the favicon storage manager
//    FaviconStorage *getFaviconStorage();

//    /// Returns the history manager
//    HistoryManager *getHistoryManager();

//    /// Returns the history widget
//    HistoryWidget *getHistoryWidget();

    /// Returns the network access manager
    NetworkAccessManager *getNetworkAccessManager();

    /// Returns a network access manager for private browsing
    NetworkAccessManager *getPrivateNetworkAccessManager();

    /// Returns a pointer to the private web browsing profile
    QQuickWebEngineProfile *getPrivateBrowsingProfile();

    /// Returns a pointer to the user agent manager
    UserAgentManager *getUserAgentManager();

    /// Returns a pointer to the user script manager
    UserScriptManager *getUserScriptManager();

    /// Returns the cookie manager
    CookieWidget *getCookieManager();

//    /// Returns a pointer to the extension storage object
//    ExtStorage *getExtStorage();
signals:
    /// Emitted when each browsing window's history menu should reset its contents
    void resetHistoryMenu();

public slots:
//    /// Spawns and returns the pointer to a new browser window
//    MainWindow *getNewWindow();

//    /// Spawns a new browser window, setting it to private browsing mode before returning a pointer to the window
//    MainWindow *getNewPrivateWindow();


//    AdBlockModel *getAdblockModel();
//    QVariant getAdblockModelData(const QModelIndex &index, int role = Qt::DisplayRole);
//    int getAdBlockModelRowCount();


    QString getHostFromUrl(QUrl url);
private slots:
    /// Called when the aboutToQuit signal is emitted. If the user has enabled the session restore feature, their
    /// current windows and tabs will be saved so they can be opened at the start of the next browsing session
    void beforeBrowserQuit();

    /// Called when a browser window is about to be closed. If it is the last window still open, is not private,
    /// and the user enabled the session save feature, this will save the browsing session
    void maybeSaveSession();

protected:
//    /// Clears the given history type(s) from the browser's storage, beginning with the start time until the present.
//    /// If no start time is given, all history will be cleared
//    void clearHistory(HistoryType histType, QDateTime start = QDateTime());

//    /// Clears the given history type(s) from the browser's storage within the given {start, end} date-time range
//    void clearHistoryRange(HistoryType histType, std::pair<QDateTime, QDateTime> range);

private:
    /// Installs core browser scripts into the script collection
    void installGlobalWebScripts();

private:
    /// Application settings
//    std::shared_ptr<Settings> m_settings;
    Settings *m_settings;

//    /// Bookmark management class
//    std::unique_ptr<BookmarkManager> m_bookmarks;

    /// Cookie jar
    CookieJar *m_cookieJar;

    /// Download manager
    DownloadManager *m_downloadMgr;

//    /// Favicon storage manager
//    std::unique_ptr<FaviconStorage> m_faviconStorage;

//    /// Web history manager
//    std::unique_ptr<HistoryManager> m_historyMgr;

//    /// History view UI
//    HistoryWidget *m_historyWidget;

    /// Network access manager
    NetworkAccessManager *m_networkAccessMgr;

    /// Private browsing network access manager
    NetworkAccessManager *m_privateNetworkAccessMgr;

    /// User agent manager
    UserAgentManager *m_userAgentMgr;

    /// User script manager
    UserScriptManager *m_userScriptMgr;

    /// List of browser windows
    QList< QPointer<MainWindow> > m_browserWindows;

//    /// Browsing session manager
//    SessionManager m_sessionMgr;

    /// Request interceptor
    RequestInterceptor *m_requestInterceptor;

    /// viper scheme handler
    ViperSchemeHandler *m_viperSchemeHandler;

    /// AdBlock redirect scheme handler
    BlockedSchemeHandler *m_blockedSchemeHandler;

    /// Private browsing profile
    QQuickWebEngineProfile *m_privateProfile;

    /// Cookie manager
    CookieWidget *m_cookieUI;

//    /// Web extension storage - used to store user script data on a per-script basis rather than per-site
//    std::unique_ptr<ExtStorage> m_extStorage;
};

#define sBrowserApplication BrowserApplication::instance()

#endif // BROWSERAPPLICATION_H
