
import pathlib
import connexion 
import urllib.parse


database = 'COMP2001_LHalpin'
username = 'LHalpin'
password = 'q3j&%KM8)zc-MD'
encoded_password = urllib.parse.quote_plus(password)

app = connex_app.app
app.config["SQLALCHEMY_DATABASE_URI"] = (
    f"mssql+pyodbc://{username}:{encoded_password}@dist-6-505.uopnet.plymouth.ac.uk/{database}"
    "?driver=ODBC+Driver+17+for+SQL+Server"
    "&TrustServerCertificate=yes"
    "&Encrypt=true"
    "&Trusted_Connection=no"
)