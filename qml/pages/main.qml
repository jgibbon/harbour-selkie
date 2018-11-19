import QtQuick 2.9
import QtQuick.Window 2.2
import "../components/tabContent"
import "../debug"
import "../"
import selkie.helpers 1.0

import QtWebEngine 1.4

Window {
    id: window
    visible: true
    width: 640
    height: 480
    title: qsTr("Selkie")
    property alias tabsModel: tabsModel
    property alias tabsView: tabsView
    property alias settings: settings
    signal requestScreenshots()
    function validateUrl(value) {
      return /^(?:(?:(?:https?|ftp):)?\/\/)(?:\S+(?::\S*)?@)?(?:(?!(?:10|127)(?:\.\d{1,3}){3})(?!(?:169\.254|192\.168)(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)(?:\.(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)*(?:\.(?:[a-z\u00a1-\uffff]{2,})))(?::\d{2,5})?(?:[/?#]\S*)?$/i.test(value);
    }
    function getValidUrl(url) {
        //        if()
        if(validateUrl(url)) {
            return url;
        }
        else if(url.indexOf('http') !== 0) {
            return 'https://'+url
        }

        return url;
    }

    function openUrl(url, tabIndex){
        console.log('openUrl', url, tabIndex);
        if(!url) {
            return;
        }

        if(tabsView.currentIndex !== -1) {//happens with new tabs initial load
            tabIndex = tabsView.currentIndex
        }

//        console.log('openUrl', url, tabIndex)
        tabsModel.set(tabIndex, {url: url})
    }
    function openUrlInNewTab(url, background){
//        console.log('open url in new tab', url)
        tabsModel.append({url:url,title:'',icon:'',screenshot:''})
        if(!background) {
            tabsView.currentIndex = tabsModel.count - 1
        }

    }
    function closeTab(tabIndex){
        if(tabsModel.count === 1) {
            Qt.quit()
        }

        if(typeof tabIndex === 'undefined' || tabIndex < 0) {
            tabIndex = tabsView.currentIndex
        }
        //        if(tabIndex === tabsView.currentIndex && tabIndex === tabsModel.count - 1) {
        //            tabsView.currentIndex = tabsView.currentIndex - 1
        //        }
        console.log('removing tab', tabIndex)
        tabsModel.remove(tabIndex)
    }

    function goBack(){
        tabsView.currentItem.webView.goBack();
    }
    function goForward(){
        tabsView.currentItem.webView.goForward();
    }

    function reload(noCache){
        if(noCache) {
            tabsView.currentItem.webView.reloadAndBypassCache();
        } else {
            tabsView.currentItem.webView.reload();
        }

    }
    AdBlockQQuickHelper{
        id: adblock
//        Component.onCompleted: {
//            console.log('.................ADBLOCK HELPER............');
//            console.log(JSON.stringify(Object.keys(adblock)))
////            console.log('num subscr', getNumSubscriptions())
//            var num = getNumSubscriptions();
//            for(var i=0;i<num;i++) {
//                console.log(JSON.stringify(getSubscription(i)));
//            }
//        }
    }

    SettingsWrapper {
        id: settings
    }

    ListModel {
        id: tabsModel
    }
    ListView {
        id: tabsView
        model: tabsModel
        interactive: false
        anchors {
            top: parent.top
            left: parent.left
            bottom: tabBar.top
            right: parent.right
        }

        add: Transition {
            PropertyAnimation { property: 'opacity'; easing.type: Easing.InOutCubic; from:0;to:1;duration: 2000;        }
        }
        delegate: Item {
            width: 0 //prevent scrolling
            height: 0
            id: tab
            z: tab.ListView.isCurrentItem ? 2:0
            property alias webView: tabItem.webView
            property alias lastScrollWasDown: tabItem.lastScrollWasDown
            TabItem {
                id: tabItem
                property url currentUrl: url
                property bool active: tab.ListView.isCurrentItem
                opacity: active ? 1 : 0
                onActiveChanged: {
                    console.log('active', index, active)
                }

                onCurrentUrlChanged: {
//                    console.log('tab i',index, 'url changed from outside')
                    if(currentUrl !== webView.url) {
                        webView.url = currentUrl
                    }
                }

                width: tabsView.width
                height: tabsView.height
                Component.onCompleted: {
                    webView.url = currentUrl;
//                    console.log('completed', width, height, x, y, tabsView.contentX, tabsView.contentY)
                }
            }

        }
    }

    TabBar {
        id: tabBar
        states: [
            State {
                name: 'hidden'
                when: tabsView.currentItem.lastScrollWasDown
                AnchorChanges {
                    target: tabBar
                    anchors.top: parent.bottom
                    anchors.bottom: undefined
                }
            }

        ]
        transitions: Transition {
            AnchorAnimation { duration: 300;easing.type: Easing.InOutQuad }
        }

        width: parent.width
        anchors {
            bottom: parent.bottom
        }

    }
    TabOverview {
        id: tabOverview
        anchors {
            top: parent.top
            bottom: parent.bottom
        }

        states: [
            State {
                name: 'hidden'
                when: !tabOverview.enabled

                AnchorChanges {
                    target: tabOverview
                    anchors.top: parent.bottom
                    anchors.bottom: undefined
                }
            }

        ]
        transitions: Transition {
            AnchorAnimation { duration: 300;easing.type: Easing.InOutQuad }
        }

    }

    Component.onCompleted: {
//        webProfile.userScripts.push(nightModeScript);
//        console.log('--------USERSCRIPTS')
//        console.log(webProfile.userScripts.length);
//        openUrlInNewTab('https://en.wikipedia.org/wiki/Selkie');
        openUrlInNewTab('https://www.heise.de');

//        console.log('settings', typeof settings)

//        console.log('OK there', typeof app.getDomainStylesheet, app.getDomainStylesheet("https://www.heise.de/"))
    }
}
