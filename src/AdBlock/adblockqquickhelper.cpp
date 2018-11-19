#include "adblockqquickhelper.h"

AdBlockQQuickHelper::AdBlockQQuickHelper(QObject *parent) : QObject(parent)
{
    m_adblockmodel = AdBlockManager::instance().getModel();
    m_adblockmanager = &AdBlockManager::instance();
}

QString AdBlockQQuickHelper::getDomainStylesheet(QUrl url)
{
    return m_adblockmanager->getDomainStylesheet(url);
}
QString AdBlockQQuickHelper::getStylesheet(QUrl url)
{
    return m_adblockmanager->getStylesheet(url);
}
QString AdBlockQQuickHelper::getDomainJavaScript(QUrl url)
{
    return m_adblockmanager->getDomainJavaScript(url);
}
 quint64 AdBlockQQuickHelper::getRequestsBlockedCount()
{
    return m_adblockmanager->getRequestsBlockedCount();
}
int AdBlockQQuickHelper::getNumberAdsBlocked(const QUrl &url)
 {
     return m_adblockmanager->getNumberAdsBlocked(url);
 }
int AdBlockQQuickHelper::getNumSubscriptions()
{
//    return m_adblockmanager->getModel()->rowCount();
    return m_adblockmanager->getNumSubscriptions();
}
void AdBlockQQuickHelper::reloadSubscriptions()
{
    return m_adblockmanager->reloadSubscriptions();
}
void AdBlockQQuickHelper::toggleSubscriptionEnabled(int index)
{
    return m_adblockmanager->toggleSubscriptionEnabled(index);
}
void AdBlockQQuickHelper::removeSubscription(int index)
{
    return m_adblockmanager->removeSubscription(index);
}
void AdBlockQQuickHelper::loadStarted(const QUrl &url)
 {
     return m_adblockmanager->loadStarted(url);
 }
void AdBlockQQuickHelper::installSubscription(const QUrl &url)
{
    return m_adblockmanager->installSubscription(url);
}
void AdBlockQQuickHelper::installResource(const QUrl &url)
{
    return m_adblockmanager->installResource(url);
}
QVariantMap AdBlockQQuickHelper::getSubscription(int index)
{
    QVariantMap map;
    const AdBlockSubscription *sub = m_adblockmanager->getSubscription(index);
    //TODO nullptr check?!
    map.insert("isEnabled", sub->isEnabled());
    map.insert("name", sub->getName());
    map.insert("sourceUrl", sub->getSourceUrl());
    map.insert("lastUpdate", sub->getLastUpdate());
    map.insert("nextUpdate", sub->getNextUpdate());
    return map;
}
