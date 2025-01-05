----for cw2----

---------------
--Main Tables--
---------------
--1.Trail Table---
CREATE TABLE cw2.Trails
(
    trailid INT PRIMARY KEY not NULL, 
    trailname VARCHAR(90) not NULL,
    ---this will make the commum display the length in km withhout me adding km---
    lengthInKm DECIMAL(5, 2) NOT NULL,
        lengthWithKm AS CAST(lengthInKm AS VARCHAR(10)) + ' km' PERSISTED, -- Computed column for km
    ---This is like above but for meters---
    elevationInM DECIMAL(5,2) NOT NULL,
        elevationWithM AS CAST(elevationInM AS VARCHAR(10)) + ' m' PERSISTED, -- Computed column for meters
    ---below only allows circular, out and back and poit to point to be added to routetype---
    routeType VARCHAR(20)
        CHECK (routeType in('circular', 'out-and-back', 'point-to-point' , 'loop' )),
    --now for time, will work like like meters and km
    TimeToComplete INT,
    TimeToCompleteHoursAndMinutes AS
        cast (TimeToComplete / 60 AS VARCHAR(5)) + ' hours ' +
        cast (TimeToComplete % 60 as VARCHAR(2)) + ' minutes ' PERSISTED,
    locationoftrail VARCHAR(100) not null, 
    pets VARCHAR(3) not null ---yes or no----
);
---------------
--2.Ratings---
CREATE TABLE cw2.RatingsTable
(
rateID int IDENTITY(1,1) PRIMARY KEY,
rank VARCHAR(8) not NULL
    CHECK (rank in ('easy', 'moderate', 'hard')), 
rate int NOT NULL,
trailid int NOT NULL, ---THIS IS THE FOREIGN KEY
    CONSTRAINT FK_RatingsTable FOREIGN KEY (trailid) REFERENCES cw2.Trails(trailid),
);
---------------
--3.Tables; trailinfor, features and activities---

CREATE TABLE cw2.trailinfor
(
    infoId INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(50),
    trailid int NOT NULL, ---THIS IS THE FOREIGN KEY
        CONSTRAINT FK_Trailinfor FOREIGN KEY (trailid) REFERENCES cw2.Trails(trailid)
);
CREATE TABLE cw2.Features
(
    featuresId INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(50),
    trailid int NOT NULL, ---THIS IS THE FOREIGN KEY
        CONSTRAINT FK_Features FOREIGN KEY (trailid) REFERENCES cw2.Trails(trailid)
);
CREATE TABLE cw2.Activites
(
    activitesId INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(50),
    trailid int NOT NULL, ---THIS IS THE FOREIGN KEY
        CONSTRAINT FK_Activites FOREIGN KEY (trailid) REFERENCES cw2.Trails(trailid)
);
---------------
--4.Tags tables; link table showcasing three tables trailinfo, features and activities----
CREATE TABLE cw2.tags_trailsTable
(
    infoId int,
    featuresId int, 
    activitesId int,
    primary key (infoId, featuresId, activitesId),
    FOREIGN KEY ( infoId) REFERENCES cw2.Trailinfor(infoId),
    FOREIGN KEY(featuresId) REFERENCES cw2.Features(featuresId),
    FOREIGN key (activitesId) REFERENCES cw2.Activites(activitesId)
);

---------------
--5.Description---
CREATE TABLE cw2.DescriptionTable(
    descriptionid int IDENTITY(1,1) PRIMARY KEY,
    trailid int, 
    userid NVARCHAR(50),
    descriptionText NVARCHAR(max),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT null,
    FOREIGN KEY (trailid) REFERENCES cw2.Trails(trailid),
    FOREIGN KEY (userid) REFERENCES cw2.UsersTable(userid)
);


---------------
--6. Users table
CREATE TABLE cw2.UsersTable
(
    userName VARCHAR(50),
    userSurname VARCHAR(50),
    userDate DATE,
    userid NVARCHAR(50) PRIMARY KEY NOT NULL,
    userEmail VARCHAR(80) NOT NULL,
    userRole VARCHAR(15), 
    passwordHash NVARCHAR(255) NOT NULL 
);
delete cw2.UsersTable

