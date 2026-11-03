# rf-claude-web-mobile-demo – Robot Framework + Claude Code testiautomaation tehostamiseen

Esimerkkirepo Robot Framework -testiautomaatiosta Claude Codella. Samat testit ajetaan yle.fi:tä
vasten **työpöytäselaimella** ja **mobiiliselaimella** (Browser Libraryn laite-emulointi).
Repo näyttää, miten Claude Code kirjoittaa testejä olemassa olevaa rakennetta kunnioittaen.

**Sisällys**

1. [Mikä tämä on](#mikä-tämä-on)
2. [Ensimmäinen asennus](#ensimmäinen-asennus)
3. [Testien tekeminen Claude Codella](#testien-tekeminen-claude-codella)
4. [Testien ajaminen](#testien-ajaminen)
5. [Tietoturva](#tietoturva)
6. [Vianetsintä](#vianetsintä)

---

## Mikä tämä on

Periaate: **yksi testi, monta laitetta.** Testitiedostot (`tests/`) sisältävät vain ylätason
askeleet. Toteutus on `resources/`-kansiossa, ja laite valitaan ajossa muuttujalla `DEVICE`.
Työpöydän ja mobiilin erot ovat omissa `device_specific/`-kansioissaan.

```
.claude/                  Claude Coden asetukset: komennot, subagentit, skill, hookit, luvat
.mcp.json                 MCP-palvelin: robotmcp (RF-MCP)
CLAUDE.md                 Clauden pysyvä konteksti: rakenne ja säännöt
resources/web/
  devices/                laiteprofiilit: chromium_desktop, chromium_desktop_headless, pixel_7
  device_specific/        laite-erot: desktop/ ja phone/
  keywords.resource       ylätason keywordien toteutus
  UI_ids.py               kaikki lokaattorit
resources/native_android/, androidtv/   natiivisovellusten alustat, vain paikkamerkit
tests/                    testitapaukset
scripts/                  aja.sh, tarkista_ymparisto.sh, hooks/
```

Kaikki skriptit ovat bash-skriptejä. **Windowsissa ne ajetaan Git Bashissa**, joka tulee Git for
Windowsin mukana ja jota myös Claude Code käyttää Windowsissa.

---

## Ensimmäinen asennus

Vaiheet 1–2 tehdään vain, jos työkaluja ei ole vielä koneella. Vaiheet 3–7 tehdään kerran
jokaiselle repon kopiolle.

### Vaihe 1: Tarkista, mitä sinulla jo on

Aja komennot terminaalissa (Windowsissa PowerShell tai Git Bash). Jos komento antaa virheen tai
versio on vanhempi kuin vaadittu, asenna työkalu vaiheessa 2.

| Työkalu | Tarkistus | Vaatimus | Mihin |
|---|---|---|---|
| Git | `git --version` | mikä tahansa | repo; Windowsissa myös Git Bash |
| Python | `python3 --version` (Windows: `python --version`) | 3.10+ | Robot Framework |
| Node.js | `node --version` | 20+ | Browser Library (Playwright) |
| uv | `uv --version` | mikä tahansa | RF-MCP:n asennus |
| VS Code | `code --version` | mikä tahansa | editori |
| Claude Code | `claude --version` | uusin | agentti |

### Vaihe 2: Asenna puuttuvat työkalut

Asenna vain ne, jotka puuttuivat. Avaa asennusten jälkeen **uusi terminaali**, jotta PATH päivittyy.

**macOS** (Homebrew):
```bash
brew install git python@3.12 node uv
brew install --cask visual-studio-code
curl -fsSL https://claude.ai/install.sh | bash          # Claude Code
```

**Windows** (PowerShell):
```powershell
winget install --id Git.Git -e                          # sisältää Git Bashin
winget install --id Python.Python.3.12 -e
winget install --id OpenJS.NodeJS.LTS -e
winget install --id Microsoft.VisualStudioCode -e
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"   # uv
irm https://claude.ai/install.ps1 | iex                                             # Claude Code
```
Claude Coden ajantasainen asennusohje: https://docs.claude.com (Claude Code → Setup).

> **Windows:** tästä eteenpäin kaikki komennot ajetaan **Git Bashissa**.

### Vaihe 3: Hae repo ja luo Python-ympäristö

Tee tämä **ennen** kuin avaat repon VS Codessa, jotta Python-ympäristö on olemassa, kun VS Code
etsii sitä.

```bash
git clone <repon-osoite> rf-ai-demo
cd rf-ai-demo

python3 -m venv .venv            # Windows: python -m venv .venv
source .venv/bin/activate        # Windows: source .venv/Scripts/activate
pip install -r requirements.txt
rfbrowser init chromium          # Browser Libraryn selain
```

### Vaihe 4: Asenna RF-MCP

RF-MCP antaa Claude Codelle oikean Robot Framework -session, jolla se tutkii sivuja ja kokeilee
askeleita ennen kuin kirjoittaa testejä.

```bash
uv tool install "rf-mcp[web]"    # robotmcp-komento PATHiin
robotmcp init --browsers         # RF-MCP:n omat selaimet
robotmcp doctor -C .             # tarkistaa, mitä RF-MCP näkee tästä projektista
```
Versio näkyy komennolla `uv tool list`. Halutessasi lukitse se: `uv tool install "rf-mcp[web]==<versio>"`.

### Vaihe 5: Aseta tunnukset

Kirjautumistestit tarvitsevat oman Yle Tunnuksen. Sen voi luoda maksutta yle.fi:n
Kirjaudu-painikkeesta. Tunnukset annetaan ympäristömuuttujina, eivät tiedostoissa.

```bash
cp .env.example .env             # täytä YLE_USER ja YLE_PASSWORD
source .env
```
`.env` on `.gitignore`ssa, eikä Claude Code saa lukea sitä.

### Vaihe 6: Avaa VS Code ja valitse Python-tulkki

```bash
code .
```
1. Asenna suositellut laajennukset (Claude Code, Python, RobotCode), kun VS Code ehdottaa niitä.
2. Valitse tulkki: `Ctrl+Shift+P` (macOS `Cmd+Shift+P`) → **Python: Select Interpreter** → `.venv`.
3. Lataa ikkuna uudelleen: **Developer: Reload Window**.

Jos RobotCode pyytää asentamaan Robot Frameworkin käyttäjälle, kieltäydy: tulkiksi ei ole
valittu `.venv`:iä.

### Vaihe 7: Tarkista asennus

```bash
bash scripts/tarkista_ymparisto.sh    # kaikkien rivien pitäisi olla [OK]
bash scripts/aja.sh web               # ensimmäinen oikea ajo: 1 passed
```
Käynnistä Claude Code VS Coden terminaalissa komennolla `claude` (samassa terminaalissa, jossa
ajoit `source .env`) ja tarkista komennolla `/mcp`,
että robotmcp on "connected". Hyväksy projektin MCP-palvelin, kun Claude Code kysyy sitä.

### Joka kerta, kun aloitat työskentelyn

Avaa repo VS Codessa ja aja VS Coden omassa terminaalissa (Windowsissa Git Bash):
```bash
source .env                           # tunnukset tähän terminaaliin
claude                                # Claude Code näkee tunnukset
```
Venviä ei tarvitse aktivoida: skriptit ja hookit löytävät sen itse.

Ympäristömuuttujat näkyvät vain siinä terminaalissa, jossa `source .env` ajettiin, ja sieltä
käynnistetyissä ohjelmissa. VS Coden Claude Code -paneeli ei välttämättä näe niitä, jos VS Code
oli jo auki. Käynnistä Claude siksi samassa terminaalissa.

---

## Testien tekeminen Claude Codella

### Komennot

| Komento | Mitä tekee |
|---|---|
| `/tutki-web <näkymä>` | tutkii näkymän työpöytäselaimella ja palauttaa vahvistetut lokaattorit |
| `/tutki-mobiili <näkymä>` | sama mobiiliprofiililla (Pixel 7) ja vertailu työpöytään |
| `/uusi-testi <kuvaus tai tiedosto>` | suunnitelma → tutkiminen → kirjoitus → dryrun → katselmointi → kysymys ajosta |
| `/katselmoi` | tarkistaa muutokset repon sääntöjä vasten ennen ajoa |
| `/aja web` / `/aja mobile` | Claude ajaa testit ja analysoi epäonnistumiset |

Claude ei kirjoita tiedostoihin tutkimiskomennoissa eikä `/uusi-testi`-komennossa ennen kuin
olet hyväksynyt suunnitelman.

### Suositeltu työnkulku: ensin työpöytä, sitten mobiili

1. **Suunnitelma.** `/uusi-testi` tai plan mode (Shift+Tab). Tarkista, että Claude käyttää
   olemassa olevia keywordeja ja että testiin tulee vain ylätason askeleita.
2. **Työpöytä.** Claude tutkii (`/tutki-web`), kirjoittaa lokaattorit `UI_ids.py`:hin ja
   toteutuksen `keywords.resource`-tiedostoon.
3. **Testi vihreäksi.** Tagit `web_test` ja `wip`, katselmointi ja ajo `bash scripts/aja.sh web`.
   Testitiedosto on nyt valmis eikä muutu enää.
4. **Mobiilin erot.** `/tutki-mobiili` näyttää, mikä toimii sellaisenaan ja mikä ei.
5. **Vain erot mobiiliin.** Jos polku eroaa, keyword siirretään `device_specific/desktop/`- ja
   `device_specific/phone/`-tiedostoihin samalla nimellä. Vain mobiilin lokaattorit saavat
   etuliitteen `MOBILE_`.
6. **Molemmat vihreiksi.** `bash scripts/aja.sh web` ja `bash scripts/aja.sh mobile`, sitten
   `wip`-tagi pois.

Pidä työpöytä ja mobiili eri vaiheina. Kun työpöytä on ensin vihreä, mobiilissa nähdään
todelliset erot eikä niitä arvata etukäteen.

### Säännöt lyhyesti

Koko säännöstö on tiedostossa `CLAUDE.md`, ja Claude lukee sen joka istunnossa. Tärkeimmät:

- Testeissä vain ylätason askeleita: ei lokaattoreita, ei Browser-keywordejä, ei `Sleep`-kutsuja.
- Ei erillisiä mobiilitestejä eikä `IF`-ehtoja laitteen mukaan.
- Lokaattorit vain `UI_ids.py`:hin.
- Tunnukset vain ympäristömuuttujista.

Hookit valvovat näitä automaattisesti jokaisen tiedostomuutoksen jälkeen.

### Claude Coden osat repossa

| Osa | Tehtävä |
|---|---|
| `CLAUDE.md` | rakenne ja säännöt, latautuu aina |
| `.claude/commands/` | yllä luetellut komennot |
| `.claude/agents/rakenne-katselmoija` | katselmointi omassa kontekstissaan |
| `.claude/agents/lokaattori-tutkija` | raskas sivujen tutkiminen omassa kontekstissaan |
| `.claude/skills/mobile-web` | mobiiliemuloinnin erityistieto, latautuu vain mobiilityössä |
| `scripts/hooks/` | rakennetarkistus, salasanan esto ja RF-MCP-vahti |

### Harjoitukset

| Testi | Tila | Harjoitus |
|---|---|---|
| `Login Dialog Opens From Header` | valmis, lokaattorit vahvistettu | ensimmäinen vihreä ajo |
| `Login To Yle` | `wip`: `LOGGED_IN_INDICATOR` ja `LOGOUT_BUTTON` ovat TODO | viimeistele `/tutki-web`-komennolla ja poista `wip` |
| sama testi mobiilissa | `device_specific/phone/` on lähtöarvaus | vahvista `/tutki-mobiili`-komennolla |
| `Search Finds Articles` | runko, `wip` | toteuta `/uusi-testi`-komennolla, sitten mobiiliprofiililla |

---

## Testien ajaminen

```bash
bash scripts/aja.sh web                     # työpöytä
bash scripts/aja.sh mobile                  # mobiili, samat testit
bash scripts/aja.sh web --dryrun            # rakenteen tarkistus ilman selainta
bash scripts/aja.sh web --include smoke     # vain smoke-testit
DEVICE=chromium_desktop_headless bash scripts/aja.sh web   # ilman näkyvää selainta (CI)
```

- **Tulokset:** `results/web/` ja `results/mobile/` (`log.html`, `report.html`).
- **Tagit:** `web_test` kaikissa testeissä, `smoke` tärkeimmissä. `wip`-tagilla merkityt
  keskeneräiset testit jätetään ajoista pois.
- **Sama ajo suoraan robot-komennolla:**
  `robot --variable OS:web --variable DEVICE:pixel_7 --variable EXEC_ENV:TEST --include web_test tests/`

---

## Tietoturva

### Riskit

- **RF-MCP voi antaa agentille laajan pääsyn koneeseen.** Se suorittaa Robot Framework
  -keywordeja agentin pyynnöstä, ja Robot Frameworkin vakiokirjastot osaavat ajaa komentoja ja
  käsitellä tiedostoja.
- **Selattava sisältö voi yrittää ohjata agenttia** (prompt injection).
- **Tunnukset voivat päätyä lokeihin ja artefakteihin,** jos salasana syötetään väärällä tavalla.

### Mitä repo tekee

- **Ei automaattista lupaa RF-MCP:lle.** Claude Code kysyy luvan jokaiselle RF-MCP-kutsulle,
  joten näet jokaisen kutsun ennen suoritusta.
- **Hook `guard_mcp`** estää RF-MCP-kutsut, joissa on salasanan selväkielinen arvo tai komentoja
  ajava ja tiedostoja käsittelevä kirjasto (Process, OperatingSystem). Tarkistus on tekstipohjainen
  paras arvaus, ei täydellinen hiekkalaatikko.
- **Hook `block_secrets`** estää salasanan kirjoittamisen tiedostoihin.
- **`.gitignore`** pitää `.env`-tiedoston, `results/`-kansion ja RF-MCP:n `.robotmcp_artifacts/`-kansion
  poissa gitistä. Ne voivat sisältää sivujen sisältöä ja kuvakaappauksia kirjautuneesta tilasta.

### Pysyvä lupa RF-MCP:lle

Jos jokaisen kutsun hyväksyminen on hankalaa, anna lupa vain omalle koneellesi:

- **Claude Codessa:** `/permissions` → lisää sallittu sääntö `mcp__robotmcp` → tallenna
  paikallisiin projektiasetuksiin.
- **Tai tiedostoon** `.claude/settings.local.json`:
  ```json
  { "permissions": { "allow": ["mcp__robotmcp"] } }
  ```

`settings.local.json` on `.gitignore`ssa, joten lupa ei päädy repoon. Älä lisää lupaa tiedostoon
`.claude/settings.json`, koska se jaetaan kaikille repon käyttäjille. `guard_mcp` toimii myös
pysyvän luvan kanssa. Lupa poistetaan samasta paikasta.

### Suositukset

- Käytä erillistä testitunnusta, älä henkilökohtaista tunnusta.
- Älä pidä samassa terminaalissa muita salaisuuksia ympäristömuuttujissa (esim. pilvipalvelujen avaimia).
- Pidä RF-MCP oletuksena stdio-tilassa. Jos käytät HTTP-tilaa, sido se vain localhostiin.
- Tarkista organisaatiosi käytännöt kolmannen osapuolen kehitystyökalujen asentamisesta.

---

## Vianetsintä

| Oire | Syy | Korjaus |
|---|---|---|
| RobotCode pyytää asentamaan Robot Frameworkin käyttäjälle | tulkiksi ei ole valittu `.venv`:iä | kieltäydy ja tee vaihe 6 |
| `.venv puuttuu` tai `robot: command not found` | Python-ympäristöä ei ole luotu | tee vaihe 3 |
| `/mcp` ei näytä robotmcp:tä "connected"-tilassa | `robotmcp` ei ole PATHissa | tee vaihe 4 ja avaa uusi terminaali |
| `Get Device` ei löydä laitetta `Pixel 7` | Playwrightin laitenimet riippuvat versiosta | vaihda `PLAYWRIGHT_DEVICE` tiedostossa `resources/web/devices/pixel_7.py` |
| Ennen toiminut lokaattori lakkaa toimimasta | yle.fi:n rakenne on muuttunut | aja `/tutki-web` uudelleen; korjaus osuu vain `UI_ids.py`:hin |
| Hook ilmoittaa "Pythonia ei löytynyt" | Pythonia ei löydy Git Bashista | tee vaihe 3 tai tarkista Python-asennus |
| Kirjautumistesti kaatuu heti | tunnuksia ei ole ladattu Clauden terminaaliin | `source .env` ja `claude` samassa terminaalissa |

---

## Huomioita

- Testit ajetaan julkista tuotantopalvelua yle.fi vasten. Aja niitä kohtuudella: ei kuormitus-
  tai stressitestausta, ei toistuvia ajoja tiheällä aikataululla.
- Mobiiliemulointi testaa mobiiliverkkosivua, ei natiivisovellusta.
- Repo ei ole Ylen tekemä eikä Ylen ylläpitämä.
