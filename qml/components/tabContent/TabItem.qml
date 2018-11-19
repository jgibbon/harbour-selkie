import QtQuick 2.0
import "../../debug"

Item {
    id: tabRoot
//    anchors.fill: parent
    property alias webView: webContentItem.webView
    property bool lastScrollWasDown: webContentItem.lastScrollWasDown
    property bool menuVisible: navigationBar.menuButtonPressed
    states: [
        State {
            name: 'scrolledDown'
            when: tabRoot.lastScrollWasDown
            AnchorChanges {
                target: webContentItem
                anchors.bottom: parent.bottom
            }
            AnchorChanges {
                target: navigationBar
                anchors.top: parent.bottom
                anchors.bottom: undefined
            }
        }

    ]
    transitions: Transition {
        AnchorAnimation { duration: 300;easing.type: Easing.InOutQuad }
    }

    WebView {
        id: webContentItem
        width: parent.width
//        height: parent.height - navigationBar.height - tabBar.height
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: navigationBar.top
        }
    }
    PageMenu {
        id: pageMenu
        width: parent.width / 3
//        anchors.bottom: parent.bottom
        anchors.top: parent.bottom
        anchors.right: parent.right
        opacity: 0
        states: [
            State {
                name: 'visible'
                when: tabRoot.menuVisible
                AnchorChanges {
                    target: pageMenu
                    anchors.top: undefined
                    anchors.bottom: navigationBar.top
                }
                PropertyChanges {
                    target: pageMenu
                    opacity: 0.9
                }

            }

        ]

        transitions: Transition {
            AnchorAnimation { duration: 300;easing.type: Easing.InOutQuad }
            PropertyAnimation {
                properties: 'opacity'; duration: 300;easing.type: Easing.InOutQuad
            }
        }
    }

    NavigationBar {
        id: navigationBar
        height: 40
//        opacity: parent.webViewScrolledDown ? 0 : 1
        width: parent.width
        anchors {
            bottom: parent.bottom
            right: parent.right
        }

    }
    Connections {
        target: window
        onRequestScreenshots: {
            webView.grabToImage(function(result) {
                                       tabsModel.set(index, {screenshot:result.url.toString()});
                                   },
                                   Qt.size(tabRoot.width/2, tabRoot.height/2));
        }
    }
}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
