---
description: Tutki yle.fi:n näkymä työpöytäselaimella RF-MCP:llä ja ehdota lokaattorit
argument-hint: <näkymä tai toiminto, esim. "haku">
---
Tutki näkymää "$ARGUMENTS" sivustolla yle.fi robotmcp-työkaluilla (Browser Library), työpöytäprofiili.

1. Lue `resources/web/UI_ids.py` ja `resources/web/keywords.resource`: mitä on jo olemassa?
2. Avaa näkyvä selain resoluutiolla 1280x720 (Browser Libraryn oletus), osoite `resources/shared/environments.py`:stä.
   Hyväksy evästeistä vain välttämättömät. Tunnukset tarvittaessa `%{YLE_USER}` / `%{YLE_PASSWORD}`, salasana vain `Fill Secret`-keywordilla.
3. Kulje näkymä läpi askel kerrallaan. Vahvista jokainen lokaattori oikealla toiminnolla
   (Click, Fill Text, Wait For Elements State), älä pelkästä DOMista päättelemällä.
4. Älä sido lokaattoreita uutisotsikoiden teksteihin, ne vaihtuvat.
5. Palauta taulukko: VAKIO_NIMI | lokaattori | strategia | vahvistettu (kyllä/ei) | huomio.

ÄLÄ kirjoita tiedostoihin. Kysy lopuksi, päivitetäänkö `UI_ids.py`.
