# Time Machine — Browser Web App (Tau Prolog)

A **purely client-side** web app that runs Time Machine Prolog computations in
the browser using [Tau Prolog](https://tau-prolog.org) — no server-side Prolog
installation required.

Works on **iPhone**, **Android**, **desktop** browsers, and can be pinned to
your home screen as a Progressive Web App.

---

## Files

| File | Purpose |
|------|---------|
| `index.html` | Mobile-friendly UI — loads Tau Prolog, quick-action buttons, query box |
| `app.js` | Tau Prolog session management, consult, query, answer display |
| `style.css` | Responsive dark-theme layout |
| `prolog/bc12_subset.pl` | Mobile-friendly bc12 subset (same `a`-count as original) |
| `prolog/time_machine_browser.pl` | UI wrapper predicates (`tm_prepare/0`, `tm_run/1`, `tm_info/0`) |

---

## Running locally

Tau Prolog loads `.pl` files via HTTP, so you need a static file server.
Run from the **repository root** (one level above `web/`):

```bash
# Python 3 (built-in)
python3 -m http.server 8080
```

Then open <http://localhost:8080/web/> in your browser.

Other static server options:

```bash
# Node.js (npx, no global install needed)
npx serve .

# VS Code: install the "Live Server" extension, right-click index.html → "Open with Live Server"
```

---

## Deploying to GitHub Pages

1. Go to **Settings → Pages** in your fork of `luciangreen/Time_Machine`.
2. Set **Source** to `Deploy from a branch`, branch `main`, folder `/web`.
3. Save.  GitHub Pages will publish to:
   `https://<your-username>.github.io/Time_Machine/`

You can then open that URL on iPhone or Android and use **"Add to Home Screen"**
to install it as a PWA.

---

## iPhone / Android usage

1. Open the Pages URL (or `http://localhost:8080/web/`) in **Safari** (iOS) or
   **Chrome** (Android).
2. Tap the share icon → **Add to Home Screen** to install.
3. The app runs entirely in the browser — no network connection needed once loaded
   (Tau Prolog engine comes from a CDN on first visit; subsequent visits use the
   browser cache).

---

## Available predicates

| Predicate | Description |
|-----------|-------------|
| `tm_info.` | Print a summary of available predicates |
| `tm_prepare.` | Run one bc12 cycle (demo — mirrors `time_machine_prepare`) |
| `tm_run(N).` | Run N bc12 cycles |
| `bc12_subset(N).` | Run N bc12 cycles (low-level entry point) |
| `bc12.` | Run a single bc12 cycle |

---

## bc12 subset vs the original `bc12.pl`

### Original `bc12.pl` (7.5 MB)

```prolog
bc12(N) :- length(A, N), findall(_, (member(_, A), bc12), _), !.
bc12 :- b1, b2, c1, c2, !.
b1 :- a, a, a, a, a, a, a, a, a, a, a, a, a, a.   % 14 × a
b2 :- a, a, a, a, a, a, a.                         %  7 × a
```

- `a/0` calls `a1/1` with a list of hundreds of 3D-coordinate terms (large facts).
- `c1/0` and `c2/0` run `texttobr/4` on multi-kilobyte text strings (SWI-Prolog only).
- Total: **21 `a` activations per `bc12/0` call**.

### Subset `bc12_subset.pl` (this app)

```prolog
bc12_subset(N) :- length(A, N), findall(_, (member(_, A), bc12), _), !.
bc12 :- b1, b2, c1, c2, !.
b1 :- a, a, a, a, a, a, a, a, a, a, a, a, a, a.   % 14 × a (unchanged)
b2 :- a, a, a, a, a, a, a.                         %  7 × a (unchanged)
a.                                                  % minimal — just succeeds
c1.                                                 % stub
c2.                                                 % stub
```

- **Same `a`-count** (21 per cycle) — the cardinality/output count is unchanged.
- `a/0` is a minimal fact — no heavy data structures.
- `c1/0` and `c2/0` succeed immediately — no SWI-Prolog-only I/O.
- Compatible with **Tau Prolog** (pure browser execution).

To run the **full** `bc12.pl` (SWI-Prolog, desktop only):

```prolog
% swipl
% ['bc12.pl'].
% bc12(5).   % 5 cycles
% halt.
```

---

## Architecture

```
browser
  └── index.html
        ├── style.css
        ├── tau-prolog (CDN)          ← Prolog engine (JS)
        └── app.js
              ├── fetch prolog/bc12_subset.pl       ← consulted at startup
              └── fetch prolog/time_machine_browser.pl
```

`app.js` fetches each `.pl` file as text, consults it into a Tau Prolog
session, then lets the user run arbitrary goals through the query box.
