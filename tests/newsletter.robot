*** Settings ***
Documentation     Uutiskirjeen tilaus kirjautuneen käyttäjän profiilivalikosta. Samat testit kaikille
...               laitteille: laite valitaan ajossa muuttujalla DEVICE (chromium_desktop | pixel_7).
Variables         ${CURDIR}/../resources/shared/environments.py    ${EXEC_ENV}
Variables         ${CURDIR}/../resources/${OS}/UI_ids.py
Variables         ${CURDIR}/../resources/${OS}/devices/${DEVICE}.py
Resource          ${CURDIR}/../resources/${OS}/keywords.resource
Resource          ${CURDIR}/../resources/shared/shared_keywords.resource

Suite Setup       Open App
Suite Teardown    Close App

*** Variables ***
${NEWSLETTER}     Pinnalla

*** Test Cases ***
Subscribe To Popular Newsletter From Profile Menu
    [Documentation]    Kirjautunut käyttäjä tilaa yhden Suosituimmat-osion uutiskirjeen.
    [Tags]    web_test    wip
    Given User Is Logged In
    And User Opens Newsletters From Profile Menu
    When User Subscribes To Popular Newsletter    ${NEWSLETTER}
    Then Newsletter Should Be Subscribed    ${NEWSLETTER}
