import os

#--------------Driver for Chrome Version 107, must change based on installed chrome version------------------#
def Chromedriver_diectory():
    relpath = os.getcwd()
    # print(os.getcwd())
    driver = relpath+"\chromedriver.exe"
    return driver
# print(Chromedriver_diectory())

#----------------------------Custom File path------------------------------------#
def current_diectory():
    relpath = os.getcwd()
    # print(os.getcwd())
    curr_dict = relpath
    return curr_dict
# print(current_diectory())

import pandas as pd
import csv

def create_csv():
    # assign header columns
    #headerList = ['Title', 'Author', 'Publication date', 'Publisher', 'Collection', 'Contributor', 'Identifier', 'Copyright', 'image file name']
    headerList = ['Era','Surname','Forename','Rank','Service Number','Decoration','Place of Birth','Place of Death','Theatre of Death','Cause of Death','SNWM Roll','Unit Name','Other Detail','Record Url']
    relpath = os.getcwd()
    path=relpath+'\input'
    print(path)
    # open CSV file and assign header
    # with open("Internet_Archive_out.csv", 'w') as file:
    #     dw = csv.DictWriter(file, delimiter='|', 
    #                         fieldnames=headerList)
    #     dw.writeheader()

    with open("EsyOut.csv", 'w', newline='') as f:

        writer = csv.writer(f, delimiter="|")

        writer.writerow(headerList)
    
    # display csv file
    fileContent = pd.read_csv("EsyOut.csv")
    fileContent
# create_csv()

def pdf_name(string):    
    # string = "https://archive.org/download/Buffalo_NY_Death_Index_1885-1891/Reclaim_The_Records_-_Buffalo_NY_Death_Index_-_1885-1891_-.pd"
    words = string.split('/')
    for i in words:
        check = i.__contains__(".pdf") or i.__contains__(".zip")
        
    if check == True:
            print(i)
            return i
    else:
        print('0')
        return 0
# pdf_name("https://archive.org/download/Buffalo_NY_Death_Index_1885-1891/Reclaim_The_Records_-_Buffalo_NY_Death_Index_-_1885-1891_-.zip")


def write_csv():
    # assign header columns
    #headerList = ['Title', 'Author', 'Publication date', 'Publisher', 'Collection', 'Contributor', 'Identifier', 'Copyright', 'image file name']
    headerList = ['Title2','Author', 'Publication date', 'Publisher', 'Collection', 'Contributor', 'Identifier', 'Copyright', 'image file name']
    # relpath = os.getcwd()
    # path=relpath+'\input'
    # print(path)
    # open CSV file and assign header
    with open("Internet_Archive_out.csv", 'w',newline='') as file:
        dw = csv.DictWriter(file, delimiter='|', 
                            fieldnames=headerList)
        dw.writeheader()
    
    # display csv file
    fileContent = pd.read_csv("Internet_Archive_out.csv")
    fileContent
# write_csv()

# import csv  

# fields=['first','second','third']

def append_to_csv(filename, data):

    with open(filename, 'a', newline='') as f:

        writer = csv.writer(f, delimiter="|")

        writer.writerow(data)



# append_to_csv('s.csv', fields)