from flask import jsonify 
from models import db

def getUsers():
    try:
        users = users.query.all()
        return jsonify([user.to_dict() for user in users]), 200
    except Exception as e:
        return {"error": str(e)}, 500

def getTrails():
    try:
        trails = trails.query.all()
        return jsonify([trail.to_dict() for trail in trails]), 200
    except Exception as e:
        return {"error": str(e)}, 500

def addTrail(trail_date):
    try:
        new_trail = trails(**trail_date)
        db.session.add(new_trail)
        db.session.commit()
        return jsonify(new_trail.to_dict()), 201
    except Exception as e:
        return {"error": str(e)}, 500

def updateTrail(trail_id, trail_date):
    try:
        trail = trails.query.filter_by(id=trail_id).first()
        if not trail:
            return {"error": "Trail not found"}, 404
        trail.trail_date = trail_date.get("trail_date", trail.trail_date)
        db.session.commit()
        return jsonify(trail.to_dict()), 200
    except Exception as e:
        return {"error": str(e)}, 500

def deleteTrail(trail_id):
    try:
        trail = trails.query.filter_by(id=trail_id).first()
        if not trail:
            return {"error": "Trail not found"}, 404
        db.session.delete(trail)
        db.session.commit()
        return {"message": "Trail deleted"}, 200
    except Exception as e:
        return {"error": str(e)}, 500