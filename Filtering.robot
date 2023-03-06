*** Settings ***
Documentation       Template robot main suite.
# Library             RPA.Browser.Selenium
Library             RPA.core.notebook
Library             Data.py
Library             RPA.Excel.Files
Library             RPA.Tables
Library             Collections
Library             RPA.Browser.Selenium
Resource            SblCrawling.robot


*** Keywords ***
Filtering Data
#-----------------Collecting the Testcases whose flag is YES to process---------------------#
    ${File}   Set Variable   C:/Users/Q0041/Documents/Robots/RoboCorp/SBL_Easy_TestCase/Config/config.xlsx
    Open Workbook       ${File}
    ${data}=  Read Worksheet As Table  Controller  header=${True}
    Close Workbook
    # Log To Console    ${data}
    Filter Table By Column      ${data}    Execute_Flag  ==  Yes
    
    Return From Keyword        ${data}

# *** Tasks ***
# Sample Tasks
#     Filtering Data
#--------------------------New Keyword----------------------------------
*** Keywords ***
Searching in Website
    [Arguments]    ${year}    ${month}
    Wait Until Keyword Succeeds    10x   3s   Click Element When Visible     //*[@id="yearofdeath"]
    Wait Until Keyword Succeeds    10x   3s   Select From List By Value    //*[@id="yearofdeath"]     ${year}
    sleep   1s
    Wait Until Keyword Succeeds    10x   3s   Click Element When Visible 	 //*[@id="monthofdeath"]
    Wait Until Keyword Succeeds    10x   3s   Select From List By Label    //*[@id="monthofdeath"]    ${month}
    Wait Until Keyword Succeeds    2x   2s   Click Element When Visible         //*[@class="emailsub searchsub"]
    ${MsgBoxPresent}     Wait Until Keyword Succeeds    3x   3s      Is Element Visible       //*[contains(text(),"Your search returned too many results.") or contains(text(),"Sorry, your search did not return any results.")]
    IF     ${MsgBoxPresent}
        # ${status}    Set Variable     FAIL
        Sleep    1s
        Click Element    //*[@id="cookiebar"]/a[2]
        Return From Keyword           No Search Result Found 
    ELSE
        Navigate through pages
        # ${status}    Set Variable     PASS
        Return From Keyword         Data Extraction Success
    END
    # ${Status}    ${Reason}    Run Keyword And Ignore Error    Navigate through pages
#---------------------------------------------------------------------------------