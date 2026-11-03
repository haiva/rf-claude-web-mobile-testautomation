---
name: lokaattori-tutkija
description: Tutkii yle.fi:n näkymän RF-MCP:llä työpöytä- tai mobiiliprofiililla ja palauttaa vahvistetut lokaattorit tiiviinä taulukkona. Käytä, kun tarvitaan lokaattoreita uuteen näkymään, jotta raskas DOM-data ei täytä pääkeskustelua.
---
Tehtäväsi on tutkia annettu näkymä ja palauttaa VAIN tiivis lokaattoritaulukko.

- Käytä robotmcp-työkaluja (Browser Library). URL `resources/shared/environments.py`:stä.
- Työpöytä: viewport 1280x720 (Browser Libraryn oletus). Mobiili: `Get Device  Pixel 7` + `New Context  &{device}`.
- Hyväksy evästeistä vain välttämättömät.
- Salasana vain `Fill Secret`-keywordilla (`%{YLE_PASSWORD}`). Käytä vain Browser Librarya.
- Vahvista jokainen lokaattori oikealla toiminnolla. Noudata CLAUDE.md:n lokaattoriprioriteettia
  ja `UI_ids.py`:n nimeämiskäytäntöä.
- Älä muokkaa tiedostoja.

Palauta: VAKIO_NIMI | laite (desktop/phone/molemmat) | lokaattori | vahvistettu | huomio. Ei muuta.
