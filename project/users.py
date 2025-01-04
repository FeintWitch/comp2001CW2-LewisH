

users = [
    "'Grace', 'Hopper', '2024-11-19 16:15:10'",
    "'Tim', 'Berners-Lee', '2024-11-19 16:15:13'",
    "'Ada', 'Lovelace', '2024-11-19 16:15:27'",
]
###conection##
connection = pyodbc.connect(
    "DRIVER={ODBC Driver 17 for SQL Server};"
    "SERVER = dist-6-505.uopnet.plymouth.ac.uk;"
    "DATABASE = COMP2001_LHalpin;"
    "UID = COMP2001_LHalpin;"
    "PWD = q3j&%KM8)zc-MD>;"
    "TrustServerCertificate=yes;"
    "Encrypt=yes;"
)
cursor = connection.cursor()

for person_data in users:
    cursor.execute(
        f"INSERT INTO UsersTable (FirstName, LastName, DateAdded) VALUES (?, ?, ?)",
        person_data,
    )

cursor.commit()

cursor.execute("SELECT * FROM UsersTable")
users = cursor.fetchall()
for user in users:
    print(user)

cursor.close()
connection.close()



