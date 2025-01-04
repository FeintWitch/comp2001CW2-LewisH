from flask import Flask, render_template
import connexion
import pathlib
from flask_sqlalchemy import SQLAlchemy
from flask_marshmallow import Marshmallow

basedir = pathlib.Path(__file__).parent.resolve()
connex_app = connexion.App(__name__, specification_dir='./')


###flask config
app = connex_app.app
app.config["SQLALCHEMY_DATABASE_URI"] = (
    "mssql+pyodbc:///?odbc_connect="
    "DRIVER={ODBC Driver 17 for SQL Server};"
    "SERVER = dist-6-505.uopnet.plymouth.ac.uk;"
    "DATABASE = COMP2001_LHalpin;"
    "UID = COMP2001_LHalpin;"
    "PWD = q3j&%KM8)zc-MD>;"
    "TrustServerCertificate=yes;"
    "Encrypt=yes;"
)
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

db = SQLAlchemy(app)
ma = Marshmallow(app)

@connex_app.route('/')
def home():
    return render_template('home.html')
connex_app.add_api('swagger.yml')
    
    
if __name__ == '__main__':
    connex_app.run(host="0.0.0.0", port=8000, debug=True)