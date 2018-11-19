#ifndef SETTINGS_H
#define SETTINGS_H

#include <QMap>
#include <QSettings>
#include <QObject>



/**
 * @class Settings
 * @brief Used to access and modify configurable settings of the browser
 */
class Settings : public QObject
{

    Q_OBJECT
public:
//    /// Settings constructor - loads browser settings and sets to defaults if applicable
//    Settings();

    explicit Settings(QObject *parent = nullptr);


    /// List of configurable browser settings
    enum BrowserSetting
    {
        /// Base path of configuration files and data stores
        StoragePath,

        /// Path to the bookmarks database file, relative to the storage path
        BookmarkPath,

        /// Path to the web extensions database file, relative to the storage path
        ExtensionStoragePath,

        /// Path to the browsing history database file, relative to the storage path
        HistoryPath,

        /// Path to the favicon database file, relative to the storage path
        FaviconPath,

        /// Name of the search engine information file
        SearchEnginesFile,

        /// Name of the last browsing session information file
        SessionFile,

        /// Name of the user agent collection file
        UserAgentsFile,

        /// Name of the user scripts configuration file
        UserScriptsConfig,

        /// Path of the user scripts storage directory, relative to the storage path
        UserScriptsDir,

        /// Name of the ad blocking configuration file
        AdBlockPlusConfig,

        /// Path of the ad block filter and resource storage directory, relative to the storage path
        AdBlockPlusDataDir,

        /// Name of the third party cookie setting exception file
        ExemptThirdPartyCookieFile,

        /// Home page URL
        HomePage,

        /// Determines the behavior of the browser when it is started
        StartupMode,

        /// Determines whether newly opened tabs will load the home page, or a blank page
        NewTabsLoadHomePage,

        /// User download directory
        DownloadDir,

        /// Determines if the download path should be confirmed before any files are downloaded
        AskWhereToSaveDownloads,

        /// Determines whether or not the 'Do Not Track' header should be sent with network requests
        SendDoNotTrack,

        /// Determines whether or not JavaScript should be enabled
        EnableJavascript,

        /// Determines whether or not JavaScript can open popups
        EnableJavascriptPopups,

        /// Determines whether or not images should be loaded automatically
        AutoLoadImages,

        /// Determines whether or not browser plugins, such as flash, should be enabled
        EnablePlugins,

        /// Determines whether or not cookies can be stored
        EnableCookies,

        /// Determines whether or not third party domains can store cookies when browsing a website
        EnableThirdPartyCookies,

        /// Determines whether or not cookies can be stored after the browser application is closed
        CookiesDeleteWithSession,

        /// Determines whether load requests should be monitored for cross-site scripting attempts
        EnableXSSAudit,

        /// Determines whether or not the bookmark bar should be shown by default
        EnableBookmarkBar,

        /// Determines whether or not a custom user agent string should be sent with network requests
        CustomUserAgent,

        /// Determines whether or not the user script system is enabled
        UserScriptsEnabled,

        /// Determines whether or not the advertisement and malicious content blocking system is enabled
        AdBlockPlusEnabled,

        /// Port of the remote web inspector (for QtWebEngine versions < 5.11)
        InspectorPort,

        /// History storage policy - see \ref HistoryStoragePolicy
        HistoryStoragePolicy,

        /// Determines whether the scroll animator should be enabled
        ScrollAnimatorEnabled,

        /// Determines whether or not all new tabs should be opened in the background, without switching from the current tab
        OpenAllTabsInBackground,

        /// Standard font
        StandardFont,

        /// Serif font
        SerifFont,

        /// Sans-serif font
        SansSerifFont,

        /// Cursive font
        CursiveFont,

        /// Fantasy font
        FantasyFont,

        /// Fixed font
        FixedFont,

        /// Standard font family size
        StandardFontSize,

        /// Fixed font size
        FixedFontSize
    };
    Q_ENUMS(BrowserSetting)


    /// Returns the path to the item associated with the path- or file-related key
    QString getPathValue(BrowserSetting key);

    /// Returns the value associated with the given key
    Q_INVOKABLE QVariant getValue(BrowserSetting key);

    /// Sets the value for the given key
    Q_INVOKABLE void setValue(BrowserSetting key, const QVariant &value);

    /// Returns the value associated with the given key
    Q_INVOKABLE void findKeys();

    /// Returns true if the settings have been created in this session, false if else
    bool firstRun() const;

    /// Applies the web engine settings to the QWebSettings instance
    void applyWebSettings();


signals:
    /// Signal emitted when a settings value has changed
    void valueChanged(QString key, QVariant newValue);
    void keyFound(QString key, QVariant value);

private:
    /// Sets the default browser settings
    void setDefaults();

private:
    /// True if the settings have been created in this session, false if otherwise
    bool m_firstRun;

    /// QSettings object used to access configuration
    QSettings m_settings;

    /// Storage path from settings
    QString m_storagePath;

    /// Mapping of \ref BrowserSetting values to their equivalent key names
    QMap<BrowserSetting, QString> m_settingMap;
};

Q_DECLARE_METATYPE(Settings::BrowserSetting)
#endif // SETTINGS_H
