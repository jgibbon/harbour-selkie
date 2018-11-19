import QtQuick 2.0
Flickable {
    id: horizontalSwipeButtons
    property Item selectedItem: null
    property QtObject ngfeffect
    flickableDirection: Flickable.HorizontalFlick
    z: 50
    clip: false
    boundsBehavior: {
        return Flickable.DragAndOvershootBounds;
    }


    onContentXChanged: {
        if(!dragging)
            return;
        if(leftAction.visible && (contentX < -(leftAction.width + 10))) {
            if(selectedItem !== leftAction && ngfeffect)
                ngfeffect.play();
            selectedItem = leftAction;
        }
        else if(rightAction.visible && ((contentX + width) > ((rightAction.x + rightAction.width) + 10))) {

            if(selectedItem !== rightAction && ngfeffect)
                ngfeffect.play();

            selectedItem = rightAction;
        }
        else {
            if(selectedItem && ngfeffect)
                ngfeffect.play();

            selectedItem = null;
            if((!leftAction.visible && contentX < 0) || (!rightAction.visible && contentX > 0)) {
                cancelFlick();
                contentX = 0
            }
        }
    }

    onDraggingChanged: {
        if(dragging) //|| !webView
            return;

        if(selectedItem === leftAction)
            goBack();
        else if(selectedItem === rightAction)
            goForward();

        selectedItem = null;
    }


    Rectangle {
        id: leftAction
        visible: webView.canGoBack
        property bool highlighted: horizontalSwipeButtons.selectedItem === leftAction
        color: highlighted ? '#ff0000' : '#000000'
        height: parent.height
        width:  height
        anchors.right: parent.left
    }

    Rectangle {
        id: rightAction
        visible: webView.canGoForward
        property bool highlighted: horizontalSwipeButtons.selectedItem === rightAction
        color: highlighted ? '#ff0000' : '#000000'
        height: parent.height
        width:  height
        anchors.left: parent.right
    }
}
