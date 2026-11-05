*** Settings ***
Variables         ${CURDIR}/../../resources/shared/environments.py    ${EXEC_ENV}
Variables         ${CURDIR}/../../resources/${OS}/UI_ids.py
Variables         ${CURDIR}/../../resources/${OS}/devices/${DEVICE}.py
Resource          ${CURDIR}/../../resources/${OS}/keywords.resource
Resource          ${CURDIR}/../../resources/shared/shared_keywords.resource
Documentation     Haku. HARJOITUS: toteuta Claude Codella (/uusi-testi).

*** Variables ***
${SEARCH_TERM}    sää

*** Test Cases ***
Search Finds Articles
    [Documentation]    HARJOITUS: työpöytä ensin, sitten sama testi mobiiliprofiililla.
    [Tags]    web_test    wip
    # Given User Is On Front Page
    # When User Searches For    ${SEARCH_TERM}
    # Then Search Results Should Contain Articles
    Skip    Harjoitus: toteuta /uusi-testi-komennolla
