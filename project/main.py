from flask import Flask
from db_connection import db_connection, close_db_connection

app = Flask(__name__)

@app.route('/')
def home():
    connection = get_db_connection()
    if connection:
        return "database connection successful"
    else:
        return "database connection failed"
    

##below makes sure if the app is closed so is the connection
@app.teardown_appcontext
def teardown_db(exception):
    close_db_connection()

if __name__ == '__main__':
    app.run(debug=True)