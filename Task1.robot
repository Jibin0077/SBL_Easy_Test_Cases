*** Settings ***
Resource            SblCrawling.robot
# Resource            tasks.robot
Resource            Filtering.robot
Library             RPA.Browser.Selenium
# Variables           MyVariables.py


*** Keywords ***
MAIN FLOW
    # create_csv
    Wait Until Keyword Succeeds    15x   2s   Open Available Browser           https://www.snwm.org/roll-search
    Wait Until Keyword Succeeds    15x   2s   Maximize Browser Window
    Sleep    2s
    ${data}     Filtering Data
    FOR    ${element}    IN    @{data}
        Log To Console    ${element}[TEST CASE ID]
        Log To Console    ${element}[Month of Death]
        Log To Console    ${element}[Year of Death]
        Searching in Website        ${element}[Year of Death]    ${element}[Month of Death]
    END
    # Open the website and search by year
   
*** Tasks ***
SAMPLE Tasks
    MAIN FLOW