---------------
--inserts--
---------------
---for inserting into the trails_table---
go
INSERT INTO cw2.Trails (trailid, trailname, lengthInKm, elevationInM, routeType, TimeToComplete, locationoftrail, pets)
VALUES
(1, 'Plymbridge Circular', 5.00, 147.00, 'circular', 83,  'Plymouth, Devon', 'yes'),
(2, 'Plymbridge Old Canal and River Walk', 3.00, 65.00, 'circular', 42, 'Plymouth, Devon', 'yes'),
(3, 'Haytor Circular', 10.00, 364.00, 'circular', 178, 'Dartmoor National Park', 'yes');

--inserting into ratings 
INSERT INTO cw2.RatingsTable(rank,rate, trailid)
VALUES 
('easy', 4,1),
('moderate', 4, 2),
('easy', 3, 3);

---insertings the tags---
INSERT INTO cw2.trailinfor(name, trailid)
VALUES
('partially paved', 1), ('kid friendly', 1), 
('partially paved', 2),
('kid friendly', 3),('views', 3);
INSERT INTO cw2.Features(name, trailid)
VALUES('rail trails', 1), ('caves',1), 
('wildflowers',2),('wildlife' ,2),
('rocky', 3);
INSERT INTO cw2.Activites (name, trailid)
VALUES('walking',1),( 'bike touring',1),
('walking',2), ('hiking',2),
('hiking', 3),('camping',3);

---also tags---
INSERT INTO cw2.tags_trailsTable(infoId, featuresId, activitesId)
VALUES
(1,1,1),
(2,2,2),
(3,3,3);

Insert into cw2.UsersTable(userName, userSurname,userDate, userid, userEmail, userRole, passwordHash)
VALUES
('Grace','Hopper','2024-11-19','901','grace@plymouth.ac.uk','employee','ISAD123!'  ),
('Tim', 'berners-lee','2024-11-19','902','tim@plymouth.ac.uk','employee','COMP2001!' ),
( 'Ada', 'Lovelace', '2024-11-19','903','ada@plymouth.ac.uk','employee','insecurePassword');

   
---------------
--Selects/Views--
---------------
select * from cw2.Trails;
SELECT * FROM cw2.RatingsTable; 
SELECT * from cw2.trailinfor;
SELECT * from cw2.Features;
SELECT * FROM cw2.activites;
Select * FROM cw2.tags_trailsTable;
view
---------------
--crud---
---------------
--1. trail crud

---for insertings----
go
CREATE PROCEDURE cw2.InsertTrail
@trailid INT,
@trailname VARCHAR(90),
@lengthInKm DECIMAL(5,2),
@elevationInM DECIMAL(5,2),
@routeType VARCHAR(20),
@TimeToComplete int,
@locationoftrail VARCHAR(100),
@pets VARCHAR(3)
AS
BEGIN
    INSERT INTO cw2.Trails
    VALUES (@trailid, @trailname, @lengthInKm,@elevationInM,@routeType, @TimeToComplete, @locationoftrail, @pets )
end;

---for reading----
GO
CREATE PROCEDURE cw2.GetTrailById
    @trailid INT
AS  
BEGIN
    SELECT * FROM cw2.Trails WHERE trailid = @trailid;
END;

---for updating---
GO
CREATE PROCEDURE cw2.UpdateTrail
@trailid int,
@trailname VARCHAR(90),
@lengthInKm DECIMAL(5,2),
@elevationInM DECIMAL(5,2),
@routeType VARCHAR(20),
@TimeToComplete INT,
@locationoftrail VARCHAR(100),
@pets VARCHAR(3)
AS
BEGIN
    UPDATE cw2.Trails
    SET
    trailname = @trailname,
    lengthInKm = @lengthInKm,
    elevationInM = @elevationInM,
    routeType = @routeType,
    TimeToComplete = @TimeToComplete,
    locationoftrail = @locationoftrail,
    pets = @pets
    WHERE
    trailid = @trailid;
END

---deleting---
GO
CREATE PROCEDURE cw2.DeleteTrail
    @trailid INT 
AS
BEGIN
    DELETE FROM cw2.Trails
    WHERE Trailid= @trailid;
END;

