import QtQuick 2.0
import QtGraphicalEffects 1.0
import "../../debug"

Item {
    id: tabBar
    height: 30
//    VisibleArea {
//        name: 'tabBar'
//    }

    Rectangle {
        anchors.fill: parent
        color: '#bbbbbb'
    }
    Rectangle {
        width: parent.width
        height: 1
        color: '#dddddd'
    }

    ListView {
        id:tabListView
        property int itemWidth: 100
        property int activeItemWidth: 150
        anchors.fill: parent
        add: Transition {
            PropertyAnimation { property: 'opacity'; easing.type: Easing.InOutCubic; from:0;to:1;duration: 300;}
            PropertyAnimation { property: 'width'; easing.type: Easing.InOutCubic; from:0;to:tabListView.itemWidth;duration: 300;}
        }
        remove: Transition {
            PropertyAnimation { property: 'opacity'; easing.type: Easing.InOutCubic; from:1;to:0;duration: 300;}
            PropertyAnimation { property: 'width'; easing.type: Easing.InOutCubic; to:0;from:tabListView.itemWidth;duration: 300;}
        }
        addDisplaced: Transition {
            PropertyAnimation {property: 'x';easing.type: Easing.InOutCubic;duration: 300;}
        }
        removeDisplaced: Transition {
            PropertyAnimation {property: 'x';easing.type: Easing.InOutCubic;duration: 300;}
        }
        currentIndex: tabsView.currentIndex
        model: tabsModel
        orientation: ListView.Horizontal
//        VisibleArea {
//            name:'listview'
//            opacity: 0.4
//        }
        footer: Item {
            width: newTabMouseArea.width
            height: tabListView.height
        }

        delegate: Item {
            id: tabBarItem
//            property bool isCurrent: tabBarItem.ListView.isCurrentItem
//            onIsCurrentChanged: {
//                width = isCurrent ? tabListView.activeItemWidth : tabListView.itemWidth
//            }

            property var currentTabData: tabsModel.get(index)
            property string currentTitle: currentTabData ? currentTabData.title : ''
            property string currentIcon: currentTabData ? currentTabData.icon : ''
            clip: true
            height: tabBar.height
            width: tabListView.itemWidth

            MouseArea {
                anchors.fill:  parent
                onClicked: {
                    tabsView.currentIndex = index

                }
            }
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

                    visible: false
                }


                LinearGradient {
                    visible: false
                    id: mask
                    anchors.fill: tabTitle
                    start: Qt.point(width - tabCloseMouseArea.width*1.5 , 0)
                    end: Qt.point(width - tabCloseMouseArea.width*0.5, 0)
                    gradient: Gradient {
                        GradientStop { position: 0; color: "#ffffff"}
                        GradientStop { position: 1; color: "transparent" }
                    }
                }

                OpacityMask {
                    source: tabTitle
                    maskSource: mask
                    anchors.fill: tabTitle
                }
            }


            MouseArea {
                id: tabCloseMouseArea
                height: parent.height
                width: height
                propagateComposedEvents: false
                anchors {
                    right: parent.right
                }

                onClicked: {
                    closeTab(index)
                }

                Image {
                    source: "../../../images/icon-m-tab-close.svg"
                    anchors.centerIn: parent
                    width: parent.width * 0.6
                    height: width

                }
            }
        }
        highlightMoveDuration: 300
        highlight: Item {
            width: tabListView.currentItem.width
            clip: true

            Rectangle {
                width: parent.width
                height: tabListView.height + radius
                y: radius * -1
                color: '#cfcfcf'
                border.width: 1
                border.color: '#dddddd'
                radius: 10
            }
        }

//        visible: false
    }

    LinearGradient {
        visible: false
        id: listMask
        anchors.fill: tabListView
        start: Qt.point(width - newTabMouseArea.width*1.5 , 0)
        end: Qt.point(width - newTabMouseArea.width*0.5, 0)
        gradient: Gradient {
            GradientStop { position: 0; color: "#ffffff"}
            GradientStop { position: 1; color: "transparent" }
        }
    }

    OpacityMask {
        source: tabListView
        maskSource: listMask
        anchors.fill: tabListView
    }

    MouseArea {
        id: newTabMouseArea
        width: parent.height
        height: parent.height
        anchors {
            right: parent.right
        }

        onClicked: {
            openUrlInNewTab('https://www.google.com')
        }
        Image {
            width: parent.width * 0.9
            height: width
            anchors.centerIn: parent
            source: "../../../images/icon-m-add.svg"
        }
    }
}
