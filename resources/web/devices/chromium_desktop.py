"""Laiteprofiili: työpöytäselain (Chromium, 1280x720 = Browser Libraryn oletus)."""
BROWSER = "chromium"
HEADLESS = False          # näkyvä selain; CI:ssä chromium_desktop_headless
PLAYWRIGHT_DEVICE = ""    # tyhjä = ei laite-emulointia, käytetään viewportia
FORM_FACTOR = "desktop"   # -> device_specific/desktop/
VIEWPORT_WIDTH = 1280
VIEWPORT_HEIGHT = 720
LOCALE = "fi-FI"
