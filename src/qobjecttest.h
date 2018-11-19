#ifndef QOBJECTTEST_H
#define QOBJECTTEST_H

#include <QObject>

class QObjectTest : public QObject
{
    Q_OBJECT
public:
    explicit QObjectTest(QObject *parent = nullptr);

signals:

public slots:
};

#endif // QOBJECTTEST_H