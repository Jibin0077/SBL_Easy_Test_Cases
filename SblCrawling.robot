# -*- coding: utf-8 -*-
*** Settings ***
Documentation       Sbl Web Crawling Roll Search
# Library             RPA.Browser
Library             RPA.Browser.Selenium
Library             RPA.core.notebook
Library             RPA.Excel.Files
Library             RPA.Tables
Library             Collections
Library             Excel_Activity.py
Library             Data.py


# +
*** Keywords ***
Open the website and search by year
    create_csv
    Wait Until Keyword Succeeds    15x   3s   Open Available Browser           https://www.snwm.org/roll-search
    Wait Until Keyword Succeeds    15x   3s   Maximize Browser Window
    Sleep    2s
    Run Keyword And Continue On Failure     Wait Until Keyword Succeeds    2x   5s   Click Element If Visible          //*[@id="cookiebar"]/a[2]
    Wait Until Keyword Succeeds    15x   3s   Click Element When Visible     //*[@id="yearofdeath"]
    
#------------------------------create the year list  and get the count-------------------------------------------#
    ${count}=   Get Element Count                                           //*[@class="daterow"]//*[@id="yearofdeath"]/option
    @{type_list}=    Create List
    FOR    ${i}    IN RANGE    1            2
        ${year_list}  Get Value                                           //*[@id="yearofdeath"]/option[${i+1}]
        Append To List    ${type_list}    ${year_list}   
    END
    Notebook Print      ${type_list}
    FOR    ${row}    IN   @{type_list}
        Notebook Print  ${row}
        Log                                                                           //*[@id="yearofdeath"]//option[@value=${row}]
        Wait Until Keyword Succeeds    2x   5s   Click Element When Visible          //*[@id="yearofdeath"]//option[@value=${row}]
        sleep   1s
        Wait Until Keyword Succeeds    2x   5s   Click Element When Visible         //*[@class="emailsub searchsub"]
        
       
        #check the popup is present or not    
        Sleep    2s
        ${MsgBoxPresent}     Wait Until Keyword Succeeds    2x   3s      Is Element Visible       //*[contains(text(),"Your search returned too many results.") or contains(text(),"Sorry, your search did not return any results.")]
         IF     ${MsgBoxPresent}
             #------------------------------------create the month list and get the count----------------------------------------------------#      
            ${count_3}=       Get Element Count                                           //*[@class="daterow"]//*[@id="monthofdeath"]/option
            @{data_list}=    Create List
            FOR    ${x}    IN RANGE     9          ${count_3}
                ${month_list}  Get Value                                           //*[@class="daterow"]//*[@id="monthofdeath"]/option[${x+1}] 
                Append To List    ${data_list}    ${year_list}  
                Wait Until Keyword Succeeds    15x   2s   Click Element When Visible 	 //*[@id="monthofdeath"]
                Wait Until Keyword Succeeds    15x   2s   Click Element When Visible 	 //*[@class="daterow"]//*[@id="monthofdeath"]/option[${x+1}] 
                Wait Until Keyword Succeeds    5x   2s   Click Element When Visible          //*[@id="yearofdeath"]//option[@value=${row}]
                sleep   1s
                Wait Until Keyword Succeeds    5x   2s   Click Element When Visible         //*[@class="emailsub searchsub"]
                Navigate through pages
            END
        
            
        END
      
    END
  
   
# -


*** Keywords ***
Navigate through search results and write to excel
    ${status}   ${out}     Run Keyword And Ignore Error      Wait Until Element Is Visible     //*[@id="contentstart"]/div[2]/div/table/tbody/tr
    IF  '${status}' == 'FAIL'
        Return From Keyword
       
    ELSE
        # ${count_1}       Get Element Count        //*[@id="rhs"]/div[3]/div/table/tbody/tr
        ${count_1}       Get Element Count        //*[@id="contentstart"]/div[2]/div/table/tbody/tr
        
        @{new_searchlist}=   Create List
       
        #------------------------------table creation-------------------------------------------#
    #    ${header_list}    Create List     Era    Surname    Forename    Rank    Service Number    Decoration    Place of Birth    Place of Death    Theatre of Death    Cause of Death    SNWM Roll    Unit Name    Other Detail    Record Url
    #    ${table}=       Create Table  columns=${header_list} 
        #---------------------------------------------------------------------------------------------------------------------
        FOR    ${j}    IN RANGE      5    #${count_1}         # 0     5     1
            # log     //*[@id="rhs"]/div[3]/div/table/tbody/tr[${j+1}]
            Log    //*[@id="contentstart"]/div[2]/div/table/tbody/tr[${j+1}]
            #-----------------check the pop_up msg present in the toolbar------------------------------#
            Run Keyword And Continue On Failure     Wait Until Keyword Succeeds    2x   5s   Click Element If Visible      //*[@id="cookiebar"]/a[2]
            
            Scroll Element Into View    //*[@id="contentstart"]/div[2]/div/table/tbody/tr[${j+1}]
            #-----------------------------extract the record url-----------------------------------------
            # Scroll Element Into View    //*[@id="contentstart"]/div[2]/div/table/tbody/tr[${j+1}]/td/a 
            ${Ext_Record_url}        Get Element Attribute    //*[@id="contentstart"]/div[2]/div/table/tbody/tr[${j+1}]/td/a          href
            Wait Until Keyword Succeeds    5x   2s    Click Element When Visible           //*[@id="contentstart"]/div[2]/div/table/tbody/tr[${j+1}]
            #---------------------------------extract the Book details-------------------------------------------------#
            Book Details         ${Ext_Record_url}   
            Wait Until Keyword Succeeds    5x   2s   Click Element When Visible       //*[contains(text(),'Return to search results')]
            #Return From Keyword        ${Ext_Record_url}
        END
       
    END

