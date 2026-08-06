import QtQuick 2.1
import qb.components 1.0
import qb.base 1.0
import FileIO 1.0

App {
    id: tscClockApp

    property url tileUrl: "TscClockTile.qml"
    property url settingsUrl: "TscClockSettings.qml"
    property url travelSettingsUrl: "TscClockTravelSettings.qml"
    property url thumbnailIcon: "drawables/clock.svg"

    property TscClockSettings tscClockSettings
    property TscClockTravelSettings tscClockTravelSettings

    property string timeStr
    property string timeSeconds
    property string dateStr
    property int leftMarginTime: 10
    property bool showSeconds: true
    property bool showDate: true
    property bool showMonthInText: true
    property bool showDayOfWeek: true
    property bool centerLayout: false
    property bool showDayOnDate: false

    // Route 1
    property string route1Start: "06:30"
    property string route1End: "09:00"
    property string route1Label: "Thuis-Werk:"
    property string route1FromLat: ""
    property string route1FromLon: ""
    property string route1ToLat: ""
    property string route1ToLon: ""
    property bool route1WorkdaysOnly: false
    property bool route1WindowEnabled: false   // false = ignore time window, always active

    // Route 2
    property string route2Start: "16:00"
    property string route2End: "18:30"
    property string route2Label: "Werk-Thuis:"
    property string route2FromLat: ""
    property string route2FromLon: ""
    property string route2ToLat: ""
    property string route2ToLon: ""
    property bool route2WorkdaysOnly: false
    property bool route2WindowEnabled: false   // false = ignore time window, always active

    // Runtime — not persisted
    property string travelTime1Str: ""
    property string travelTime2Str: ""
    property bool route1Active: false
    property bool route2Active: false

    FileIO {
        id: tscClockSettingsFile
        source: "file:///mnt/data/tsc/tscClock.userSettings.json"
    }

    Component.onCompleted: {
        try {
            var settingsString = tscClockSettingsFile.read();
            var settings = JSON.parse(settingsString);
            if (settings['showSeconds'])
                showSeconds = (settings['showSeconds'] == "true");
            if (settings['showDate'])
                showDate = (settings['showDate'] == "true");
            if (settings['showMonthInText'])
                showMonthInText = (settings['showMonthInText'] == "true");
            if (settings['showDayOfWeek'])
                showDayOfWeek = (settings['showDayOfWeek'] == "true");
            if (settings['centerLayout'])
                centerLayout = (settings['centerLayout'] == "true");
            if (settings['showDayOnDate'])
                showDayOnDate = (settings['showDayOnDate'] == "true");
            if (settings['route1Start'])
                route1Start = settings['route1Start'];
            if (settings['route1End'])
                route1End = settings['route1End'];
            if (settings['route1Label'])
                route1Label = settings['route1Label'];
            if (settings['route1FromLat'])
                route1FromLat = settings['route1FromLat'];
            if (settings['route1FromLon'])
                route1FromLon = settings['route1FromLon'];
            if (settings['route1ToLat'])
                route1ToLat = settings['route1ToLat'];
            if (settings['route1ToLon'])
                route1ToLon = settings['route1ToLon'];
            if (settings['route2Start'])
                route2Start = settings['route2Start'];
            if (settings['route2End'])
                route2End = settings['route2End'];
            if (settings['route2Label'])
                route2Label = settings['route2Label'];
            if (settings['route2FromLat'])
                route2FromLat = settings['route2FromLat'];
            if (settings['route2FromLon'])
                route2FromLon = settings['route2FromLon'];
            if (settings['route2ToLat'])
                route2ToLat = settings['route2ToLat'];
            if (settings['route2ToLon'])
                route2ToLon = settings['route2ToLon'];
            if (settings['route1WorkdaysOnly'])
                route1WorkdaysOnly = (settings['route1WorkdaysOnly'] == "true");
            if (settings['route2WorkdaysOnly'])
                route2WorkdaysOnly = (settings['route2WorkdaysOnly'] == "true");
            if (settings['route1WindowEnabled'])
                route1WindowEnabled = (settings['route1WindowEnabled'] == "true");
            if (settings['route2WindowEnabled'])
                route2WindowEnabled = (settings['route2WindowEnabled'] == "true");
        } catch (e) {}
    }

    function init() {
        registry.registerWidget("tile", tileUrl, this, null, {
            thumbLabel: qsTr("Klok-TSC"),
            thumbIcon: thumbnailIcon,
            thumbCategory: "general",
            thumbWeight: 30,
            baseTileWeight: 10,
            thumbIconVAlignment: "center"
        });
        registry.registerWidget("screen", settingsUrl, this, "tscClockSettings");
        registry.registerWidget("screen", travelSettingsUrl, this, "tscClockTravelSettings");
    }

    function updateClockTiles() {
        var now = new Date().getTime();
        timeSeconds = new Date().getSeconds();
        if (timeSeconds.length == 1)
            timeSeconds = "0" + timeSeconds;

        if (showDayOfWeek && !showDayOnDate) {
            timeStr = i18n.dateTime(now, i18n.dow_full).substring(0, 2).toLowerCase() + " " + i18n.dateTime(now, i18n.time_yes);
            leftMarginTime = isNxt ? 8 : 6;
        } else {
            timeStr = i18n.dateTime(now, i18n.time_yes);
            leftMarginTime = isNxt ? 60 : 48;
            if (showSeconds)
                leftMarginTime = leftMarginTime - 15;
        }

        var dateBase = showMonthInText ? i18n.dateTime(now, i18n.mon_full) : i18n.dateTime(now, i18n.mon_num);
        if (showDayOfWeek && showDayOnDate) {
            dateStr = i18n.dateTime(now, i18n.dow_full).substring(0, 2).toLowerCase() + " " + dateBase;
        } else {
            dateStr = dateBase;
        }

        checkTravelTimeWindow();
    }

    function minutesOfDay(timeStr) {
        var parts = timeStr.split(":");
        if (parts.length !== 2)
            return -1;
        return parseInt(parts[0]) * 60 + parseInt(parts[1]);
    }

    function setTravelTime(slot, str) {
        if (slot === 1)
            travelTime1Str = str;
        else
            travelTime2Str = str;
    }

    function fetchTravelTime(slot, fromLat, fromLon, toLat, toLon, label) {
        if (!fromLat || !fromLon || !toLat || !toLon) {
            console.log("Waze: skipping fetch, missing coordinates");
            return;
        }
        // Accept Dutch decimal commas and stray whitespace
        fromLat = String(fromLat).trim().replace(",", ".");
        fromLon = String(fromLon).trim().replace(",", ".");
        toLat = String(toLat).trim().replace(",", ".");
        toLon = String(toLon).trim().replace(",", ".");
        var lbl = label || "";
        var url = "https://routing-livemap-row.waze.com/RoutingManager/routingRequest" + "?from=x%3A" + fromLon + "+y%3A" + fromLat + "&to=x%3A" + toLon + "+y%3A" + toLat + "&at=0&returnJSON=true&returnGeometries=false" + "&returnInstructions=false&timeout=60000&nPaths=1";
        console.log("Waze: GET " + url);
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function () {
            if (xhr.readyState !== XMLHttpRequest.DONE)
                return;
            // Break the xhr <-> handler reference cycle so the request object
            // (and its closure) can be garbage-collected instead of leaking.
            xhr.onreadystatechange = null;
            if (xhr.status !== 200) {
                console.log("Waze: HTTP " + xhr.status + " — " + (xhr.responseText || "").substring(0, 200));
                return;
            }
            try {
                var data = JSON.parse(xhr.responseText);
                // nPaths=1 returns data.response.results; multi-path returns data.alternatives[].
                var results = data.alternatives ? data.alternatives[0].response.results : data.response.results;
                var secs = 0;
                for (var i = 0; i < results.length; i++)
                    secs += results[i].crossTime;
                var str = (lbl ? lbl + " " : "") + Math.round(secs / 60) + " min";
                setTravelTime(slot, str);
                console.log("Waze: ok — " + str);
            } catch (e) {
                console.log("Waze: parse error — " + e + " — body: " + (xhr.responseText || "").substring(0, 200));
            }
        };
        xhr.open("GET", url);
        xhr.send();
    }

    // Whether a route should currently be shown. When its time window is
    // disabled the route is always active (still subject to workdays-only);
    // otherwise the current time must fall inside [start, end).
    function routeIsActive(rs, re, windowEnabled, workdaysOnly, current, isWorkday) {
        if (workdaysOnly && !isWorkday)
            return false;
        if (!windowEnabled)
            return true;
        return rs >= 0 && re > rs && current >= rs && current < re;
    }

    function checkTravelTimeWindow() {
        var now = new Date();
        var current = now.getHours() * 60 + now.getMinutes();
        var dow = now.getDay();   // 0=Sunday … 6=Saturday
        var isWorkday = dow >= 1 && dow <= 5;
        var r1s = minutesOfDay(route1Start), r1e = minutesOfDay(route1End);
        var r2s = minutesOfDay(route2Start), r2e = minutesOfDay(route2End);

        // Each route is evaluated independently so overlapping windows show both.
        var a1 = routeIsActive(r1s, r1e, route1WindowEnabled, route1WorkdaysOnly, current, isWorkday);
        var a2 = routeIsActive(r2s, r2e, route2WindowEnabled, route2WorkdaysOnly, current, isWorkday);

        // Fetch only on the transition into the active state (so we don't refetch
        // every tick), but always clear when inactive so a stale value can never
        // linger — e.g. after a settings change flips a route to inactive.
        if (a1) {
            if (!route1Active) {
                route1Active = true;
                fetchTravelTime(1, route1FromLat, route1FromLon, route1ToLat, route1ToLon, route1Label);
            }
        } else {
            route1Active = false;
            travelTime1Str = "";
        }
        if (a2) {
            if (!route2Active) {
                route2Active = true;
                fetchTravelTime(2, route2FromLat, route2FromLon, route2ToLat, route2ToLon, route2Label);
            }
        } else {
            route2Active = false;
            travelTime2Str = "";
        }
    }

    function saveSettings() {
        var tmpshowSeconds = showSeconds ? "true" : "false";
        var tmpshowDate = showDate ? "true" : "false";
        var tmpshowMonthInText = showMonthInText ? "true" : "false";
        var tmpshowDayOfWeek = showDayOfWeek ? "true" : "false";
        var tmpCenterLayout = centerLayout ? "true" : "false";
        var tmpshowDayOnDate = showDayOnDate ? "true" : "false";

        var tscClockSettingsJson = {
            "showSeconds": tmpshowSeconds,
            "showDate": tmpshowDate,
            "showMonthInText": tmpshowMonthInText,
            "showDayOfWeek": tmpshowDayOfWeek,
            "centerLayout": tmpCenterLayout,
            "showDayOnDate": tmpshowDayOnDate,
            "route1Start": route1Start,
            "route1End": route1End,
            "route1Label": route1Label,
            "route1FromLat": route1FromLat,
            "route1FromLon": route1FromLon,
            "route1ToLat": route1ToLat,
            "route1ToLon": route1ToLon,
            "route2Start": route2Start,
            "route2End": route2End,
            "route2Label": route2Label,
            "route2FromLat": route2FromLat,
            "route2FromLon": route2FromLon,
            "route2ToLat": route2ToLat,
            "route2ToLon": route2ToLon,
            "route1WorkdaysOnly": route1WorkdaysOnly ? "true" : "false",
            "route2WorkdaysOnly": route2WorkdaysOnly ? "true" : "false",
            "route1WindowEnabled": route1WindowEnabled ? "true" : "false",
            "route2WindowEnabled": route2WindowEnabled ? "true" : "false"
        };

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

    Timer {
        id: travelTimeRefreshTimer
        interval: 300000   // 5 minutes
        running: true
        repeat: true
        onTriggered: {
            if (route1Active)
                fetchTravelTime(1, route1FromLat, route1FromLon, route1ToLat, route1ToLon, route1Label);
            if (route2Active)
                fetchTravelTime(2, route2FromLat, route2FromLon, route2ToLat, route2ToLon, route2Label);
        }
    }
}
