USE islandgamedb;


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
