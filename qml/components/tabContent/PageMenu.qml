import QtQuick 2.0
Item {

    width: 300
    height: pageMenu.height
Rectangle {
    color: '#cccccc'
    anchors.fill: parent
}

Column {

    id: pageMenu
    width: parent.width
    property int itemHeight: 30

    Row {
        id: pageButtons
        height: parent.itemHeight
        MouseArea {
            height: parent.height
            width: parent.height

            Text {
                anchors.centerIn: parent
                text: '←'
            }
            onClicked: window.goBack()
        }

        MouseArea {
            height: parent.height
            width: parent.height

            Text {
                anchors.centerIn: parent
                text: '→'
            }

            onClicked: window.goForward()
        }
        MouseArea {
            height: parent.height
            width: parent.height

            Text {
                anchors.centerIn: parent
                text: 'ø'
            }
            onClicked: window.reload()
        }
    }
    MouseArea {
        width: pageMenu.width
        height: pageMenu.itemHeight
        property bool isActive: { settings.values['AdBlockPlusEnabled'] === 'true' }
        onClicked: {
            settings.set('AdBlockPlusEnabled', !isActive)
        }
        Rectangle {
            anchors.fill: parent
            color: parent.isActive ? '#ffffff':'transparent'
        }
        Text {
            anchors.fill: parent
            text: (parent.isActive ? '🗹' : '☐') + ' ' + qsTr("Block Ads")
        }
    }
}
}