---trigger table for looging----
GO
CREATE TABLE cw2.TrailsLogingTable
(
    traillogid int IDENTITY(1,1) PRIMARY key,
    trailid int,
    trailname VARCHAR(90),
    added_timestamp DATETIME DEFAULT GETDATE()
);
---------------------
--2. ratings CRUD
---for insertings----
GO
CREATE PROCEDURE cw2.insertRatings
@rank VARCHAR(8), 
@rate int NOT NULL,
@trailid int 
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO cw2.RatingsTable
    VALUES ( @rank, @rate,@trailid)
end;

---for reading----
GO
CREATE PROCEDURE cw2.GetRatingById
    @rateID INT
AS  
BEGIN
    SELECT * FROM cw2.RatingsTable WHERE rateID = @rateID;
END;

---for updating---
GO
CREATE PROCEDURE cw2.UpdateRatings
@rateID int, 
@rank VARCHAR(8), 
@rate int NOT NULL,
@trailid int 
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
    UPDATE cw2.RatingsTable
    SET

    rank = @rank,
    rate = @rate,
    trailid = @trailid
    WHERE
    rateID = @rateID;
    IF @@ROWCOUNT=0
        BEGIN
            RAISERROR('NO RATING FOUND', 16,1)
END
END TRY
BEGIN CATCH
    THROW;
END CATCH
END;

---deleting---
GO
CREATE PROCEDURE cw2.DeleteRating
    @rateID INT 
AS
BEGIN
    DELETE FROM cw2.RatingsTable
    WHERE rateID= @rateID;
END;

---trigger table for looging----
GO
CREATE TABLE cw2.RatingsLogingTable
(
    logid int IDENTITY(1,1) PRIMARY key,
    rateID int,
    rank VARCHAR(8), 
    rate int NOT NULL,
    trailid int NOT NULL,
    added_timestamp DATETIME DEFAULT GETDATE()
);

---------------------
--3. TAGS;  trailinfo crud

---for insertings----
GO
CREATE PROCEDURE cw2.insertTrailinfor
@name VARCHAR(8), 
@trailid int 
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO cw2.trailinfor
    VALUES (@infoId, @name, @trailid)
end;

---for reading----
GO
CREATE PROCEDURE cw2.GetInfoidById
    @infoId INT
AS  
BEGIN
    SELECT * FROM cw2.trailinfor WHERE infoId = @infoId;
END;

---for updating---
GO
CREATE PROCEDURE cw2.UpdateTrailinfor
@infoId int, 
@name varchar(8), 
@trailid int 
AS
BEGIN
    UPDATE cw2.trailinfor
    SET
    infoId = @infoId,
    [name] = @name,
    trailid = @trailid
    WHERE
    infoId = @infoId;
END

---deleting---
GO
CREATE PROCEDURE cw2.Deleteinfor
    @infoId INT 
AS
BEGIN
    DELETE FROM cw2.trailinfor
    WHERE infoID= @infoId;
END;

---trigger table for looging trailinfo----
GO
CREATE TABLE cw2.trailInforLogingTable
(
    logid int IDENTITY(1,1) PRIMARY key,
    infoId int, 
    [name] varchar(8),
    trailid int NOT NULL,
    added_timestamp DATETIME DEFAULT GETDATE()
);

--4. TAGS;  Features crud

---for insertings----
GO
CREATE PROCEDURE cw2.insertFeatures
@name VARCHAR(8), 
@trailid int 
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO cw2.features
    VALUES (@featuresId, @name, @trailid)
end;

---for reading----
GO
CREATE PROCEDURE cw2.GetFeatureIdById
    @featureId INT
AS  
BEGIN
    SELECT * FROM cw2.Features WHERE featuresId = @featureId;
END;

---for updating---
GO
CREATE PROCEDURE cw2.UpdateFeatures
@featureId int, 
@name varchar(8), 
@trailid int 
AS
BEGIN
    UPDATE cw2.Features
    SET
    featuresId = @featureId,
    [name] = @name,
    trailid = @trailid
    WHERE
    featuresId = @featureId;
END

---deleting---
GO
CREATE PROCEDURE cw2.Deletefeatures
    @featureId INT 
AS
BEGIN
    DELETE FROM cw2.Features
    WHERE 
    featuresId = @featureId;
