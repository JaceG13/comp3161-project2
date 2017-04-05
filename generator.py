import random
import names
import MySQLLdb

db = MySQLLdb.connect("localhost", "testuser", "test123", "TESTDB")

cursor = db.cursor()
cursor.execute("SELECT VERSION()")

data = cursor.fetchone()

def generatePatient():

    for x in range(1, 500001):
        pID = x
        pNum = str(random.randint(1111111, 3333333))
        pFName = str(names.get_first_name())
        pLName = str(names.get_last_name())
        day = str(random.randint(01,29))
        month = str(random.randint(01, 13))
        year = str(random.randint(1920, 2017))
        
        dob = str(year) + str(month) + str(day)
        
        sql = "INSERT INTO Patient(pID, pNum, pFName, pLname ,dob) VALUES ('%s', '%s', '%s', '%s', '%s')" 
        %(pID, pNum, pFName, pLName, dob)
        
        try:
            cursor.execute(sql)
            db.commit()
        except:
            db.rollback()
        


