import QtQuick 2.1
import qb.components 1.0

Screen {
	id: tscClockTravelSettingsScreen

	screenTitle: "Reistijd configuratie"

	onShown: {
		addCustomTopRightButton("Opslaan");
		r1StartInput.text      = app.route1Start;
		r1EndInput.text        = app.route1End;
		r1FromLatInput.text    = app.route1FromLat;
		r1FromLonInput.text    = app.route1FromLon;
		r1ToLatInput.text      = app.route1ToLat;
		r1ToLonInput.text      = app.route1ToLon;
		r1WorkdaysToggle.isSwitchedOn = app.route1WorkdaysOnly;
		r2StartInput.text      = app.route2Start;
		r2EndInput.text        = app.route2End;
		r2FromLatInput.text    = app.route2FromLat;
		r2FromLonInput.text    = app.route2FromLon;
		r2ToLatInput.text      = app.route2ToLat;
		r2ToLonInput.text      = app.route2ToLon;
		r2WorkdaysToggle.isSwitchedOn = app.route2WorkdaysOnly;
	}

	onCustomButtonClicked: {
		app.route1Start         = r1StartInput.text;
		app.route1End           = r1EndInput.text;
		app.route1FromLat       = r1FromLatInput.text;
		app.route1FromLon       = r1FromLonInput.text;
		app.route1ToLat         = r1ToLatInput.text;
		app.route1ToLon         = r1ToLonInput.text;
		app.route1WorkdaysOnly  = r1WorkdaysToggle.isSwitchedOn;
		app.route2Start         = r2StartInput.text;
		app.route2End           = r2EndInput.text;
		app.route2FromLat       = r2FromLatInput.text;
		app.route2FromLon       = r2FromLonInput.text;
		app.route2ToLat         = r2ToLatInput.text;
		app.route2ToLon         = r2ToLonInput.text;
		app.route2WorkdaysOnly  = r2WorkdaysToggle.isSwitchedOn;
		app.saveSettings();
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
		anchors { top: route1Header.bottom; topMargin: isNxt ? 18 : 14; left: route1Header.left }
		width: isNxt ? 100 : 80
		height: isNxt ? 36 : 28
		font.pixelSize: isNxt ? 18 : 14
		font.family: qfont.regular.name
		text: "Periode:"
		verticalAlignment: Text.AlignVCenter
	}
	Rectangle {
		id: r1StartBox
		anchors { left: r1PeriodeLabel.right; leftMargin: isNxt ? 10 : 8; verticalCenter: r1PeriodeLabel.verticalCenter }
		width: isNxt ? 90 : 70; height: isNxt ? 36 : 28
		border.color: "#aaaaaa"; border.width: 1; radius: 2; color: "white"
		TextInput {
			id: r1StartInput
			anchors { fill: parent; margins: isNxt ? 6 : 4 }
			font.pixelSize: isNxt ? 18 : 14
			font.family: qfont.regular.name
			color: "#333333"
		}
	}
	Text {
		id: r1TotLabel
		anchors { left: r1StartBox.right; leftMargin: isNxt ? 10 : 8; verticalCenter: r1PeriodeLabel.verticalCenter }
		height: isNxt ? 36 : 28
		font.pixelSize: isNxt ? 18 : 14
		font.family: qfont.regular.name
		text: "tot"
		verticalAlignment: Text.AlignVCenter
	}
	Rectangle {
		id: r1EndBox
		anchors { left: r1TotLabel.right; leftMargin: isNxt ? 10 : 8; verticalCenter: r1PeriodeLabel.verticalCenter }
		width: isNxt ? 90 : 70; height: isNxt ? 36 : 28
		border.color: "#aaaaaa"; border.width: 1; radius: 2; color: "white"
		TextInput {
			id: r1EndInput
			anchors { fill: parent; margins: isNxt ? 6 : 4 }
			font.pixelSize: isNxt ? 18 : 14
			font.family: qfont.regular.name
			color: "#333333"
		}
	}

	Text {
		id: r1VanLabel
		anchors { top: r1PeriodeLabel.bottom; topMargin: isNxt ? 12 : 9; left: r1PeriodeLabel.left }
		width: isNxt ? 100 : 80
		height: isNxt ? 36 : 28
		font.pixelSize: isNxt ? 18 : 14
		font.family: qfont.regular.name
		text: "Van:"
		verticalAlignment: Text.AlignVCenter
	}
	Rectangle {
		id: r1FromLatBox
		anchors { left: r1VanLabel.right; leftMargin: isNxt ? 10 : 8; verticalCenter: r1VanLabel.verticalCenter }
		width: isNxt ? 130 : 105; height: isNxt ? 36 : 28
		border.color: "#aaaaaa"; border.width: 1; radius: 2; color: "white"
		TextInput {
			id: r1FromLatInput
			anchors { fill: parent; margins: isNxt ? 6 : 4 }
			font.pixelSize: isNxt ? 18 : 14
			font.family: qfont.regular.name
			color: "#333333"
		}
	}
	Rectangle {
		id: r1FromLonBox
		anchors { left: r1FromLatBox.right; leftMargin: isNxt ? 10 : 8; verticalCenter: r1VanLabel.verticalCenter }
		width: isNxt ? 130 : 105; height: isNxt ? 36 : 28
		border.color: "#aaaaaa"; border.width: 1; radius: 2; color: "white"
		TextInput {
			id: r1FromLonInput
			anchors { fill: parent; margins: isNxt ? 6 : 4 }
			font.pixelSize: isNxt ? 18 : 14
			font.family: qfont.regular.name
			color: "#333333"
		}
	}

	Text {
		id: r1NaarLabel
		anchors { top: r1VanLabel.bottom; topMargin: isNxt ? 12 : 9; left: r1VanLabel.left }
		width: isNxt ? 100 : 80
		height: isNxt ? 36 : 28
		font.pixelSize: isNxt ? 18 : 14
		font.family: qfont.regular.name
		text: "Naar:"
		verticalAlignment: Text.AlignVCenter
	}
	Rectangle {
		id: r1ToLatBox
		anchors { left: r1NaarLabel.right; leftMargin: isNxt ? 10 : 8; verticalCenter: r1NaarLabel.verticalCenter }
		width: isNxt ? 130 : 105; height: isNxt ? 36 : 28
		border.color: "#aaaaaa"; border.width: 1; radius: 2; color: "white"
		TextInput {
			id: r1ToLatInput
			anchors { fill: parent; margins: isNxt ? 6 : 4 }
			font.pixelSize: isNxt ? 18 : 14
			font.family: qfont.regular.name
			color: "#333333"
		}
	}
	Rectangle {
		id: r1ToLonBox
		anchors { left: r1ToLatBox.right; leftMargin: isNxt ? 10 : 8; verticalCenter: r1NaarLabel.verticalCenter }
		width: isNxt ? 130 : 105; height: isNxt ? 36 : 28
		border.color: "#aaaaaa"; border.width: 1; radius: 2; color: "white"
		TextInput {
			id: r1ToLonInput
			anchors { fill: parent; margins: isNxt ? 6 : 4 }
			font.pixelSize: isNxt ? 18 : 14
			font.family: qfont.regular.name
			color: "#333333"
		}
	}

	Text {
		id: r1WorkdaysLabel
		anchors { top: r1NaarLabel.bottom; topMargin: isNxt ? 12 : 9; left: r1NaarLabel.left }
		height: isNxt ? 36 : 28
		font.pixelSize: isNxt ? 18 : 14
		font.family: qfont.regular.name
		text: "Alleen op werkdagen"
		verticalAlignment: Text.AlignVCenter
	}
	OnOffToggle {
		id: r1WorkdaysToggle
		height: isNxt ? 36 : 28
		anchors { left: r1WorkdaysLabel.right; leftMargin: isNxt ? 15 : 12; verticalCenter: r1WorkdaysLabel.verticalCenter }
		leftIsSwitchedOn: false
	}

	// ── Route 2 ──────────────────────────────────────────────────────────────

	Text {
		id: route2Header
		anchors { top: r1WorkdaysLabel.bottom; topMargin: isNxt ? 22 : 16; left: route1Header.left }
		font.pixelSize: isNxt ? 22 : 18
		font.family: qfont.semiBold.name
		text: "Route 2"
	}

	Text {
		id: r2PeriodeLabel
		anchors { top: route2Header.bottom; topMargin: isNxt ? 18 : 14; left: route2Header.left }
		width: isNxt ? 100 : 80
		height: isNxt ? 36 : 28
		font.pixelSize: isNxt ? 18 : 14
		font.family: qfont.regular.name
		text: "Periode:"
		verticalAlignment: Text.AlignVCenter
	}
	Rectangle {
		id: r2StartBox
		anchors { left: r2PeriodeLabel.right; leftMargin: isNxt ? 10 : 8; verticalCenter: r2PeriodeLabel.verticalCenter }
		width: isNxt ? 90 : 70; height: isNxt ? 36 : 28
		border.color: "#aaaaaa"; border.width: 1; radius: 2; color: "white"
		TextInput {
			id: r2StartInput
			anchors { fill: parent; margins: isNxt ? 6 : 4 }
			font.pixelSize: isNxt ? 18 : 14
			font.family: qfont.regular.name
			color: "#333333"
		}
	}
	Text {
		id: r2TotLabel
		anchors { left: r2StartBox.right; leftMargin: isNxt ? 10 : 8; verticalCenter: r2PeriodeLabel.verticalCenter }
		height: isNxt ? 36 : 28
		font.pixelSize: isNxt ? 18 : 14
		font.family: qfont.regular.name
		text: "tot"
		verticalAlignment: Text.AlignVCenter
	}
	Rectangle {
		id: r2EndBox
		anchors { left: r2TotLabel.right; leftMargin: isNxt ? 10 : 8; verticalCenter: r2PeriodeLabel.verticalCenter }
		width: isNxt ? 90 : 70; height: isNxt ? 36 : 28
		border.color: "#aaaaaa"; border.width: 1; radius: 2; color: "white"
		TextInput {
			id: r2EndInput
			anchors { fill: parent; margins: isNxt ? 6 : 4 }
			font.pixelSize: isNxt ? 18 : 14
			font.family: qfont.regular.name
			color: "#333333"
		}
	}

	Text {
		id: r2VanLabel
		anchors { top: r2PeriodeLabel.bottom; topMargin: isNxt ? 12 : 9; left: r2PeriodeLabel.left }
		width: isNxt ? 100 : 80
		height: isNxt ? 36 : 28
		font.pixelSize: isNxt ? 18 : 14
		font.family: qfont.regular.name
		text: "Van:"
		verticalAlignment: Text.AlignVCenter
	}
	Rectangle {
		id: r2FromLatBox
		anchors { left: r2VanLabel.right; leftMargin: isNxt ? 10 : 8; verticalCenter: r2VanLabel.verticalCenter }
		width: isNxt ? 130 : 105; height: isNxt ? 36 : 28
		border.color: "#aaaaaa"; border.width: 1; radius: 2; color: "white"
		TextInput {
			id: r2FromLatInput
			anchors { fill: parent; margins: isNxt ? 6 : 4 }
			font.pixelSize: isNxt ? 18 : 14
			font.family: qfont.regular.name
			color: "#333333"
		}
	}
	Rectangle {
		id: r2FromLonBox
		anchors { left: r2FromLatBox.right; leftMargin: isNxt ? 10 : 8; verticalCenter: r2VanLabel.verticalCenter }
		width: isNxt ? 130 : 105; height: isNxt ? 36 : 28
		border.color: "#aaaaaa"; border.width: 1; radius: 2; color: "white"
		TextInput {
			id: r2FromLonInput
			anchors { fill: parent; margins: isNxt ? 6 : 4 }
			font.pixelSize: isNxt ? 18 : 14
			font.family: qfont.regular.name
			color: "#333333"
		}
	}

	Text {
		id: r2NaarLabel
		anchors { top: r2VanLabel.bottom; topMargin: isNxt ? 12 : 9; left: r2VanLabel.left }
		width: isNxt ? 100 : 80
		height: isNxt ? 36 : 28
		font.pixelSize: isNxt ? 18 : 14
		font.family: qfont.regular.name
		text: "Naar:"
		verticalAlignment: Text.AlignVCenter
	}
	Rectangle {
		id: r2ToLatBox
		anchors { left: r2NaarLabel.right; leftMargin: isNxt ? 10 : 8; verticalCenter: r2NaarLabel.verticalCenter }
		width: isNxt ? 130 : 105; height: isNxt ? 36 : 28
		border.color: "#aaaaaa"; border.width: 1; radius: 2; color: "white"
		TextInput {
			id: r2ToLatInput
			anchors { fill: parent; margins: isNxt ? 6 : 4 }
			font.pixelSize: isNxt ? 18 : 14
			font.family: qfont.regular.name
			color: "#333333"
		}
	}
	Rectangle {
		id: r2ToLonBox
		anchors { left: r2ToLatBox.right; leftMargin: isNxt ? 10 : 8; verticalCenter: r2NaarLabel.verticalCenter }
		width: isNxt ? 130 : 105; height: isNxt ? 36 : 28
		border.color: "#aaaaaa"; border.width: 1; radius: 2; color: "white"
		TextInput {
			id: r2ToLonInput
			anchors { fill: parent; margins: isNxt ? 6 : 4 }
			font.pixelSize: isNxt ? 18 : 14
			font.family: qfont.regular.name
			color: "#333333"
		}
	}

	Text {
		id: r2WorkdaysLabel
		anchors { top: r2NaarLabel.bottom; topMargin: isNxt ? 12 : 9; left: r2NaarLabel.left }
		height: isNxt ? 36 : 28
		font.pixelSize: isNxt ? 18 : 14
		font.family: qfont.regular.name
		text: "Alleen op werkdagen"
		verticalAlignment: Text.AlignVCenter
	}
	OnOffToggle {
		id: r2WorkdaysToggle
		height: isNxt ? 36 : 28
		anchors { left: r2WorkdaysLabel.right; leftMargin: isNxt ? 15 : 12; verticalCenter: r2WorkdaysLabel.verticalCenter }
		leftIsSwitchedOn: false
	}

	// ── Hint ─────────────────────────────────────────────────────────────────

	Text {
		anchors { top: r2WorkdaysLabel.bottom; topMargin: isNxt ? 14 : 10; left: r2WorkdaysLabel.left }
		font.pixelSize: isNxt ? 15 : 12
		font.family: qfont.regular.name
		color: "#888888"
		text: "Coördinaten in decimaal formaat (bijv. 52.3704 / 4.8952), tijd als HH:MM"
	}
}
