from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

class User(db.Model):
    __tablename__ = 'UsersTable'

    userid = db.Column(db.string(50), primary_key=True)
    userName = db.Column(db.String(50), nullable=False)
    userSurname = db.Column(db.String(50), nullable=False)
    userDate = db.Column(db.Date, nullable=False)
    userEmail = db.Column(db.String(50), nullable=False)
    UserRole = db.Column(db.String(15), nullable=False)
    passwordHash = db.Column(db.String(50), nullable=False)

class Trail(db.Model):
    __tablename__ = "trails"

    trailid = db.Column(db.Integer, primary_key=True)
    trailname = db.Column(db.String(90), nullable=False)
    lengthInKm = db.Column(db.Float, nullable=False)
    elevationInM = db.Column(db.Float, nullable=False)
    difficulty = db.Column(db.String(20), nullable=False)
    TimeToComplete = db.Column(db.Integer, nullable=False)
    locationoftrail = db.Column(db.String(100), nullable=False)
    pets = db.Column(db.String(3), nullable=False)