END;

---trigger table for looging trailinfo----
GO
CREATE TABLE cw2.FeaturesLogingTable
(
    logid int IDENTITY(1,1) PRIMARY key,
    featuresId int, 
    [name] varchar(8),
    trailid int NOT NULL,
    added_timestamp DATETIME DEFAULT GETDATE()
);

--4. TAGS;  Activites crud

---for insertings----
GO
CREATE PROCEDURE cw2.insertActivites
@name VARCHAR(8), 
@trailid int 
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO cw2.Activites
    VALUES (@activitesId, @name, @trailid)
end;

---for reading----
GO
CREATE PROCEDURE cw2.activitesIdById
    @activitesId INT
AS  
BEGIN
    SELECT * FROM cw2.Activites WHERE activitesId = @activitesId;
END;

---for updating---
GO
CREATE PROCEDURE cw2.UpdateActivites
@activitesId int, 
@name varchar(8), 
@trailid int 
AS
BEGIN
    UPDATE cw2.Activites
    SET
    activitesId = @activitesId,
    [name] = @name,
    trailid = @trailid
    WHERE
    activitesId = @activitesId;
END

---deleting---
GO
CREATE PROCEDURE cw2.DeleteActivites
@activitesId int
AS
BEGIN
    DELETE FROM cw2.Activites
    WHERE 
    activitesId = @activitesId;
END;

---trigger table for looging trailinfo----
GO
CREATE TABLE cw2.ActivitesLogingTable
(
    logid int IDENTITY(1,1) PRIMARY key,
    activitesId int, 
    [name] varchar(8),
    trailid int NOT NULL,
    added_timestamp DATETIME DEFAULT GETDATE()
);


--5. TAGS link table

---for insertings----
GO
CREATE PROCEDURE cw2.inserttags_trailsTable
    @infoId INT,
    @featuresId INT,
    @activitesId INT
AS
BEGIN
    INSERT INTO cw2.tags_trailsTable
    VALUES (@infoId, @featuresId, @activitesId)
end;

---for reading----
GO
---honestly didn't know what to do here---
SELECT * from cw2.tags_trailsTable

----no updating since it will cause issues

---deleting---
GO
CREATE PROCEDURE cw2.deletetags_trailsTable
    @infoId INT,
    @featuresId INT,
    @activitesId INT
AS
BEGIN
    DELETE FROM cw2.tags_trailsTable
    WHERE 
    infoID = @infoId and 
    featuresId = @featuresId and 
    activitesId = @activitesId;
END;

---trigger table for looging trailinfo----
GO
CREATE TABLE cw2.TagsLogingTable
(
    logid int IDENTITY(1,1) PRIMARY key,
    infoId INT,
    featuresId INT,
    activitesId INT,
    added_timestamp DATETIME DEFAULT GETDATE()
);


--6. Description  crud

---for insertings----
GO
CREATE PROCEDURE cw2.insertDescriptionTable
@trailid int, 
@userid NVARCHAR(50),  
@descriptionText NVARCHAR(max)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO cw2.DescriptionTable
    VALUES (@trailid, @userid, @descriptionText)
end;
 
---for reading----
GO
CREATE PROCEDURE cw2.DescriptionById
    @descriptionid int
AS  
BEGIN
    SELECT * FROM cw2.DescriptionTable WHERE descriptionid = @descriptionid;
END;

---for updating---
GO
CREATE PROCEDURE cw2.UpdateDescriptionTable
@descriptionid int, 
@trailid int, 
@userid NVARCHAR(50),  
@descriptionText NVARCHAR(max)
AS
BEGIN
    UPDATE cw2.DescriptionTable
    SET
    descriptionid = @descriptionid,
    trailid = @trailid,
    userid = @userid,
    descriptionText = @descriptionText
    WHERE
    descriptionid = @descriptionid;
END

---deleting---
GO
CREATE PROCEDURE cw2.DeleteDescriptionid
@descriptionid int
AS
BEGIN
    DELETE FROM cw2.DescriptionTable
    WHERE 
    descriptionid = @descriptionid;
END;

