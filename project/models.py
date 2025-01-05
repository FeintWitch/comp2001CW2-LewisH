from flask_marshmallow import Marshmallow
from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()
ma = Marshmallow()

class User(db.Model):
    __tablename__ = 'UsersTable'

    userid = db.Column(db.String(50), primary_key=True)
    userName = db.Column(db.String(50), nullable=False)
    userSurname = db.Column(db.String(50), nullable=False)
    userDate = db.Column(db.Date, nullable=False)
    userEmail = db.Column(db.String(80), nullable=False, unique=True)
    UserRole = db.Column(db.String(15), nullable=False)
    passwordHash = db.Column(db.String(255), nullable=False)
    
    def to_dict(self):
        return {
            "userid": self.userid,
            "userName": self.userName,
            "userSurname": self.userSurname,
            "userDate": self.userDate,
            "userEmail": self.userEmail,
            "UserRole": self.UserRole,
            "passwordHash": self.passwordHash,
        }

    

class Trail(db.Model):
    __tablename__ = "trails"

    trailid = db.Column(db.Integer, primary_key=True)
    trailname = db.Column(db.String(90), nullable=False)
    lengthInKm = db.Column(db.Float, nullable=False)
    elevationInM = db.Column(db.Float, nullable=False)
    TimeToComplete = db.Column(db.Integer, nullable=False)
    locationoftrail = db.Column(db.String(100), nullable=False)
    pets = db.Column(db.String(3), nullable=False)

    def to_dict(self):
        return {
            "trailid": self.trailid,
            "trailname": self.trailname,
            "lengthInKm": self.lengthInKm,
            "elevationInM": self.elevationInM,
            "TimeToComplete": self.TimeToComplete,
            "locationoftrail": self.locationoftrail,
            "pets": self.pets,
        }