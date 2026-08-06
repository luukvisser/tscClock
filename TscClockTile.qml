import QtQuick 2.1
//import qb.base 1.0
import qb.components 1.0

Tile {
    id: tscClockTile

    onClicked: {
        if (app.tscClockSettings)
            app.tscClockSettings.show();
    }

    // --- CENTRED LAYOUT ---
    Column {
        width: parent.width
        anchors.verticalCenter: parent.verticalCenter
        spacing: isNxt ? 8 : 6
        visible: app.centerLayout

        Item {
            width: parent.width
            height: txtTimeBigCentered.implicitHeight

            Text {
                id: txtTimeBigCentered
                text: app.timeStr
                color: (typeof dimmableColors !== 'undefined') ? dimmableColors.clockTileColor : colors.clockTileColor
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: app.showSeconds ? -Math.round((txtSecondsCentered.implicitWidth + (isNxt ? 5 : 4)) / 2) : 0
                font.pixelSize: app.showDayOnDate ? (isNxt ? 75 : 58) : (isNxt ? 65 : 50)
                font.family: qfont.regular.name
            }

            Text {
                id: txtSecondsCentered
                text: app.timeSeconds
                color: (typeof dimmableColors !== 'undefined') ? dimmableColors.clockTileColor : colors.clockTileColor
                anchors {
                    bottom: txtTimeBigCentered.bottom
                    bottomMargin: isNxt ? 11 : 9
                    left: txtTimeBigCentered.right
                    leftMargin: isNxt ? 5 : 4
                }
                font.pixelSize: isNxt ? 30 : 24
                font.family: qfont.regular.name
                visible: app.showSeconds
            }
        }

        Text {
            id: txtDateCentered
            text: app.dateStr
            color: (typeof dimmableColors !== 'undefined') ? dimmableColors.clockTileColor : colors.clockTileColor
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: isNxt ? 32 : 25
            font.family: qfont.regular.name
            visible: app.showDate
            height: app.showDate ? implicitHeight : 0
        }

        Text {
            id: txtTravel1Centered
            text: app.travelTime1Str
            color: (typeof dimmableColors !== 'undefined') ? dimmableColors.clockTileColor : colors.clockTileColor
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: isNxt ? 20 : 16
            font.family: qfont.regular.name
            visible: app.travelTime1Str !== ""
            height: app.travelTime1Str !== "" ? implicitHeight : 0
        }

        Text {
            id: txtTravel2Centered
            text: app.travelTime2Str
            color: (typeof dimmableColors !== 'undefined') ? dimmableColors.clockTileColor : colors.clockTileColor
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: isNxt ? 20 : 16
            font.family: qfont.regular.name
            visible: app.travelTime2Str !== ""
            height: app.travelTime2Str !== "" ? implicitHeight : 0
        }
    }

    // --- ORIGINAL LAYOUT ---
    Text {
        id: txtTimeBig
        text: app.timeStr
        color: (typeof dimmableColors !== 'undefined') ? dimmableColors.clockTileColor : colors.clockTileColor
        anchors {
            baseline: parent.top
            baselineOffset: isNxt ? 70 : 55
            left: parent.left
            leftMargin: app.leftMarginTime
        }
        font.pixelSize: app.showDayOnDate ? (isNxt ? 75 : 58) : (isNxt ? 65 : 50)
        font.family: qfont.regular.name
        visible: !app.centerLayout
    }

    Text {
        id: txtSeconds
        text: app.timeSeconds
        color: (typeof dimmableColors !== 'undefined') ? dimmableColors.clockTileColor : colors.clockTileColor
        anchors {
            bottom: txtTimeBig.bottom
            bottomMargin: isNxt ? 11 : 9
            left: txtTimeBig.right
            leftMargin: isNxt ? 5 : 4
        }
        font.pixelSize: isNxt ? 30 : 24
        font.family: qfont.regular.name
        visible: app.showSeconds && !app.centerLayout
    }

    Text {
        id: txtDate
        text: app.dateStr
        color: (typeof dimmableColors !== 'undefined') ? dimmableColors.clockTileColor : colors.clockTileColor
        anchors {
            baseline: parent.top
            baselineOffset: isNxt ? 120 : 95
            horizontalCenter: parent.horizontalCenter
        }
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: isNxt ? 32 : 25
        font.family: qfont.regular.name
        visible: app.showDate && !app.centerLayout
    }

    Column {
        id: travelColumn
        anchors {
            // Approximate the old single-line baseline (158/125) as a top offset;
            // the first line's ascent (~16/13 px) puts its baseline at that spot.
            top: parent.top
            topMargin: isNxt ? 142 : 112
            horizontalCenter: parent.horizontalCenter
        }
        visible: !app.centerLayout

        Text {
            id: txtTravelTime1
            text: app.travelTime1Str
            color: (typeof dimmableColors !== 'undefined') ? dimmableColors.clockTileColor : colors.clockTileColor
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: isNxt ? 20 : 16
            font.family: qfont.regular.name
            visible: app.travelTime1Str !== ""
            height: app.travelTime1Str !== "" ? implicitHeight : 0
        }

        Text {
            id: txtTravelTime2
            text: app.travelTime2Str
            color: (typeof dimmableColors !== 'undefined') ? dimmableColors.clockTileColor : colors.clockTileColor
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: isNxt ? 20 : 16
            font.family: qfont.regular.name
            visible: app.travelTime2Str !== ""
            height: app.travelTime2Str !== "" ? implicitHeight : 0
        }
    }
}
