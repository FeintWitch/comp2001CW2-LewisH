

users = [
    "'Grace', 'Hopper', '2024-11-19 16:15:10'",
    "'Tim', 'Berners-Lee', '2024-11-19 16:15:13'",
    "'Ada', 'Lovelace', '2024-11-19 16:15:27'",
]

for person_data in users:
    insert_cmd = f"INSERT INTO users VALUES({person_data});" 
    cursor.execute(insert_cmd)

cursor.commit()

cursor.execute("SELECT * FROM UsersTable")
users = cursor.fetchall()
for user in users:
    print(user)


