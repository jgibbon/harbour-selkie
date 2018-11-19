import QtQuick 2.0
import "../../debug"

HorizontalSwipeButtons {
    id: tabChromeItem
    states: [
        State {
            name: 'urlInputFocussed'
            when: urlInput.focus

            AnchorChanges { target: urlBarItem; anchors.right: parent.right }
            AnchorChanges { target: menuButtonsRow; anchors.left: parent.right; anchors.right: undefined }
            PropertyChanges {target: menuButtonsRow; opacity: 0; z: 0}
            PropertyChanges {
                target: urlInput
                color: '#ffffff'
            }
            PropertyChanges {
                target: connectionSecureMouseArea
                width: 0
                opacity: 0
            }
        },
        State {

        }

    ]
    property bool menuButtonPressed: false

    Rectangle {
        anchors.fill: parent
        color: '#cfcfcf'
    }
    transitions: Transition {
        AnchorAnimation { duration: 300;easing.type: Easing.InOutQuad }
        PropertyAnimation { duration:300; properties: "width,x,y,opacity"; easing.type: Easing.InOutQuad }
    }

        Item {
            id: urlBarItem
            height: parent.height
            anchors {
                top: parent.top
                left: parent.left
                right: menuButtonsRow.left
            }
//            VisibleArea {
//                name: 'urlbar'
//            }

            MouseArea {
                id: connectionSecureMouseArea
                height: parent.height
                width: height
                onClicked: {
                    urlInput.focus = false
                }

                Image {
                    id: connectionStateImage
                    width: parent.width * 0.7
                    height: width
                    anchors.centerIn: parent
                    property bool isSecure: webView.encrypted
                    source: isSecure
                            ? "../../../images/icon-s-secure.svg"
                            : "../../../images/icon-s-insecure.svg"
                }
                Text {
//                    visible: webView.certErrors.length > 0
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    text:webView.certErrorLen
                }


            }

            TextInput {
                id: urlInput
                x: 31
                y: 15
                text: currentUrl
                font.pixelSize: 12
                verticalAlignment: TextInput.AlignVCenter
                anchors {
                    left: connectionSecureMouseArea.right
                    right: parent.right
                    top: parent.top
                    bottom: parent.bottom
                }

//                VisibleArea {
//                    name: 'input'
//                    opacity: 0.2
//                }
                Keys.onReturnPressed: Keys.onEnterPressed(event)
                Keys.onEnterPressed: {
                    console.log('enter', text)
                    window.openUrl(window.getValidUrl(text));
                }

//                MouseArea {
//                    anchors.fill: parent
//                    onClicked: {
//                        parent.focus
//                    }
//                }
            }
        }

        Row {
            id: menuButtonsRow
            height: parent.height
            Behavior on opacity {

            }

            anchors {
                right: parent.right
                top: parent.top
            }

//            Item {
//                height: parent.height
//                width: height
//                VisibleArea {
//                    name: 'first button'
//                }
//            }

            MouseArea {
                height: parent.height
                width: height
                Rectangle {
                    width: parent.width * 0.8
                    height: width
                    anchors.centerIn: parent
                    border.color: '#ffffff'
                    color: 'transparent'
                    radius: 5
                    Text {
                        color: '#ffffff'
                        anchors.centerIn: parent
                        text: tabsModel.count
                    }
                }

                onClicked: {
//                    openUrlInNewTab('https://www.google.com')
                    tabOverview.enabled = true
                }
                onPressAndHold: {
                    closeTab(index)
                }

            }

            MouseArea {
                height: parent.height
                width: height
                Text {
                    text: "···"
                    color: '#ffffff'
                    font.pixelSize: 20
                    anchors.centerIn: parent
                }
                onClicked: {
                    tabChromeItem.menuButtonPressed = !tabChromeItem.menuButtonPressed
                }
            }


    }
}
