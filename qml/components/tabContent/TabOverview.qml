import QtQuick 2.0
import QtGraphicalEffects 1.0

import "../../debug"

Item {
    id: tabOverview
    clip: true
    property bool enabled: false
    //    visible: enabled
    width: parent.width
    height: parent.height
    onEnabledChanged: {
        if(enabled) {
            listView.currentIndex = tabsView.currentIndex
            window.requestScreenshots()
        }
    }
    onHeightChanged: {
        if(enabled) {
            window.requestScreenshots()

        }
    }

    VisibleArea {
        name: 'tab overview'
    }

    ListView {
        id: listView
        width: parent.width
        anchors {
            top: parent.top
            bottom: bottomLine.top
            horizontalCenter: parent.horizontalCenter
        }
        property int scrolledVal: listView.contentY - listView.originY
        height: parent.height - bottomLine.height
        currentIndex: tabsView.currentIndex
        model: tabsModel
        focus: parent.enabled
        Keys.onUpPressed: decrementCurrentIndex()
        Keys.onDownPressed: incrementCurrentIndex()
        removeDisplaced: Transition {
            NumberAnimation { easing.type: Easing.InOutCubic; properties: "x,y"; duration: 400 }
        }
        //        MouseArea {
        //            anchors.fill: parent
        //            hoverEnabled: true

        //            propagateComposedEvents: false
        //            onClicked: {
        //                onClicked: tabOverview.enabled = false
        //            }
        //        }
        delegate: Item {
            id: itemDelegate
            width: listView.width * 0.5
            height: listView.height * 0.2
            //            clip: true
            anchors.horizontalCenter: parent.horizontalCenter
            DropShadow {
                                visible: xContainer.opacity == 1
                anchors.fill: xContainer
                horizontalOffset: 0
                verticalOffset: 0
                radius: 8.0
                samples: 17
                color: "#80000000"
                source: xContainer
            }
            property var currentTabData: tabsModel.get(index)
            property string currentTitle: currentTabData ? currentTabData.title : ''
            property string currentIcon: currentTabData ? currentTabData.icon : ''
            Item {
                id: xContainer
                width: parent.width
                height: parent.height

                Behavior on x {
                    enabled: !itemMouseArea.pressed
                    PropertyAnimation {duration: 200;}
                }

                Behavior on opacity {
                    //                    enabled: !itemMouseArea.pressed
                    PropertyAnimation {duration: 200;}
                }

                Rectangle {
                    id: clipContainer
                    anchors.fill: parent
                    clip: true
                    radius: 5
                    //            VisibleArea {
                    //                name: 'tab'+index
                    //                border.color: '#ffffff'
                    //                border.width: 1
                    //                radius: 3
                    //            }
                    ShaderEffectSource {
                        width: parent.width
                        height: listView.height * 0.5
                        live: visible
                        visible: index === tabsView.currentIndex
                        sourceItem: tabsView.currentItem.webView
//                        y: 20
                    }
                    Image {
                        source: screenshot
                        visible: index !== tabsView.currentIndex
                        width: parent.width
                        height: listView.height * 0.5
//                        y: 20
                    }
                    Rectangle {
                        anchors.fill: parent;
                        color: 'transparent'
                        border.color: 'white'
                        border.width: 1
                    }

                    Item {
                        id: tabHeader
                        width: parent.width
                        height: 20
                        LinearGradient {
                            anchors.fill: parent
                            start: Qt.point(0, 0)
                            end: Qt.point(0, height)
                            gradient: Gradient {
                                GradientStop { position: 0.0; color: "white" }
                                GradientStop { position: 1.0; color: Qt.rgba(1,1,1,0.2) }
                            }
                        }
//                        radius: 5
                        Image {
                            id: tabIcon
                            height: parent.height * 0.6
                            width: height
                            source: currentIcon !== ''?currentIcon : "../../../images/icon-m-document.svg"
                            anchors {
                                left: parent.left
                                verticalCenter: parent.verticalCenter
                                margins: 5
                            }
                        }

                        Item {
                            id: tabTitleItem
                            height: parent.height
                            anchors {
                                left: tabIcon.right
                                right: parent.right
                                verticalCenter: parent.verticalCenter
                                margins: 5
                            }
                            Text {
                                id: tabTitle
                                text: currentTitle
                                width: parent.width
                                anchors.verticalCenter: parent.verticalCenter

                                visible: true
                            }
                        }

                        //                    LinearGradient {
                        //                        visible: false
                        //                        id: mask
                        //                        anchors.fill: tabTitle
                        //                        start: Qt.point(width - tabCloseMouseArea.width*1.5 , 0)
                        //                        end: Qt.point(width - tabCloseMouseArea.width*0.5, 0)
                        //                        gradient: Gradient {
                        //                            GradientStop { position: 0; color: "#ffffff"}
                        //                            GradientStop { position: 1; color: "transparent" }
                        //                        }
                        //                    }

                        //                    OpacityMask {
                        //                        source: tabTitle
                        //                        maskSource: mask
                        //                        anchors.fill: tabTitle
                        //                    }
                    }
                }
            }

            MouseArea {
                id: itemMouseArea
                anchors.fill:  parent
                propagateComposedEvents: false
                onClicked: {
                                        tabsView.currentIndex = index
                                        tabOverview.enabled = false
                }
                enabled: !listView.dragging
                onEnabledChanged: {
                    if(!enabled) {
                        returnXTimer.start()
                    }
                }

                property int threshold: width / 3
                property int startX
                property bool removeOnReleased: false
                property int targetX: 0
                property real targetOpacity: 1
                onPressed: {
                    console.log(mouse.x)
                    startX = mouseX
                }
                onMouseXChanged: {
                    if(tabsModel.count === 1) {
                        return;
                    }

                    var diff = mouseX - startX,
                            abs = Math.abs(diff);
                    if(abs > threshold/2)
                        listView.interactive = false
                    if(abs > threshold) {
                        //                        console.log('', mouseX - startX)
                        removeOnReleased = true
                        xContainer.opacity = 0.2 //threshold / abs * 2;

                        targetX = diff > 0 ? listView.width : -listView.width
                    } else {
                        removeOnReleased = false
                        xContainer.opacity = 1
                        targetX = 0
                        targetOpacity = 1
                    }

                    xContainer.x = diff;

                    //                    console.log(mouseX - startX)
                }
                onReleased: {

                    listView.interactive = true
                    returnXTimer.start()
                }
                Timer {
                    id: returnXTimer
                    interval: 2
                    onTriggered: {
                        xContainer.x = itemMouseArea.targetX
                        xContainer.opacity = itemMouseArea.targetOpacity
                        if(itemMouseArea.removeOnReleased) {
                            console.log('remove')
                            closeTab(index)
                        }
                    }
                }
            }
        }
    }

    Item {
        id: bottomLine
        anchors.bottom: parent.bottom
        width: parent.width
        height: 40
        MouseArea {
            anchors.fill: parent
            onClicked: tabOverview.enabled = false

        }
        VisibleArea {
            name: 'close'
        }


        Text {
            anchors.top: parent.top
            text: listView.contentY - listView.originY
        }
        Text {
            anchors.bottom: parent.bottom
            text: listView.height * 0.8
        }
    }
}