# +
***Keywords***
#------------------------------------------------Extract the details and store the data in variables----------------------------------------------#
Book Details
    [Arguments]        ${Ext_Record_url}    
    ${Ext_era}               Get Text        //table[@class="result"]/tbody/tr[1]/td[2]
    ${Ext_sur_name}          Get Text        //table[@class="result"]/tbody/tr[2]/td[2]
    ${Ext_fore_name}         Get Text        //table[@class="result"]/tbody/tr[3]/td[2]
    ${Ext_rank}              Get Text        //table[@class="result"]/tbody/tr[4]/td[2]
    ${Ext_service_number}    Get Text        //table[@class="result"]/tbody/tr[5]/td[2]
    ${Ext_decoration}        Get Text        //table[@class="result"]/tbody/tr[6]/td[2]
    ${Ext_birth_place}       Get Text        //table[@class="result"]/tbody/tr[7]/td[2]
    ${Ext_death_place}       Get Text        //table[@class="result"]/tbody/tr[8]/td[2]
    ${Ext_theatre_death}     Get Text        //table[@class="result"]/tbody/tr[9]/td[2]
    ${Ext_death_cause}       Get Text        //table[@class="result"]/tbody/tr[10]/td[2]
    ${Ext_roll}              Get Text        //table[@class="result"]/tbody/tr[11]/td[2]
    ${Ext_unit_name}         Get Text        //table[@class="result"]/tbody/tr[12]/td[2]
    ${Ext_other_detail}      Get Text        //table[@class="result"]/tbody/tr[13]/td[2]

    #---------------------------------------------passing the variables ----------------------------------------------------------------------------#
    Write data To config file      ${Ext_era}   ${Ext_sur_name}  ${Ext_fore_name}    ${Ext_rank}    ${Ext_service_number}   ${Ext_decoration}    ${Ext_birth_place}  ${Ext_death_place}  ${Ext_theatre_death}    ${Ext_death_cause}  ${Ext_roll}  ${Ext_unit_name}   ${Ext_other_detail}    ${Ext_Record_url} 
       
    
# -

*** Keywords ***
#-------------------------------------------------------write data to csv--------------------------------------------------------------------------------------------------------#
Write data To config file
        
        [Arguments]          ${Ext_era}   ${Ext_sur_name}  ${Ext_fore_name}    ${Ext_rank}    ${Ext_service_number}   ${Ext_decoration}    ${Ext_birth_place}  ${Ext_death_place}  ${Ext_theatre_death}    ${Ext_death_cause}  ${Ext_roll}  ${Ext_unit_name}   ${Ext_other_detail}       ${Ext_Record_url} 
        ${data_list}    Create List    ${Ext_era}   ${Ext_sur_name}  ${Ext_fore_name}    ${Ext_rank}    ${Ext_service_number}   ${Ext_decoration}    ${Ext_birth_place}  ${Ext_death_place}  ${Ext_theatre_death}    ${Ext_death_cause}  ${Ext_roll}  ${Ext_unit_name}   ${Ext_other_detail}       ${Ext_Record_url} 
        # Add Table Row      ${table}    ${data_list}
        # Write table to CSV    ${table}    test.csv    delimiter=|
        append_to_csv      EsyOut.csv        ${data_list} 
        
    
*** Keywords ***
Navigate through pages
    #------------------------------table creation-------------------------------------------#
        #${header_list}    Create List     Era    Surname    Forename    Rank    Service Number    Decoration    Place of Birth    Place of Death    Theatre of Death    Cause of Death    SNWM Roll    Unit Name    Other Detail    Record Url
        #${table}=       Create Table  columns=${header_list} 
    
    # Navigate through search results and write to excel
    Run Keyword And Continue On Failure     Wait Until Keyword Succeeds    3x   5s   Click Element If Visible      //*[@id="cookiebar"]/a[2]
    # ${count_2}       Get Element Count        //p/strong[contains(text(),"Page:")]/following-sibling::a
    # log     ${count_2}
    FOR    ${k}    IN RANGE    1   #1     1     5
        
        # Wait Until Keyword Succeeds    2x   2s    Click Element When Visible           //p/strong[contains(text(),"Page:")]/following-sibling::a[${k}]
        Navigate through search results and write to excel
    END
    Wait Until Keyword Succeeds    5x   3s   Click Element When Visible     //*[@id="menu_c_roll-search"]//*[contains(text(),"Roll search")]

# *** Tasks ***
# Rollsearch
#     ${main_status}   ${main_out}     Run Keyword And Ignore Error    Open the website and search by year


