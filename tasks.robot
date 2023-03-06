*** Settings ***
Documentation       Template robot main suite.

Library             Collections
Library             MyLibrary
Resource            keywords.robot
Variables           variables.py
Resource            SblCrawling.robot
Resource            Filtering.robot
Library             RPA.Browser.Selenium



*** Keywords ***
MAIN FLOW
    create_csv
    ${configpath}    Data.current_diectory    
    ${File}   Set Variable   ${configpath}/Config/config.xlsx
    Wait Until Keyword Succeeds    15x   2s   Open Available Browser           https://www.snwm.org/roll-search
    Wait Until Keyword Succeeds    15x   2s   Maximize Browser Window
    Sleep    2s
    Run Keyword And Continue On Failure     Wait Until Keyword Succeeds    2x   5s   Click Element If Visible          //*[@id="cookiebar"]/a[2]
    ${data}     Filtering Data
    FOR    ${element}    IN    @{data}
        Log To Console    ${element}[TEST CASE ID]
        Log To Console    ${element}[Month of Death]
        Log To Console    ${element}[Year of Death]
        ${Status}    ${Comments}    Run Keyword And Ignore Error    Searching in Website        ${element}[Year of Death]    ${element}[Month of Death]
        Log To Console    ${Status}
        IF    '${Status}' == 'PASS'
            ${Comments}    Set Variable    Data Extraction Success
        ELSE
            ${Comments}    Set Variable     No Search Result Found
        END
        update_excel_value    ${File}    TEST CASE ID    ${element}[TEST CASE ID]    Status    ${Status}    Comments    ${Comments}
    END
    # Open the website and search by year
   
*** Tasks ***
SAMPLE Tasks
    MAIN FLOW

