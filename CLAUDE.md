# rf-claude-web-mobile-testautomation – Robot Framework -testiautomaatio Claude Codella

Esimerkkirepo, jonka periaate on: **yksi repo, samat ylätason testit kaikille laitteille,
laite- ja alustakohtainen toteutus omissa kansioissaan.**
Testattava: https://yle.fi työpöytäselaimella ja mobiiliselaimella (Browser Libraryn
laite-emulointi). Rakenteen säilyttäminen on tärkeämpää kuin nopeus.

## Rakenne (älä muuta ilman erillistä pyyntöä)
```
jenkins/                         CI-putkien tiedostot (esim. Jenkins)
libraries/                       Omat Python-kirjastot
resources/
  web/                           aktiivinen alusta (Browser Library)
    devices/<DEVICE>.py          laiteprofiili: chromium_desktop, chromium_desktop_headless, pixel_7
    device_specific/<FORM_FACTOR>/keywords.resource   laitekohtaiset erot (desktop | phone)
    keywords.resource            ylätason keywordien toteutus
    navigation.resource          navigointi näkymästä toiseen
    setups_teardowns.resource    Open App, Close App, teardownit
    UI_ids.py                    KAIKKI lokaattorit
  native_android/ androidtv/     natiivisovellusten alustat – vain paikkamerkit, älä lisää koodia
  shared/                        alustariippumattomat keywordit ja ympäristömuuttujat
tests/                           VAIN ylätason testitapaukset (.robot)
```

## Kultaiset säännöt
1. `tests/**/*.robot` sisältää vain ylätason liiketoimintakeywordejä Given/When/Then-muodossa.
   Ei lokaattoreita, ei Browser-keywordejä, ei `Sleep`-kutsuja.
2. **Sama testi kaikille laitteille.** Älä tee erillistä mobiilitestiä. Laite valitaan ajossa
   muuttujalla `DEVICE`, ja testi pysyy samana.
3. **Laitekohtaiset erot vain `device_specific/<FORM_FACTOR>/keywords.resource`-tiedostoihin.**
   Sama keyword-nimi molempiin (desktop ja phone). Ei `IF`-ehtoja laitteen mukaan muualla.
4. Lokaattorit vain `resources/web/UI_ids.py`:hin, ISOILLA_KIRJAIMILLA. Vain mobiilissa
   esiintyvät lokaattorit `MOBILE_`-etuliitteellä.
5. Ennen uutta keywordia: etsi olemassa olevat (`grep -rn "Keyword Name" resources/`).
   Järjestys: uudelleenkäytä → laajenna argumentilla → luo uusi.
6. Tunnukset vain ympäristömuuttujista `%{YLE_USER}` ja `%{YLE_PASSWORD}`. Älä koskaan
   kirjoita salasanaa mihinkään tiedostoon.
7. Tagit: `web_test` jokaiseen testiin, lisäksi tarvittaessa `smoke` ja `wip` (wip = kesken,
   jätetään ajoista pois).
8. Odotukset: `Wait For Elements State` tai Browserin auto-wait. Ei kiinteitä viiveitä.
9. Keywordien nimet englanniksi Title Case. `[Documentation]` lyhyesti.
10. `native_android/` ja `androidtv/` ovat natiivisovellusten (AppiumLibrary) paikkamerkkejä. Älä kirjoita niihin
    koodia, ellei sitä erikseen pyydetä.

## RF-MCP (robotmcp)
- Tutki sovellus ja kokeile jokainen askel robotmcp:llä *ennen* tiedostoon kirjoittamista.
  Lokaattori on vahvistettu vasta, kun klikkaus, kirjoitus tai odotus on oikeasti onnistunut.
- Työpöytä: viewport 1920x1080. Mobiili: `Get Device    Pixel 7` ja `New Context    &{device}`.
- Lokaattoriprioriteetti: `data-testid` / role / aria > id > css > text > xpath (viimeinen keino).
- `build_test_suite`-luonnosta ei kopioida sellaisenaan: askeleet siirretään tämän repon rakenteeseen.
- Yle Tunnus -lomake on tunnus.yle.fi-iframessa: Browser läpäisee sen `>>>`-erottimella.
- **Salasana syötetään RF-MCP:ssä vain `Fill Secret`-keywordilla** viittauksena `%{YLE_PASSWORD}`.
  Selväkielinen arvo tallentuisi askelhistoriaan ja lokeihin.
- **RF-MCP:llä käytetään vain Browser Librarya.** Älä tuo Process- tai OperatingSystem-kirjastoja
  äläkä aja niiden kautta komentoja tai tiedosto-operaatioita. Hook `guard_mcp` estää nämä.
- Jokainen RF-MCP-kutsu vaatii käyttäjän luvan. Se on tarkoituksellista: käyttäjä näkee, mitä teet.

## Ajaminen (bash; Windowsissa Git Bash)
```bash
bash scripts/aja.sh web                 # työpöytä (chromium_desktop)
bash scripts/aja.sh mobile              # mobiili (pixel_7)
bash scripts/aja.sh web --dryrun        # rakenteen tarkistus ilman selainta
```
Sama ajo suoraan robot-komennolla:
`robot --variable OS:web --variable DEVICE:pixel_7 --variable EXEC_ENV:TEST --include web_test tests/`

## Työtapa jokaisessa tehtävässä
1. Suunnittele: mitkä keywordit ovat jo olemassa, mitkä uusia, mihin tiedostoihin. Odota hyväksyntää.
2. Tutki robotmcp:llä ja vahvista lokaattorit.
3. Kirjoita järjestyksessä: `UI_ids.py` → `device_specific/` tai `keywords.resource` → testi.
4. Aja `--dryrun` molemmille laitteille.
5. Katselmoi (`rakenne-katselmoija`-subagentti) ennen oikeaa ajoa.
6. Kysy, ajetaanko testit itse vai ajatko ja analysoitko ne.
7. Raportoi muutokset tiedostoittain ja avoimet TODOt.
