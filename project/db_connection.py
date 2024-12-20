from flask import g
import pyodbc

####the connection to the database###
def get_db_connection():
    if 'db_connection' not in g:
        try:
            g.db_connection= pyodbc.connect(
                "DRIVER={ODBC Driver 17 for SQL Server};"
                "SERVER=localhost;"
                "DATABASE=cw2;"
                "UID=SA;"
                "PWD=C0mp2001;"
                "TrustServerCertificate=yes;"
            )
            print ("Database connection established")
        except pyodbc.Error as e:
            print("Error connecting to the database")   
            g.db_connection = None
        return g.db_connection
    
###This sectiion bellow will be the tester## 
def close_db_connection(e=None):
    db_connection = g.pop('db_connection', None)
    if db_connection is not None:
        db_connection.close()
        print ("Database connection closed")

