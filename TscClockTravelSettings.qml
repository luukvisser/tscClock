import QtQuick 2.1
import qb.components 1.0

Screen {
    id: tscClockTravelSettingsScreen

    screenTitle: "Waze reistijd configuratie"

    onShown: {
        addCustomTopRightButton("Opslaan");
        r1StartInput.text = app.route1Start;
        r1EndInput.text = app.route1End;
        r1FromLatInput.text = app.route1FromLat;
        r1FromLonInput.text = app.route1FromLon;
        r1ToLatInput.text = app.route1ToLat;
        r1ToLonInput.text = app.route1ToLon;
        r1LabelInput.text = app.route1Label;
        r1WorkdaysToggle.isSwitchedOn = app.route1WorkdaysOnly;
        r1WindowToggle.isSwitchedOn = app.route1WindowEnabled;
        r2StartInput.text = app.route2Start;
        r2EndInput.text = app.route2End;
        r2FromLatInput.text = app.route2FromLat;
        r2FromLonInput.text = app.route2FromLon;
        r2ToLatInput.text = app.route2ToLat;
        r2ToLonInput.text = app.route2ToLon;
        r2LabelInput.text = app.route2Label;
        r2WorkdaysToggle.isSwitchedOn = app.route2WorkdaysOnly;
        r2WindowToggle.isSwitchedOn = app.route2WindowEnabled;
    }

    onCustomButtonClicked: {
        app.route1Start = r1StartInput.text;
        app.route1End = r1EndInput.text;
        app.route1Label = r1LabelInput.text;
        app.route1FromLat = r1FromLatInput.text;
        app.route1FromLon = r1FromLonInput.text;
        app.route1ToLat = r1ToLatInput.text;
        app.route1ToLon = r1ToLonInput.text;
        app.route1WorkdaysOnly = r1WorkdaysToggle.isSwitchedOn;
        app.route1WindowEnabled = r1WindowToggle.isSwitchedOn;
        app.route2Start = r2StartInput.text;
        app.route2End = r2EndInput.text;
        app.route2Label = r2LabelInput.text;
        app.route2FromLat = r2FromLatInput.text;
        app.route2FromLon = r2FromLonInput.text;
        app.route2ToLat = r2ToLatInput.text;
        app.route2ToLon = r2ToLonInput.text;
        app.route2WorkdaysOnly = r2WorkdaysToggle.isSwitchedOn;
        app.route2WindowEnabled = r2WindowToggle.isSwitchedOn;
        app.saveSettings();
        // Re-evaluate right now so the tile reflects the new settings immediately
        // (clearing routes that are no longer active, fetching ones that are),
        // instead of waiting for the next 1-second tick. Resetting the active
        // flags forces a re-fetch for routes that stay active with new coords.
        app.route1Active = false;
        app.route2Active = false;
        app.checkTravelTimeWindow();
        hide();
    }

    // ── Route 1 ──────────────────────────────────────────────────────────────

    Text {
        id: route1Header
        x: isNxt ? 36 : 30
        y: isNxt ? 60 : 50
        font.pixelSize: isNxt ? 22 : 18
        font.family: qfont.semiBold.name
        text: "Route 1"
    }

    Text {
        id: r1PeriodeLabel
        anchors {
            top: route1Header.bottom
            topMargin: isNxt ? 18 : 14
            left: route1Header.left
        }
        width: isNxt ? 100 : 80
        height: isNxt ? 36 : 28
        font.pixelSize: isNxt ? 18 : 14
        font.family: qfont.regular.name
        text: "Periode:"
        verticalAlignment: Text.AlignVCenter
    }
    Rectangle {
        id: r1StartBox
        anchors {
            left: r1PeriodeLabel.right
            leftMargin: isNxt ? 10 : 8
            verticalCenter: r1PeriodeLabel.verticalCenter
        }
        opacity: r1WindowToggle.isSwitchedOn ? 1.0 : 0.35
        width: isNxt ? 90 : 70
        height: isNxt ? 36 : 28
        border.color: "#aaaaaa"
        border.width: 1
        radius: 2
        color: "white"
        TextInput {
            id: r1StartInput
            anchors {
                fill: parent
                margins: isNxt ? 6 : 4
            }
            font.pixelSize: isNxt ? 18 : 14
            font.family: qfont.regular.name
            color: "#333333"
        }
    }
    Text {
        id: r1TotLabel
        anchors {
            left: r1StartBox.right
            leftMargin: isNxt ? 10 : 8
            verticalCenter: r1PeriodeLabel.verticalCenter
        }
        opacity: r1WindowToggle.isSwitchedOn ? 1.0 : 0.35
        height: isNxt ? 36 : 28
        font.pixelSize: isNxt ? 18 : 14
        font.family: qfont.regular.name
        text: "tot"
        verticalAlignment: Text.AlignVCenter
    }
    Rectangle {
        id: r1EndBox
        anchors {
            left: r1TotLabel.right
            leftMargin: isNxt ? 10 : 8
            verticalCenter: r1PeriodeLabel.verticalCenter
        }
        opacity: r1WindowToggle.isSwitchedOn ? 1.0 : 0.35
        width: isNxt ? 90 : 70
        height: isNxt ? 36 : 28
        border.color: "#aaaaaa"
        border.width: 1
        radius: 2
        color: "white"
        TextInput {
            id: r1EndInput
            anchors {
                fill: parent
                margins: isNxt ? 6 : 4
            }
            font.pixelSize: isNxt ? 18 : 14
            font.family: qfont.regular.name
            color: "#333333"
        }
    }

    Text {
        id: r1LabelText
        anchors {
            top: r1PeriodeLabel.bottom
            topMargin: isNxt ? 12 : 9
            left: r1PeriodeLabel.left
        }
        width: isNxt ? 100 : 80
        height: isNxt ? 36 : 28
        font.pixelSize: isNxt ? 18 : 14
        font.family: qfont.regular.name
        text: "Label:"
        verticalAlignment: Text.AlignVCenter
    }
    Rectangle {
        id: r1LabelBox
        anchors {
            left: r1LabelText.right
            leftMargin: isNxt ? 10 : 8
            verticalCenter: r1LabelText.verticalCenter
        }
        width: isNxt ? 250 : 200
        height: isNxt ? 36 : 28
        border.color: "#aaaaaa"
        border.width: 1
        radius: 2
        color: "white"
        TextInput {
            id: r1LabelInput
            anchors {
                fill: parent
                margins: isNxt ? 6 : 4
            }
            font.pixelSize: isNxt ? 18 : 14
            font.family: qfont.regular.name
            color: "#333333"
        }
    }

    Text {
        id: r1VanLabel
        anchors {
            top: r1LabelText.bottom
            topMargin: isNxt ? 12 : 9
            left: r1LabelText.left
        }
        width: isNxt ? 100 : 80
        height: isNxt ? 36 : 28
        font.pixelSize: isNxt ? 18 : 14
        font.family: qfont.regular.name
        text: "Van:"
        verticalAlignment: Text.AlignVCenter
    }
    Rectangle {
        id: r1FromLatBox
        anchors {
            left: r1FromLatLabel.right
            leftMargin: isNxt ? 6 : 5
            verticalCenter: r1VanLabel.verticalCenter
        }
        width: isNxt ? 105 : 85
        height: isNxt ? 36 : 28
        border.color: "#aaaaaa"
        border.width: 1
        radius: 2
        color: "white"
        TextInput {
            id: r1FromLatInput
            anchors {
                fill: parent
                margins: isNxt ? 6 : 4
            }
            font.pixelSize: isNxt ? 18 : 14
            font.family: qfont.regular.name
            color: "#333333"
        }
    }
    Rectangle {
        id: r1FromLonBox
        anchors {
            left: r1FromLonLabel.right
            leftMargin: isNxt ? 6 : 5
            verticalCenter: r1VanLabel.verticalCenter
        }
        width: isNxt ? 105 : 85
        height: isNxt ? 36 : 28
        border.color: "#aaaaaa"
        border.width: 1
        radius: 2
        color: "white"
        TextInput {
            id: r1FromLonInput
            anchors {
                fill: parent
                margins: isNxt ? 6 : 4
            }
            font.pixelSize: isNxt ? 18 : 14
            font.family: qfont.regular.name
            color: "#333333"
        }
    }

    Text {
        id: r1NaarLabel
        anchors {
            top: r1VanLabel.bottom
            topMargin: isNxt ? 12 : 9
            left: r1VanLabel.left
        }
        width: isNxt ? 100 : 80
        height: isNxt ? 36 : 28
        font.pixelSize: isNxt ? 18 : 14
        font.family: qfont.regular.name
        text: "Naar:"
        verticalAlignment: Text.AlignVCenter
    }
    Rectangle {
        id: r1ToLatBox
        anchors {
            left: r1ToLatLabel.right
            leftMargin: isNxt ? 6 : 5
            verticalCenter: r1NaarLabel.verticalCenter
        }
        width: isNxt ? 105 : 85
        height: isNxt ? 36 : 28
        border.color: "#aaaaaa"
        border.width: 1
        radius: 2
        color: "white"
        TextInput {
            id: r1ToLatInput
            anchors {
                fill: parent
                margins: isNxt ? 6 : 4
            }
            font.pixelSize: isNxt ? 18 : 14
            font.family: qfont.regular.name
            color: "#333333"
        }
    }
    Rectangle {
        id: r1ToLonBox
        anchors {
            left: r1ToLonLabel.right
            leftMargin: isNxt ? 6 : 5
            verticalCenter: r1NaarLabel.verticalCenter
        }
        width: isNxt ? 105 : 85
        height: isNxt ? 36 : 28
        border.color: "#aaaaaa"
        border.width: 1
        radius: 2
        color: "white"
        TextInput {
            id: r1ToLonInput
            anchors {
                fill: parent
                margins: isNxt ? 6 : 4
            }
            font.pixelSize: isNxt ? 18 : 14
            font.family: qfont.regular.name
            color: "#333333"
        }
    }

    Text {
        id: r1WorkdaysLabel
        anchors {
            top: r1WindowLabel.bottom
            topMargin: isNxt ? 12 : 9
            left: route1Header.left
        }
        height: isNxt ? 36 : 28
        font.pixelSize: isNxt ? 18 : 14
        font.family: qfont.regular.name
        text: "Alleen op werkdagen"
        verticalAlignment: Text.AlignVCenter
    }
    OnOffToggle {
        id: r1WorkdaysToggle
        height: isNxt ? 36 : 28
        anchors {
            left: r1WorkdaysLabel.right
            leftMargin: isNxt ? 12 : 10
            verticalCenter: r1WorkdaysLabel.verticalCenter
        }
        leftIsSwitchedOn: false
    }

    // ── Route 2 ──────────────────────────────────────────────────────────────

    Text {
        id: route2Header
        // Second column: aligned to Route 1's top, starting at the screen's
        // horizontal centre so it adapts to the available width.
        anchors {
            top: route1Header.top
            left: parent.horizontalCenter
            leftMargin: isNxt ? 20 : 16
        }
        font.pixelSize: isNxt ? 22 : 18
        font.family: qfont.semiBold.name
        text: "Route 2"
    }

    Text {
        id: r2PeriodeLabel
        anchors {
            top: route2Header.bottom
            topMargin: isNxt ? 18 : 14
            left: route2Header.left
        }
        width: isNxt ? 100 : 80
        height: isNxt ? 36 : 28
        font.pixelSize: isNxt ? 18 : 14
        font.family: qfont.regular.name
        text: "Periode:"
        verticalAlignment: Text.AlignVCenter
    }
    Rectangle {
        id: r2StartBox
        anchors {
            left: r2PeriodeLabel.right
            leftMargin: isNxt ? 10 : 8
            verticalCenter: r2PeriodeLabel.verticalCenter
        }
        opacity: r2WindowToggle.isSwitchedOn ? 1.0 : 0.35
        width: isNxt ? 90 : 70
        height: isNxt ? 36 : 28
        border.color: "#aaaaaa"
        border.width: 1
        radius: 2
        color: "white"
        TextInput {
            id: r2StartInput
            anchors {
                fill: parent
                margins: isNxt ? 6 : 4
            }
            font.pixelSize: isNxt ? 18 : 14
            font.family: qfont.regular.name
            color: "#333333"
        }
    }
    Text {
        id: r2TotLabel
        anchors {
            left: r2StartBox.right
            leftMargin: isNxt ? 10 : 8
            verticalCenter: r2PeriodeLabel.verticalCenter
        }
        opacity: r2WindowToggle.isSwitchedOn ? 1.0 : 0.35
        height: isNxt ? 36 : 28
        font.pixelSize: isNxt ? 18 : 14
        font.family: qfont.regular.name
        text: "tot"
        verticalAlignment: Text.AlignVCenter
    }
    Rectangle {
        id: r2EndBox
        anchors {
            left: r2TotLabel.right
            leftMargin: isNxt ? 10 : 8
            verticalCenter: r2PeriodeLabel.verticalCenter
        }
        opacity: r2WindowToggle.isSwitchedOn ? 1.0 : 0.35
        width: isNxt ? 90 : 70
        height: isNxt ? 36 : 28
        border.color: "#aaaaaa"
        border.width: 1
        radius: 2
        color: "white"
        TextInput {
            id: r2EndInput
            anchors {
                fill: parent
                margins: isNxt ? 6 : 4
            }
            font.pixelSize: isNxt ? 18 : 14
            font.family: qfont.regular.name
            color: "#333333"
        }
    }

    Text {
        id: r2LabelText
        anchors {
            top: r2PeriodeLabel.bottom
            topMargin: isNxt ? 12 : 9
            left: r2PeriodeLabel.left
        }
        width: isNxt ? 100 : 80
        height: isNxt ? 36 : 28
        font.pixelSize: isNxt ? 18 : 14
        font.family: qfont.regular.name
        text: "Label:"
        verticalAlignment: Text.AlignVCenter
    }
    Rectangle {
        id: r2LabelBox
        anchors {
            left: r2LabelText.right
            leftMargin: isNxt ? 10 : 8
            verticalCenter: r2LabelText.verticalCenter
        }
        width: isNxt ? 250 : 200
        height: isNxt ? 36 : 28
        border.color: "#aaaaaa"
        border.width: 1
        radius: 2
        color: "white"
        TextInput {
            id: r2LabelInput
            anchors {
                fill: parent
                margins: isNxt ? 6 : 4
            }
            font.pixelSize: isNxt ? 18 : 14
            font.family: qfont.regular.name
            color: "#333333"
        }
    }

    Text {
        id: r2VanLabel
        anchors {
            top: r2LabelText.bottom
            topMargin: isNxt ? 12 : 9
            left: r2LabelText.left
        }
        width: isNxt ? 100 : 80
        height: isNxt ? 36 : 28
        font.pixelSize: isNxt ? 18 : 14
        font.family: qfont.regular.name
        text: "Van:"
        verticalAlignment: Text.AlignVCenter
    }
    Rectangle {
        id: r2FromLatBox
        anchors {
            left: r2FromLatLabel.right
            leftMargin: isNxt ? 6 : 5
            verticalCenter: r2VanLabel.verticalCenter
        }
        width: isNxt ? 105 : 85
        height: isNxt ? 36 : 28
        border.color: "#aaaaaa"
        border.width: 1
        radius: 2
        color: "white"
        TextInput {
            id: r2FromLatInput
            anchors {
                fill: parent
                margins: isNxt ? 6 : 4
            }
            font.pixelSize: isNxt ? 18 : 14
            font.family: qfont.regular.name
            color: "#333333"
        }
    }
    Rectangle {
        id: r2FromLonBox
        anchors {
            left: r2FromLonLabel.right
            leftMargin: isNxt ? 6 : 5
            verticalCenter: r2VanLabel.verticalCenter
        }
        width: isNxt ? 105 : 85
        height: isNxt ? 36 : 28
        border.color: "#aaaaaa"
        border.width: 1
        radius: 2
        color: "white"
        TextInput {
            id: r2FromLonInput
            anchors {
                fill: parent
                margins: isNxt ? 6 : 4
            }
            font.pixelSize: isNxt ? 18 : 14
            font.family: qfont.regular.name
            color: "#333333"
        }
    }

    Text {
        id: r2NaarLabel
        anchors {
            top: r2VanLabel.bottom
            topMargin: isNxt ? 12 : 9
            left: r2VanLabel.left
        }
        width: isNxt ? 100 : 80
        height: isNxt ? 36 : 28
        font.pixelSize: isNxt ? 18 : 14
        font.family: qfont.regular.name
        text: "Naar:"
        verticalAlignment: Text.AlignVCenter
    }
    Rectangle {
        id: r2ToLatBox
        anchors {
            left: r2ToLatLabel.right
            leftMargin: isNxt ? 6 : 5
            verticalCenter: r2NaarLabel.verticalCenter
        }
        width: isNxt ? 105 : 85
        height: isNxt ? 36 : 28
        border.color: "#aaaaaa"
        border.width: 1
        radius: 2
        color: "white"
        TextInput {
            id: r2ToLatInput
            anchors {
                fill: parent
                margins: isNxt ? 6 : 4
            }
            font.pixelSize: isNxt ? 18 : 14
            font.family: qfont.regular.name
            color: "#333333"
        }
    }
    Rectangle {
        id: r2ToLonBox
        anchors {
            left: r2ToLonLabel.right
            leftMargin: isNxt ? 6 : 5
            verticalCenter: r2NaarLabel.verticalCenter
        }
        width: isNxt ? 105 : 85
        height: isNxt ? 36 : 28
        border.color: "#aaaaaa"
        border.width: 1
        radius: 2
        color: "white"
        TextInput {
            id: r2ToLonInput
            anchors {
                fill: parent
                margins: isNxt ? 6 : 4
            }
            font.pixelSize: isNxt ? 18 : 14
            font.family: qfont.regular.name
            color: "#333333"
        }
    }

    Text {
        id: r2WorkdaysLabel
        anchors {
            top: r2WindowLabel.bottom
            topMargin: isNxt ? 12 : 9
            left: route2Header.left
        }
        height: isNxt ? 36 : 28
        font.pixelSize: isNxt ? 18 : 14
        font.family: qfont.regular.name
        text: "Alleen op werkdagen"
        verticalAlignment: Text.AlignVCenter
    }
    OnOffToggle {
        id: r2WorkdaysToggle
        height: isNxt ? 36 : 28
        anchors {
            left: r2WorkdaysLabel.right
            leftMargin: isNxt ? 12 : 10
            verticalCenter: r2WorkdaysLabel.verticalCenter
        }
        leftIsSwitchedOn: false
    }

    // ── Lat/Lon prefix labels (anchored to the coordinate boxes above) ────────

    Text {
        id: r1FromLatLabel
        anchors {
            left: r1VanLabel.right
            leftMargin: isNxt ? 8 : 6
            verticalCenter: r1VanLabel.verticalCenter
        }
        width: isNxt ? 30 : 24
        height: isNxt ? 36 : 28
        font.pixelSize: isNxt ? 18 : 14
        font.family: qfont.regular.name
        color: "#555555"
        text: "Lat"
        verticalAlignment: Text.AlignVCenter
    }
    Text {
        id: r1FromLonLabel
        anchors {
            left: r1FromLatBox.right
            leftMargin: isNxt ? 10 : 8
            verticalCenter: r1VanLabel.verticalCenter
        }
        width: isNxt ? 30 : 24
        height: isNxt ? 36 : 28
        font.pixelSize: isNxt ? 18 : 14
        font.family: qfont.regular.name
        color: "#555555"
        text: "Lon"
        verticalAlignment: Text.AlignVCenter
    }
    Text {
        id: r1ToLatLabel
        anchors {
            left: r1NaarLabel.right
            leftMargin: isNxt ? 8 : 6
            verticalCenter: r1NaarLabel.verticalCenter
        }
        width: isNxt ? 30 : 24
        height: isNxt ? 36 : 28
        font.pixelSize: isNxt ? 18 : 14
        font.family: qfont.regular.name
        color: "#555555"
        text: "Lat"
        verticalAlignment: Text.AlignVCenter
    }
    Text {
        id: r1ToLonLabel
        anchors {
            left: r1ToLatBox.right
            leftMargin: isNxt ? 10 : 8
            verticalCenter: r1NaarLabel.verticalCenter
        }
        width: isNxt ? 30 : 24
        height: isNxt ? 36 : 28
        font.pixelSize: isNxt ? 18 : 14
        font.family: qfont.regular.name
        color: "#555555"
        text: "Lon"
        verticalAlignment: Text.AlignVCenter
    }
    Text {
        id: r2FromLatLabel
        anchors {
            left: r2VanLabel.right
            leftMargin: isNxt ? 8 : 6
            verticalCenter: r2VanLabel.verticalCenter
        }
        width: isNxt ? 30 : 24
        height: isNxt ? 36 : 28
        font.pixelSize: isNxt ? 18 : 14
        font.family: qfont.regular.name
        color: "#555555"
        text: "Lat"
        verticalAlignment: Text.AlignVCenter
    }
    Text {
        id: r2FromLonLabel
        anchors {
            left: r2FromLatBox.right
            leftMargin: isNxt ? 10 : 8
            verticalCenter: r2VanLabel.verticalCenter
        }
        width: isNxt ? 30 : 24
        height: isNxt ? 36 : 28
        font.pixelSize: isNxt ? 18 : 14
        font.family: qfont.regular.name
        color: "#555555"
        text: "Lon"
        verticalAlignment: Text.AlignVCenter
    }
    Text {
        id: r2ToLatLabel
        anchors {
            left: r2NaarLabel.right
            leftMargin: isNxt ? 8 : 6
            verticalCenter: r2NaarLabel.verticalCenter
        }
        width: isNxt ? 30 : 24
        height: isNxt ? 36 : 28
        font.pixelSize: isNxt ? 18 : 14
        font.family: qfont.regular.name
        color: "#555555"
        text: "Lat"
        verticalAlignment: Text.AlignVCenter
    }
    Text {
        id: r2ToLonLabel
        anchors {
            left: r2ToLatBox.right
            leftMargin: isNxt ? 10 : 8
            verticalCenter: r2NaarLabel.verticalCenter
        }
        width: isNxt ? 30 : 24
        height: isNxt ? 36 : 28
        font.pixelSize: isNxt ? 18 : 14
        font.family: qfont.regular.name
        color: "#555555"
        text: "Lon"
        verticalAlignment: Text.AlignVCenter
    }

    // ── Time-window enable toggles (per route, own row under the coordinates) ──

    Text {
        id: r1WindowLabel
        anchors {
            top: r1NaarLabel.bottom
            topMargin: isNxt ? 12 : 9
            left: route1Header.left
        }
        height: isNxt ? 36 : 28
        font.pixelSize: isNxt ? 18 : 14
        font.family: qfont.regular.name
        text: "Tijdvenster"
        verticalAlignment: Text.AlignVCenter
    }
    OnOffToggle {
        id: r1WindowToggle
        height: isNxt ? 36 : 28
        anchors {
            left: r1WindowLabel.right
            leftMargin: isNxt ? 12 : 10
            verticalCenter: r1WindowLabel.verticalCenter
        }
        leftIsSwitchedOn: false
    }
    Text {
        id: r2WindowLabel
        anchors {
            top: r2NaarLabel.bottom
            topMargin: isNxt ? 12 : 9
            left: route2Header.left
        }
        height: isNxt ? 36 : 28
        font.pixelSize: isNxt ? 18 : 14
        font.family: qfont.regular.name
        text: "Tijdvenster"
        verticalAlignment: Text.AlignVCenter
    }
    OnOffToggle {
        id: r2WindowToggle
        height: isNxt ? 36 : 28
        anchors {
            left: r2WindowLabel.right
            leftMargin: isNxt ? 12 : 10
            verticalCenter: r2WindowLabel.verticalCenter
        }
        leftIsSwitchedOn: false
    }

    // ── Hint ─────────────────────────────────────────────────────────────────

    Text {
        anchors {
            top: r1WorkdaysLabel.bottom
            topMargin: isNxt ? 18 : 12
            left: route1Header.left
        }
        font.pixelSize: isNxt ? 15 : 12
        font.family: qfont.regular.name
        color: "#888888"
        text: "Coördinaten in decimaal formaat (bijv. 52.3704 / 4.8952), tijd als HH:MM"
    }
}
