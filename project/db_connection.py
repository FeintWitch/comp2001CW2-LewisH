
import pathlib
import connexion 
from flask_sqlalchemy import SQLAlchemy
from flask_marshmallow import Marshmallow

basedir = pathlib.Path(__file__).parent.resolve()
connex_app = connexion.App(__name__, specification_dir=basedir)

app = connex_app.app
app.config["SQLALCHEMY_DATABASE_URI"] = (
    "mssqk+pyodbc:///?odbc_connect="
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
