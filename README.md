# tscClock

A clock tile for the **Eneco Toon** thermostat display: time, seconds, date and day of
the week, plus optional **Waze travel times** for up to two routes.

This is a fork of
[ToonSoftwareCollective/tscClock](https://github.com/ToonSoftwareCollective/tscClock),
which itself extends the standard Toon clock app with a date and seconds. See
[Differences from upstream](#differences-from-upstream).

## The tile

Two layouts are available. The original one anchors the time and date at fixed offsets
from the top of the tile:

```
 ma 07:31 42
    31 januari
    Thuis-Werk: 24 min
    Werk-Thuis: 31 min
```

The centred layout stacks the same rows in a `Column` centred vertically in the tile,
and grows the time font when the day of the week has been moved to the date row:

```
      07:31 42
     ma 31 januari
    Thuis-Werk: 24 min
    Werk-Thuis: 31 min
```

Every row below the time is optional; a row that is switched off or has no value takes
up no vertical space. Tapping the tile opens the settings screen.

## Requirements

- A **rooted Toon** running the ToonStore client (`tsc`). Settings are stored in
  `/mnt/data/tsc/`, which is the ToonStore data directory.
- For travel times only: the Toon must be able to reach `routing-livemap-row.waze.com`
  over HTTPS. No account or API key is needed.

The clock itself works fully offline; leave the route coordinates blank and no network
requests are made.

## Installation

Copy the repository contents into a `tscClock` directory under the Toon's apps directory
and restart the UI:

```sh
scp *.qml version.txt root@<toon-ip>:/qmf/qml/apps/tscClock/
```

The exact apps path depends on your firmware and root method — check where your other
ToonStore apps live and use the same parent directory. After restarting the Toon UI, add
the tile via the tile screen's **+** button (category _general_, label _Klok-TSC_).

## Configuration

Tap the tile to open **TSC Klok configuratie**:

| Setting                             | Default | Description                                                                 |
| ----------------------------------- | ------- | --------------------------------------------------------------------------- |
| `Toon datum`                        | on      | Show the date row                                                           |
| `Toon seconden in de tijd`          | on      | Show seconds in small type next to the time                                 |
| `Maand in datum voluit geschreven`  | on      | Month as a word (`31 januari`) instead of a number (`31-01`)                |
| `Toon dag van de week`              | on      | Show the two-letter day abbreviation                                        |
| `Verticaal gecentreerde weergave`   | off     | Use the centred layout instead of the fixed-offset one                      |
| `Dag voor datum (i.p.v. voor tijd)` | off     | Move the day abbreviation to the date row, freeing width for a larger clock |

`Waze reistijd »` at the bottom opens the travel-time screen. Press **Opslaan** on either
screen to save; settings are written to `/mnt/data/tsc/tscClock.userSettings.json` and
reloaded on startup.

### Travel times

Two independent routes can be configured, each with the same set of fields:

| Field                  | Default (route 1 / route 2)       | Description                                                             |
| ---------------------- | --------------------------------- | ----------------------------------------------------------------------- |
| `Periode`              | `06:30`–`09:00` / `16:00`–`18:30` | Time window, `HH:MM`. Only used when `Tijdvenster` is on                |
| `Label`                | `Thuis-Werk:` / `Werk-Thuis:`     | Prefix shown before the duration. Leave blank for the bare duration     |
| `Van` / `Naar` Lat/Lon | _(empty)_                         | Decimal coordinates, e.g. `52.3704` / `4.8952`. Commas are accepted too |
| `Tijdvenster`          | off                               | Off: the route is always active. On: only inside `Periode`              |
| `Alleen op werkdagen`  | off                               | Restrict the route to Monday–Friday                                     |

A route is shown when its coordinates are complete and it is currently active. Routes are
evaluated independently, so overlapping windows show both rows. Saving re-evaluates both
routes immediately rather than waiting for the next tick.

Finding coordinates: right-click a spot in Google Maps and copy the `lat, lon` pair it
shows, or read them from the URL after `@`.

## How it works

`TscClockApp.qml` ticks a 1-second `Timer` that rebuilds the time and date strings via
`i18n.dateTime` and then calls `checkTravelTimeWindow()`. A route that becomes active
triggers one Waze request; a route that goes inactive is cleared immediately, so a stale
duration can never linger on the tile. A second timer refreshes the active routes every
5 minutes.

Travel times come from Waze's public live-map routing endpoint
(`routing-livemap-row.waze.com/RoutingManager/routingRequest`), summing `crossTime` over
the returned route segments.

Each request is guarded by a 15-second `Timer` that aborts it — Qt's QML
`XMLHttpRequest` has no `timeout` property of its own. A request that times out, returns
a non-200 status or yields unparseable JSON logs the reason to the Toon's console and
replaces the duration with `—`, so an unreachable Waze reads as unavailable rather than
freezing on a stale number. Only one request per route is ever in flight; a refresh or a
settings change aborts the previous one.

| File                           | Role                                                         |
| ------------------------------ | ------------------------------------------------------------ |
| `TscClockApp.qml`              | App root: settings persistence, clock tick, Waze fetch logic |
| `TscClockTile.qml`             | The tile — both layouts, switched by `app.centerLayout`      |
| `TscClockSettings.qml`         | Clock settings screen                                        |
| `TscClockTravelSettings.qml`   | Two-column travel-time settings screen                       |
| `lang/`                        | Qt translation catalogs, one per locale                      |
| `version.txt`, `Changelog.txt` | Read by the ToonStore to detect and describe updates         |

`isNxt` selects the larger font and margin values for Toon 2 (NXT) hardware.

## Translations

The source language is Dutch, matching the rest of the Toon interface. Every user-visible
string goes through `qsTr()`, and `lang/lang_en_GB.qm` translates them to English; the
Toon loads the catalog matching its own locale, following the same `lang/lang_<locale>.qm`
convention as the other ToonStore apps. Dutch needs no catalog, being the source language.

`lang/lang_en_GB.ts` is the editable source and `lang/lang_en_GB.qm` the compiled form the
Toon actually reads, so **both must be committed**. After changing or adding a string:

```sh
pip install PySide6
pyside6-lupdate *.qml -ts lang/lang_en_GB.ts   # pick up new strings
pyside6-lrelease lang/lang_en_GB.ts -qm lang/lang_en_GB.qm
```

`lupdate` merges rather than overwrites, marking new entries `type="unfinished"` for
translation and stale ones `type="vanished"`. Adding a language means copying the `.ts`,
changing its `language` attribute and compiling it to a matching `.qm`.

## Differences from upstream

Upstream has been unchanged since December 2022 (version 1.0.1). This fork adds:

- **Waze travel times** for up to two routes, with per-route label, time window,
  workdays-only toggle and a dedicated settings screen.
- **Vertically centred layout** as an alternative to the fixed baseline offsets.
- **Day of the week on the date row**, which frees horizontal space and allows a larger
  time font (65 → 75 px on NXT).

Nothing was removed. Existing settings files keep working: the new keys simply fall back
to their defaults when absent.

## Versioning

`version.txt` follows [semantic versioning](https://semver.org/) and continues upstream's
numbering, which stopped at `1.0.1`. This fork is at **1.1.0** — a minor bump, which is
the right call: every change above is additive and backwards compatible, with no removed
settings and no change to the on-disk settings format.

Keep `version.txt` and `Changelog.txt` in step when releasing; the ToonStore uses the
former to detect updates and shows the latter to the user.

One caveat of sharing upstream's numbering line: if ToonSoftwareCollective ever releases
their own `1.1.0`, the two are indistinguishable by version alone. Given upstream's
dormancy this is a low risk, but a fork-specific suffix is the fix if it ever matters.

## Development

Formatting and linting run through [pre-commit](https://pre-commit.com/):

```sh
pip install pre-commit
pre-commit install
pre-commit run --all-files
```

That runs `prettier` on JSON/YAML/Markdown and `pyside6-qmlformat` / `pyside6-qmllint`
(from `PySide6`) on the QML. The same checks run on pull requests via
[`.github/workflows/pr-lint.yml`](.github/workflows/pr-lint.yml); `qmllint` is advisory,
since the Toon's `qb.components` types are not available outside the device.

There is no way to run the app off-device: it depends on Toon-private QML modules
(`qb.components`, `qb.base`, `FileIO`, `BxtClient`). Test on a real Toon.

## Known limitations

- The Waze endpoint is undocumented and unofficial. It can change or start refusing
  requests at any time, and every fetch sends your route coordinates to Waze.
- `thumbnailIcon` points at `drawables/clock.svg`, which is not in this repository —
  inherited from upstream, where the file is likewise absent.
- Only Dutch and English are provided. Any other locale falls back to the Dutch source
  strings.

## License

[MIT](LICENSE), covering the changes made in this fork. The upstream
[ToonSoftwareCollective/tscClock](https://github.com/ToonSoftwareCollective/tscClock)
code this builds on declares no license of its own — see the notice in
[`LICENSE`](LICENSE) before redistributing.
