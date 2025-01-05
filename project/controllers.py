from flask import jsonify 
from models import db, trails

def get_trails():
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