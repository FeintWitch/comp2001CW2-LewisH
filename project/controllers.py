from flask import jsonify 

def getUsers():
    users = [
        {"userName": "Grace", userSurname: "Hopper", "userid":"901","useremail":"grace@plymouth.ac.uk", "userRole":"employee","passwordHash":"ISAD123!"},
        {"userName": "Tim", userSurname: "Berners-Lee", "userid":"902","useremail":"tim@plymouth.ac.uk", "userRole":"employee","passwordHash":"COMP2001!"},
        {"userName": "Ada", userSurname: "Lovelace", "userid":"903","useremail":"ada@plymouth.ac.uk", "userRole":"employee","passwordHash":"insecurePassword"},
    ]
    return jsonify(users)