DROP DATABASE if exists islandgamedb;
CREATE DATABASE islandgamedb;
USE islandgamedb;

DROP USER if exists 'joseph'@'localhost';

CREATE USER 'joseph'@'localhost' IDENTIFIED BY '11111';
GRANT ALL ON islandgamedb.* TO 'joseph'@'localhost';

SELECT 'Connected to the Database' as STATUS;


DELIMITER $$ 
DROP PROCEDURE IF EXISTS GenerateTables$$
CREATE PROCEDURE GenerateTables()
BEGIN 

    -- Drop Existing Tables
    DROP TABLE IF EXISTS Player, Enemy, Boss, PlayerCharacter, Inventory, Game, `Session`, Chest, Tile, Item, ItemType, Lobby, Chat, ChatSession;
    
    -- Create Player Table
    CREATE TABLE Player (
        PlayerID INT AUTO_INCREMENT PRIMARY KEY,
        Username VARCHAR(50) NOT NULL,
        UserPassword VARCHAR(50) NOT NULL,
        Email VARCHAR(100),
        LockedUser BOOLEAN DEFAULT FALSE,
        AdminUser BOOLEAN DEFAULT FALSE,
        LoginAttempts INT DEFAULT 0,
        UserOnline BOOLEAN DEFAULT FALSE,
        HighScore INT DEFAULT 0
    );

    -- Create PlayerCharacter Table
    CREATE TABLE PlayerCharacter (
        CharacterID INT AUTO_INCREMENT PRIMARY KEY,
        PlayerID INT,
        GameID INT,
        TileID INT,
        Archetype VARCHAR(10),
        Health INT,
        `Level` INT,
        Kills INT DEFAULT 0,
        FOREIGN KEY (PlayerID) REFERENCES Player(PlayerID),
        FOREIGN KEY (GameID) REFERENCES Game(GameID),
        FOREIGN KEY (TileID) REFERENCES Tile(TileID)
    );

	-- Create Tile Table
    CREATE TABLE Tile (
        TileID INT AUTO_INCREMENT PRIMARY KEY,
        MapID INT,
        TileTypeID INT
    );
    
	-- Create Game Table
    CREATE TABLE Game (
        GameID INT AUTO_INCREMENT PRIMARY KEY,
        StartTime DATETIME,
        EndTime DATETIME,
        GameStatus ENUM('active', 'paused', 'completed') NOT NULL
    );

    -- Create Inventory Table
    CREATE TABLE Inventory (
        InventoryID INT AUTO_INCREMENT PRIMARY KEY,
        PlayerID INT,
        GameID INT,
        ItemTypeID INT,
        Quantity INT DEFAULT 1,
        FOREIGN KEY (PlayerID) REFERENCES Player(PlayerID),
        FOREIGN KEY (GameID) REFERENCES Game(GameID),
        FOREIGN KEY (ItemTypeID) REFERENCES ItemType(ItemTypeID)
    );

    -- Create Session Table
    CREATE TABLE `Session` (
        SessionID INT AUTO_INCREMENT PRIMARY KEY,
        PlayerID INT,
        GameID INT,
        StartTime DATETIME,
        EndTime DATETIME,
        SessionStatus ENUM('active', 'completed', 'terminated') NOT NULL,
        Score INT,
        FOREIGN KEY (PlayerID) REFERENCES Player(PlayerID),
        FOREIGN KEY (GameID) REFERENCES Game(GameID)
    );
	
    -- Create Map Table
	CREATE TABLE Map (
		MapID INT AUTO_INCREMENT PRIMARY KEY,
		GameID INT NOT NULL,
		TileID INT NOT NULL,
		MapType VARCHAR(50) NOT NULL, 
		MapNumber INT NOT NULL,
		FOREIGN KEY (GameID) REFERENCES Game(GameID), 
		FOREIGN KEY (TileID) REFERENCES Tile(TileID)  
    );
    
    -- Create Enemy Table
    CREATE TABLE Enemy (
        EnemyID INT AUTO_INCREMENT PRIMARY KEY,
        GameID INT,        
        TileID INT,
        `Name` VARCHAR(20) NOT NULL,
        Health INT,
        Damage INT
    );

    -- Create Boss Table
    CREATE TABLE Boss (
        BossID INT AUTO_INCREMENT PRIMARY KEY,
        GameID INT,
        `Name` VARCHAR(20) NOT NULL,
        TileID INT,
        Health INT,
        Damage INT
    );

    -- Create Chest Table
    CREATE TABLE Chest (
        ChestID INT AUTO_INCREMENT PRIMARY KEY,
        GameID INT,
        TileID INT,
        IsOpened BOOLEAN DEFAULT FALSE,
        FOREIGN KEY (GameID) REFERENCES Game(GameID),
        FOREIGN KEY (TileID) REFERENCES Tile(TileID)
    );

    
    -- Create Item Table
    CREATE TABLE Item (
        ItemID INT AUTO_INCREMENT PRIMARY KEY,
        ItemTypeID INT,
        ChestID INT,
        `Name` VARCHAR(50),
        Damage INT DEFAULT 0,
        Heal INT DEFAULT 20,
        FOREIGN KEY (ItemTypeID) REFERENCES ItemType(ItemTypeID),
        FOREIGN KEY (ChestID) REFERENCES Chest(ChestID)
    );

    -- Create ItemType Table
    CREATE TABLE ItemType (
        ItemTypeID INT AUTO_INCREMENT PRIMARY KEY,
        Archetype VARCHAR(50)
    );

    -- Create Chat Table
    CREATE TABLE Chat (
        ChatID INT AUTO_INCREMENT PRIMARY KEY,
        PlayerID INT,
        `Time` DATETIME,
        `Text` TEXT,
        FOREIGN KEY (PlayerID) REFERENCES Player(PlayerID)
    );

    -- Create ChatSession Table
    CREATE TABLE ChatSession (
        ChatSessionID INT AUTO_INCREMENT PRIMARY KEY,
        ChatID INT,
        SessionStart DATETIME,
        SessionEnd DATETIME,
        FOREIGN KEY (ChatID) REFERENCES Chat(ChatID)
    );

