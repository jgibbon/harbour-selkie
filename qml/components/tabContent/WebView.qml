import QtQuick 2.0
import QtWebEngine 1.4
Flickable {
    flickableDirection: Flickable.VerticalFlick
    property alias webView: webView
    property int webScrollY: 0
    property bool lastScrollWasDown: false
    clip: true
    boundsBehavior: {
        if(webScrollY > 0)
            return Flickable.StopAtBounds;

        return Flickable.DragAndOvershootBounds;
    }
    onContentYChanged: {

        if(!dragging)
            return;
        if(contentY > 0) {
            cancelFlick();
            contentY = 0;
            return;
        }
    }

//    WebEngineView {
//        id: webViewD
//        width: parent.width / 2
////        anchors.fill: parent
//        anchors {
//            top: parent.top
//            left: webView.right
//            bottom: parent.bottom
//            right: parent.right
//        }
//    }
    ListModel {
        id: certErrors
    }

    WebEngineView {
        id: webView
        anchors.fill: parent
//        anchors {
//            top: parent.top
//            left: parent.left
//            bottom: parent.bottom
//            right: webViewD.left
//        }
//        devToolsView: webViewD
        profile: webProfile
        url: 'about:blank'
        property bool ignoreScroll: false
        property int blockedRequests: 0
        property string host: app.getHostFromUrl(url)
        onHostChanged: {
            console.log('host changed', host);
        }

//        property var certErrors:[]
        property int certErrorLen: certErrors.count
        property bool encrypted: certErrorLen === 0 && url.toString().indexOf('http:') !== 0

        settings.autoLoadImages: window.settings.values.AutoLoadImages === 'true'
        settings.javascriptEnabled: window.settings.values.EnableJavascript === 'true'
        settings.errorPageEnabled: true //settings.values.errorPageEnabled
        settings.pluginsEnabled: window.settings.values.EnablePlugins === 'true'
//        settings.: window.settings.values.AutoLoadImages === 'true'
        settings.fullScreenSupportEnabled: false // settings.values.fullScreenSupportEnabled
//        settings.autoLoadIconsForPage: settings.values.autoLoadIconsForPage
        settings.touchIconsEnabled: true//settings.values.touchIconsEnabled
        Text {

            anchors.right: parent.right
            anchors.bottom: parent.bottom
            text: webView.certErrorLen
        }

        onCertificateError: {
//            error.defer();
            certErrors.append(error)
            console.log('CERT ERROR, ', error.description, certErrors.length);
            error.ignoreCertificateError()
//            sslDialog.enqueue(error);
        }

//        userScripts: [
//            WebEngineScript {
//                    id: nightModeScript
////                    injectionPoint: WebEngineScript.DocumentReady
//                    name: 'nightModeScript'
//                    worldId: WebEngineScript.MainWorld
//                    sourceCode: "
//console.log('starting filter');
//var svg='<svg><filter id=\"selkienightmodeelement\"><feColorMatrix type=\"matrix\" values=\"1 0.2 0 0 0 0 0.3 0.1 0 0 0 0 0.01 0 0 0 0 0 1 0\"></feColorMatrix></filter></svg><style>/*html{filter:url(#selkienightmodeelement);}*/</style>';
//var html=document.firstElementChild;
//var body=document.body;
//body.insertAdjacentHTML('beforeend',svg);
////html.style.filter='url(#selkienightmodeelement)';
////alert(getComputedStyle(html).backgroundColor.replace(/\s/g, ''));
//if(getComputedStyle(html).backgroundColor === 'rgba(0, 0, 0, 0)') {
////alert('setting bg');
//html.style.backgroundColor = '#fff';}
////alert(getComputedStyle(body).backgroundColor.replace(/\s/g, ''));
//if(getComputedStyle(body).backgroundColor === 'rgba(0, 0, 0, 0)') {
////alert('setting bgb'+getComputedStyle(html).backgroundColor);
//body.style.backgroundColor = getComputedStyle(html).backgroundColor;}
//console.log(getComputedStyle(html).filter)
///*alert(document.getElementById('filter-sample').innerHTML);*/"
//                }
//        ]
        onContentsSizeChanged: {
            ignoreScroll: true
        }
//        Timer {
//            id: scrollDirectionDebounce
//        }

        onScrollPositionChanged: {
            if(!ignoreScroll) {
                lastScrollWasDown = webScrollY < scrollPosition.y;
            }
            ignoreScroll = false
            webScrollY = scrollPosition.y
        }
        onUrlChanged: {//update list model
            openUrl(url.toString(), index);
        }
        onTitleChanged: {
            tabsModel.set(index, {title: title})
        }
        onIconChanged: {
            tabsModel.set(index, {icon: icon.toString()})
        }
        property bool needAdBlockScript: true
        onLoadProgressChanged: {
            //adblock
            if(loadProgress === 0){
                console.log('load progress 0')
                // reset adblock counter
                adblock.loadStarted(url)
            }

            if(loadProgress > 0 && loadProgress < 100 && needAdBlockScript) {
                console.log('load progress');
                var scriptText = adblock.getDomainJavaScript(url);
                needAdBlockScript = false;
                if(scriptText !== '') {
                    runJavaScript(scriptText);
                }
            }
            if(window.settings.values.AdBlockPlusEnabled === 'true' && loadProgress === 100) {
                blockedRequests = adblock.getNumberAdsBlocked(url);
                recheckBlockedRequestsTimer.start()
            }
        }
        onLoadingChanged: {
            console.log('loading changed');
            if(!loading) {
                //adblock
                var regex = /'/g;
                var stylesheetText = adblock.getDomainJavaScript(url).replace(regex, "\\'", "g");
                var pageStyleSheetText = adblock.getStylesheet(url).replace(regex, "\\'", "g");
                if(stylesheetText !== '') {
//                    console.log('style', stylesheetText);
                    runJavaScript("document.body.insertAdjacentHTML('beforeend', '<style>" + stylesheetText + "</style>');");
                }
                if(pageStyleSheetText !== '') {
                    runJavaScript("document.body.insertAdjacentHTML('beforeend', '"+pageStyleSheetText+"');");
                }

                needAdBlockScript = true
            } else {
                certErrors.clear();
                console.log('loading');
            }
        }
        Timer { //at least a bit more accurate
            id: recheckBlockedRequestsTimer
            interval: 1000
            onTriggered: {
                var blocked = adblock.getNumberAdsBlocked(url);
                if(blocked > webView.blockedRequests) {
                    recheckBlockedRequestsTimer.start();
                }
                    webView.blockedRequests = blocked;

//                console.log('blocked requests from timer', webView.blockedRequests)
            }
        }
    }

}
