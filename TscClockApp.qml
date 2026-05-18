import QtQuick 2.1
import qb.components 1.0
import qb.base 1.0;
import FileIO 1.0

App {
	id: tscClockApp

	// These are the URL's for the QML resources from which our widgets will be instantiated.
	// By making them a URL type property they will automatically be converted to full paths,
	// preventing problems when passing them around to code that comes from a different path.
	property url tileUrl : "TscClockTile.qml";
	property url settingsUrl : "TscClockSettings.qml";
	property url thumbnailIcon: "drawables/clock.svg";

	property TscClockSettings tscClockSettings

	property string timeStr
	property string timeSeconds
	property string dateStr
	property int leftMarginTime : 10
	property bool showSeconds : true
	property bool showDate : true
	property bool showMonthInText : true
	property bool showDayOfWeek : true
	property bool centerLayout : false
	property bool showDayOnDate : false


	FileIO {
		id: tscClockSettingsFile
		source: "file:///mnt/data/tsc/tscClock.userSettings.json"
 	}

	//this function needs to be started after the app is booted, read user settings
	Component.onCompleted: {

		try {
			var settingsString = tscClockSettingsFile.read();
			var settings = JSON.parse(settingsString);
			if (settings['showSeconds']) showSeconds = (settings['showSeconds'] == "true");
			if (settings['showDate']) showDate = (settings['showDate'] == "true");
			if (settings['showMonthInText']) showMonthInText = (settings['showMonthInText'] == "true");
			if (settings['showDayOfWeek']) showDayOfWeek = (settings['showDayOfWeek'] == "true");
			if (settings['centerLayout']) centerLayout = (settings['centerLayout'] == "true");
			if (settings['showDayOnDate']) showDayOnDate = (settings['showDayOnDate'] == "true");
		} catch(e) {
		}

	}

	function init() {
		registry.registerWidget("tile", tileUrl, this, null, {thumbLabel: qsTr("Klok-TSC"), thumbIcon: thumbnailIcon, thumbCategory: "general", thumbWeight: 30, baseTileWeight: 10, thumbIconVAlignment: "center"});
		registry.registerWidget("screen", settingsUrl, this, "tscClockSettings");
	}

	function updateClockTiles() {
		var now = new Date().getTime();
		timeSeconds = new Date().getSeconds();
		if (timeSeconds.length == 1) timeSeconds = "0" + timeSeconds;

		if (showDayOfWeek && !showDayOnDate) {
			timeStr = i18n.dateTime(now, i18n.dow_full).substring(0,2).toLowerCase() + " " + i18n.dateTime(now, i18n.time_yes);
			leftMarginTime = isNxt ? 8 : 6;
		} else {
			timeStr = i18n.dateTime(now, i18n.time_yes);
			leftMarginTime = isNxt ? 60 : 48;
			if (showSeconds) leftMarginTime = leftMarginTime - 15;
		}

		var dateBase = showMonthInText ? i18n.dateTime(now, i18n.mon_full) : i18n.dateTime(now, i18n.mon_num);
		if (showDayOfWeek && showDayOnDate) {
			dateStr = i18n.dateTime(now, i18n.dow_full).substring(0,2).toLowerCase() + " " + dateBase;
		} else {
			dateStr = dateBase;
		}
	}

	function saveSettings() {
		
		// save user settings

		var tmpshowSeconds = "";
		if (showSeconds == true) {
			tmpshowSeconds = "true"
		} else {
			tmpshowSeconds = "false";
		}
		var tmpshowDate = "";
		if (showDate == true) {
			tmpshowDate = "true"
		} else {
			tmpshowDate = "false";
		}
		var tmpshowMonthInText = "";
		if (showMonthInText) {
			tmpshowMonthInText = "true"
		} else {
			tmpshowMonthInText = "false"
		}
		var tmpshowDayOfWeek = "";
		if (showDayOfWeek) {
			tmpshowDayOfWeek = "true"
		} else {
			tmpshowDayOfWeek = "false"
		}
		var tmpCenterLayout = centerLayout ? "true" : "false";
		var tmpshowDayOnDate = showDayOnDate ? "true" : "false";

 		var tscClockSettingsJson = {
			"showSeconds" : tmpshowSeconds,
			"showDate" : tmpshowDate,
			"showMonthInText" : tmpshowMonthInText,
			"showDayOfWeek" : tmpshowDayOfWeek,
			"centerLayout" : tmpCenterLayout,
			"showDayOnDate" : tmpshowDayOnDate
		}

  		var doc3 = new XMLHttpRequest();
   		doc3.open("PUT", "file:///mnt/data/tsc/tscClock.userSettings.json");
   		doc3.send(JSON.stringify(tscClockSettingsJson));
	}

	Timer {
		id: datetimeTimer
		interval: 1000
		triggeredOnStart: true
		running: true
		repeat: true
		onTriggered: updateClockTiles()
	}
}