---trigger table for looging trailinfo----
GO
CREATE TABLE cw2.DescriptionTableLogingTable
(
    descriptionid int, 
    trailid int, 
    userid NVARCHAR(50),  
    descriptionText NVARCHAR(max),
    added_timestamp DATETIME DEFAULT GETDATE()
);

--6. users table
--insert---

GO 
    CREATE PROCEDURE cw2.insertUsers
    @userid NVARCHAR(50),
    @userEmail VARCHAR(80),
    @userRole VARCHAR(15),
    @passwordHash NVARCHAR(255)
AS
BEGIN
    INSERT INTO cw2.UsersTable
    VALUES (@userid, @userEmail, @userRole)
end;

---for reading----
GO
CREATE PROCEDURE cw2.UseryId
     @userid NVARCHAR(50)
AS  
BEGIN
    SELECT * FROM cw2.UsersTable WHERE @userid = @userid;
END;

---for updating---
GO
CREATE PROCEDURE cw2.UpdateUserTable
    @userid NVARCHAR(50),
    @userEmail VARCHAR(80),
    @userRole VARCHAR(15),
    @passwordHash NVARCHAR(255)
AS
BEGIN
    UPDATE cw2.UsersTable
    SET
    userid=@userid,
    userEmail=@userEmail,
    userRole=@userRole,
    passwordHash = @passwordHash
    WHERE
    userid=@userid;
END

--deleting---
GO
CREATE PROCEDURE cw2.DeleteUserId
 @userid NVARCHAR(50)
 AS
BEGIN
    DELETE FROM cw2.UsersTable
    WHERE 
    userid = @userid;
END;

---trigger table for looging trailinfo----
GO
CREATE TABLE cw2.UsersTableLogingTable
(
    userid NVARCHAR, 
    userEmail varchar(50), 
    descriptionText NVARCHAR(max),
    passwordHash NVARCHAR(255),
    added_timestamp DATETIME DEFAULT GETDATE()
);

---------------
--Testing---
---------------
--- test crud for trails---
---testing create---
INSERT INTO cw2.Trails (trailid, trailname, lengthInKm, elevationInM, routeType, TimeToComplete, locationoftrail, pets)
VALUES
(4, 'test trail',8.5,200,'circular', 110, 'sample', 'yes');
SELECT * FROM cw2.Trails where trailid =4; ---<---testing read

---testing update---
UPDATE cw2.Trails
SET trailname = 'updates test trail'
WHERE trailid=4;
SELECT * FROM cw2.Trails where trailid =4;

---testling delete---

DELETE FROM cw2.Trails WHERE trailid = 4;
SELECT * FROM cw2.Trails where trailid = 4;


---NOW FOR THE TRIGGER
GO
CREATE TRIGGER cw2.Logtrail
on cw2.Trails
AFTER INSERT
AS BEGIN
    INSERT INTO cw2.TrailsLogingTable(trailid, trailname, added_timestamp)
    SELECT trailid, trailname, GETDATE()
    from inserted;
end; 
DISABLE TRIGGER cw2.Lograte on cw2.RatingsTable
---testing---
INSERT INTO cw2.Trails (trailid, trailname, lengthInKm, elevationInM, routeType, TimeToComplete, locationoftrail, pets)
VALUES
(4, 'test trail',5.5,200,'circular', 90, 'sample','yes');

--select to see
SELECT * from cw2.TrailsLogingTable;

---
--testing rattingstable
---
--testing select---
insert into cw2.RatingsTable(rateID,rank,rate,trailid)
values
(4,'hard',2,4);
SELECT * from cw2.RatingsTable where rateID = 4;

--testing update-
update cw2.RatingsTable
set rate = 5
where rateID =4;
SELECT * FROM cw2.RatingsTable where rateID=4;

---testing delete---
DELETE FROM cw2.RatingsTable where rateID=4;
SELECT * from cw2.RatingsTable WHERE rateID=4;

---NOW FOR THE TRIGGER
GO
CREATE TRIGGER cw2.Lograte
on cw2.RatingsTable
AFTER INSERT
AS BEGIN
    INSERT INTO cw2.rattingstable(rateID, rank, rate, trailid, added_timestamp)
    SELECT rateID, rank, rate, GETDATE()
    from inserted;
    end; 
    