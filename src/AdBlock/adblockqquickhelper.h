#ifndef ADBLOCKQQUICKHELPER_H
#define ADBLOCKQQUICKHELPER_H

#include <QObject>

#include "AdBlockManager.h"
#include "AdBlockModel.h"

class AdBlockQQuickHelper : public QObject
{
    Q_OBJECT
public:
    explicit AdBlockQQuickHelper(QObject *parent = nullptr);
private:
    AdBlockModel *m_adblockmodel;
    AdBlockManager *m_adblockmanager;
signals:

public slots:
    QString getDomainStylesheet(QUrl url);
    QString getStylesheet(QUrl url);
    QString getDomainJavaScript(QUrl url);
    quint64 getRequestsBlockedCount();
    int getNumberAdsBlocked(const QUrl &url);
    int getNumSubscriptions();
    void reloadSubscriptions();
    void toggleSubscriptionEnabled(int index);
    void removeSubscription(int index);
    void loadStarted(const QUrl &url);
    void installSubscription(const QUrl &url);
    void installResource(const QUrl &url);
    QVariantMap getSubscription(int index);
};

#endif // ADBLOCKQQUICKHELPER_H
