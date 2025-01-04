from flask import jsonify 

def getUsers():
    users = [
        {"userName": "Grace", "userSurname": "Hopper", "userid":"901","useremail":"grace@plymouth.ac.uk", "userRole":"employee","passwordHash":"ISAD123!"},
        {"userName": "Tim", "userSurname": "Berners-Lee", "userid":"902","useremail":"tim@plymouth.ac.uk", "userRole":"employee","passwordHash":"COMP2001!"},
        {"userName": "Ada", "userSurname": "Lovelace", "userid":"903","useremail":"ada@plymouth.ac.uk", "userRole":"employee","passwordHash":"insecurePassword"},
    ]
    return jsonify(users)

def getTrails():
    trails = [
        {"trailid" :"1", "trailname" : "Plymbridge Circular", "lengthInKm" :"5.00", "elevationInM" : "147.00", "routeType" :"circular","TimeToComplete":  "83", "location" : "Plymouth Devon", "pets" :"yes"},
        {"trailid":"2", "trailname":"Plymbridge Old Canal and River Walk", "lengthInKm":"3.00", "elevationInM":"65.00", "routeType":"circular", "TimeToComplete":"42", "location":"Plymouth, Devon", "pets":"yes"},
    ]
    return jsonify(trails)

def addTrail():
    new_trail = request.json