END$$

DELIMITER ;


DROP TABLE IF EXISTS tblClickTarget;
CREATE TABLE tblClickTarget(
   UserName varchar(50) PRIMARY KEY,
   `Password` varchar(50) NULL,
   Attempts INT DEFAULT 0,
   LOCKED_OUT BOOL DEFAULT FALSE
);

-- The CREATE TABLE and all other table specific DML could be put
-- into a PROCEDURE.
INSERT tblClickTarget( UserName, `Password`)
VALUES ('JosephC','1221'),
       ('Luffy','1691') ;

DROP PROCEDURE IF EXISTS Login;

DELIMITER $$

-- Login Procedure
CREATE PROCEDURE Login( IN pUserName VARCHAR(50), IN pPassword  VARCHAR(50))
COMMENT 'Check login'
BEGIN
    DECLARE numAttempts INT DEFAULT 0;
    
	-- 'Check for valid login', 
    -- if valid then select message "Logged in" and reset Attempts to 0, 
    IF EXISTS ( SELECT * 
                FROM tblClickTarget
                WHERE 
                  UserName = pUserName AND
                  `Password` = pPassword 
                  ) 
	THEN
		UPDATE tblClickTarget 
        SET Attempts = 0
        WHERE
           UserName = pUserName;
           
		SELECT 'Logged In' as Message;
    
    ELSE 
    -- else add to Attempts ,
        IF EXISTS(SELECT * FROM tblClickTarget WHERE UserName = pUserName) THEN 
        
			SELECT Attempts 
			INTO numAttempts
			FROM tblClickTarget
			WHERE 
			   UserName = pUserName;
			
			SET numAttempts = numAttempts + 1;
			
			IF numAttempts > 5 THEN 
			-- if Attempts > 5 then set lockout to true and select message 'locked out' 
				UPDATE tblClickTarget 
				SET LOCKED_OUT = True
				WHERE 
					 UserName = pUserName ;
					 
				 SELECT 'Locked Out' AS Message;
				 
			ELSE
			-- else select message 'Bad  password'
                 UPDATE tblClickTarget
                 SET Attempts = numAttempts
                 WHERE 
                    UserName = pUserName;
                    
				 SELECT 'Invalid user name and password';
			END IF;
      ELSE 
		SELECT 'Invalid user name and password';
      END IF;

    
    END IF;
                  
END $$
DELIMITER ;

call Login('Joseph','1223');

SELECT UserName, Attempts 
FROM tblClickTarget;

-- Adding a New User
DROP PROCEDURE IF EXISTS AddUserName;
DELIMITER $$
CREATE PROCEDURE AddUserName(IN pUserName VARCHAR(50))
BEGIN
  IF EXISTS (SELECT * 
     FROM tblClickTarget
     WHERE Username = pUserName) THEN
  BEGIN
     SELECT 'NAME EXISTS' AS MESSAGE;
  END;
  ELSE 
     INSERT INTO tblClickTarget(UserName, X,Y)
     VALUE (pUserName, 100,100); -- Need to check the X,Y location
     SELECT 'ADDED USER NAME' AS MESSAGE;
  END IF;
  
