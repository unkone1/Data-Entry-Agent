# NIELIT Data Entry Agent (Desktop App)

A small desktop app that reads rows from an Excel file and types them into a
web form (e.g. `student.nielit.gov.in`, or any similar ASP.NET-style portal)
using real keystrokes via Selenium — never the clipboard, so it works even on
sites that block paste.

This is a GUI rewrite of the original terminal script: same core logic
(field discovery, fuzzy column-to-field matching with a learned/synonym
table, per-row review before submitting, redo/skip, resumable run log), just
with a proper interface instead of typing answers into a console.

**You are always in control of login, CAPTCHA/OTP, and the final Submit
click** — the app fills the fields for you and pauses for your review by
default.

---

## 1. Setup

1. Install Python 3.10+ (the Tkinter GUI toolkit ships with the standard
   Windows/macOS installers; on Linux you may need `sudo apt install
   python3-tk` or your distro's equivalent).
2. Install Google Chrome.
3. Download the matching **ChromeDriver** for your installed Chrome version
   from https://googlechromelabs.github.io/chrome-for-testing/ and either:
   - put it on your system `PATH`, or
   - set an environment variable `CHROMEDRIVER_PATH` pointing at it.
4. In this folder, install the Python dependencies:

   ```bash
   pip install -r requirements.txt
   ```

## 2. Run

```bash
python main.py
```

This opens the app window. Use the four tabs in order:

1. **Browser & Form** — click "Launch Chrome", log in and navigate to the
   exact data-entry page yourself (handles CAPTCHA/OTP/session cookies),
   then click "Scan Form Fields".
2. **Excel Data** — choose your `.xlsx` file and sheet, click "Load Sheet".
3. **Field Mapping** — click "Auto-Suggest Mapping", review the guesses,
   double-click any row to fix it, then "Save Mapping". Required form
   fields with no Excel column mapped are flagged in red.
4. **Run Entry** — click "Start / Resume Run". For each row: "Fill This
   Row" types the values, then review the page in Chrome (solve any
   CAPTCHA), and either click the site's own Submit button yourself or use
   "Click Submit Button" if you've entered its element id. Then "Mark
   Submitted -> Next Row". Use "Redo (retype row)" if something looks
   wrong before submitting, or "Redo PREVIOUS submitted row" if the site
   rejected the row you just sent.

Progress is written to a `run_log.csv` in your per-user data folder (see
below), so you can close the app and resume later without redoing rows
already marked "done".

## 3. Where data is stored

To avoid cluttering wherever you installed the app, mapping/learning/log
files are kept in:

- **Windows:** `C:\Users\<you>\.nielit_data_entry_agent\`
- **macOS/Linux:** `~/.nielit_data_entry_agent/`

Files:
- `field_mapping.json` — saved column→field mapping per Excel file.
- `learned_field_matches.json` — column/label pairs you've confirmed, reused
  to improve auto-suggestions on future files.
- `run_log.csv` — per-row status (`done` / `skipped`) so runs are resumable.

You can override this location with the `NIELIT_AGENT_DATA_DIR` environment
variable.

## 4. Packaging as a standalone executable (optional)

If you want a single `.exe`/binary you can hand to someone without them
installing Python, use PyInstaller:

```bash
pip install pyinstaller
pyinstaller --name "NIELIT-Data-Entry-Agent" --onefile --windowed main.py
```

The output will be in `dist/`. On Windows this produces
`NIELIT-Data-Entry-Agent.exe`. See `build_exe.bat` for a ready-made script.

Note: ChromeDriver is **not** bundled — the machine running the app still
needs Chrome + a matching ChromeDriver, as in step 1 above.

## 5. Notes / safety

- Auto-submit is off by default. Turning it on and supplying a submit
  button element id will click Submit automatically after each row fill —
  only enable this once you fully trust the mapping, since government
  portals often have no "undo" after submission.
- The app types character-by-character (with small delays) rather than
  setting field values directly or using the clipboard, to behave like a
  human typing and to stay compatible with paste-blocking forms.
- Nothing is sent anywhere except to the Chrome browser window the app
  opens — there's no network calls to any third party from the app itself.