END $$
DELIMITER ;

/*
DROP PROCEDURE IF EXISTS PlayerQuit;
DELIMITER $$
CREATE PROCEDURE PlayerQuit(pUserName VARCHAR(50))
BEGIN
	IF EXISTS ( SELECT * FROM tblClickTarget WHERE UserName = pUserName) THEN
     DELETE FROM tblClickTarget WHERE UserName = pUserName;
     SELECT 'QUIT' AS MESSAGE;
	ELSE
     SELECT 'PLAYER DOES NOT EXIST' AS MESSAGE;
	END IF;
END$$ -- PlayerQuit

DROP PROCEDURE IF EXISTS HitFrom$$
CREATE PROCEDURE HitFrom(pUserName varchar (50), pX integer, pY integer)
BEGIN
   IF EXISTS (SELECT * FROM tblClickTarget WHERE Username = pUserName) THEN
   BEGIN
      -- Target area is within 10 of the click at (X,Y)
      SELECT count(*) 
      FROM tblClickTarget
      WHERE 
        (pX >=  X - 10 AND pX <= X + 10 ) AND
        (pY >= Y - 10 AND pY <= Y + 10) AND 
        Username <> pUserName
	  INTO @HitCount;
      
      UPDATE tblClickTarget
      SET Strength = Strength + @HitCount
      WHERE 
            (NOT @HitCount IS NULL AND @HitCount <> 0 ) AND
            Username = pUsername;
            
	 UPDATE tblClickTarget
     Set Strength = Strength -1
     WHERE
        (pX >=  X - 10 AND pX <= X + 10 ) AND
        (pY >= Y - 10 AND pY <= Y + 10) AND 
        Username <> pUserName;
      
      DELETE FROM tblClickTarget
      WHERE Strength <= 0;
      
      SELECT 'PLAYED ' AS MESSAGE;
   END;
   ELSE
    SELECT 'PLAYER GONE' AS MESSAGE;
   END IF;
END$$



DROP PROCEDURE IF EXISTS GetAllPlayers$$
CREATE PROCEDURE GetAllPlayers()
BEGIN
	SELECT UserName, Strength, X, Y
    FROM tblClickTarget ;
END$$
DELIMITER $$
DROP PROCEDURE IF EXISTS Move$$
CREATE PROCEDURE Move(pMaxX INT, pMaxY INT)
BEGIN
  -- MOVES +/- 10 pixels, this might be boring, 
  -- also it does not check it the target
  -- moves out of bounds, presumes MinX and MinY are 0.
  SET @newX = ROUND(RAND() * 20) - 10;
  SET @newY = ROUND(RAND() * 20) - 10;
  
 SELECT count(*)
 FROM tblClickTarget 
 WHERE
      ((X + @newX) >= 0 AND (X + @newX) <= pMaxX) AND
      ((Y + @newY) >= 0 AND (Y + @newY) <= pMaxY)
 INTO @Count;
  
  UPDATE tblClickTarget
  SET 
      X =  X + @newX , 
      Y =  Y +  @newY 
  WHERE
     ((X + @newX) >= 0 AND (X + @newX) <= pMaxX) AND
	((Y + @newY) >= 0 AND (Y + @newY) <= pMaxY);
     
  SELECT CONCAT('Move Updated ' , @Count, ' click target positions. Within bounds  [',0,',',0,',',pMaxX,',',pMaXY,']') as Message; 
END$$

--
-- TESTING AREA

-- This procedure is "work in progress" 
DROP PROCEDURE IF EXISTS TestPlay$$
CREATE PROCEDURE TestPlay(pNumberOfPlayers INT)
BEGIN
      DECLARE counter INT DEFAULT 0;
       REPEAT
		 SET @NewName = CONCAT('Asterix', counter);
         CALL AddUserName(@NewName);
         SET counter = counter + 1;
       UNTIL counter > pNumberOfPlayers
       END REPEAT ;
END$$

DELIMITER ;
-- Call TestPlay(100);

Call AddUserName('Asterix');
Call AddUserName('Obelix');
Call AddUserName('Obelix');
Call HitFrom('Asterix',95,110);
Call HitFrom('Asterix',1,1);
Call HitFrom('Obelix',95,110);
Call HitFrom('Obelix',95,100);

Call GetAllPlayers();
CALL Move(1024,1024);

-- SELECT * 
-- FROM tblClickTarget;
Call GetAllPlayers();
tblclicktarget
-- Call PlayerQuit('Asterix');
*/