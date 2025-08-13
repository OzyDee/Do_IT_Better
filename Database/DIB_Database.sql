-- CLIENTS TABLE
CREATE TABLE Clients (
    ClientID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    Phone NVARCHAR(20),
    Address NVARCHAR(255),
    CreatedAt DATETIME DEFAULT GETDATE(),
    Notes NVARCHAR(MAX)
);

-- USERS TABLE (STAFF/ADMINS)
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    Username NVARCHAR(50) UNIQUE NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    Role NVARCHAR(30) NOT NULL, -- e.g. admin, tech, manager
    PasswordHash NVARCHAR(255) NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- SERVICES TABLE
CREATE TABLE Services (
    ServiceID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX),
    Price DECIMAL(10,2) NOT NULL
);

-- DEVICES TABLE
CREATE TABLE Devices (
    DeviceID INT IDENTITY(1,1) PRIMARY KEY,
    ClientID INT NOT NULL,
    Type NVARCHAR(50), -- e.g. laptop, desktop, printer
    Brand NVARCHAR(50),
    Model NVARCHAR(100),
    SerialNumber NVARCHAR(100),
    OS NVARCHAR(50),
    Notes NVARCHAR(MAX),
    FOREIGN KEY (ClientID) REFERENCES Clients(ClientID) ON DELETE CASCADE
);

-- APPOINTMENTS TABLE
CREATE TABLE Appointments (
    AppointmentID INT IDENTITY(1,1) PRIMARY KEY,
    ClientID INT NOT NULL,
    UserID INT NOT NULL,
    ServiceID INT NULL,
    DeviceID INT NULL,
    StartTime DATETIME NOT NULL,
    EndTime DATETIME NOT NULL,
    Status NVARCHAR(30) DEFAULT 'pending',
    FOREIGN KEY (ClientID) REFERENCES Clients(ClientID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (ServiceID) REFERENCES Services(ServiceID),
    FOREIGN KEY (DeviceID) REFERENCES Devices(DeviceID)
);

-- If you want many-to-many between appointments and services, use a junction:
CREATE TABLE AppointmentServices (
    AppointmentID INT NOT NULL,
    ServiceID INT NOT NULL,
    PRIMARY KEY (AppointmentID, ServiceID),
    FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID) ON DELETE CASCADE,
    FOREIGN KEY (ServiceID) REFERENCES Services(ServiceID)
);

-- PAYMENTS TABLE
CREATE TABLE Payments (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    ClientID INT NOT NULL,
    AppointmentID INT NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    Method NVARCHAR(50) NOT NULL, -- card, cash, online, etc.
    PaidAt DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(30) DEFAULT 'pending',
    FOREIGN KEY (ClientID) REFERENCES Clients(ClientID),
    FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID)
);

-- SUPPORT TICKETS / JOBS TABLE
CREATE TABLE SupportTickets (
    TicketID INT IDENTITY(1,1) PRIMARY KEY,
    ClientID INT NOT NULL,
    DeviceID INT NULL,
    CreatedBy INT NULL, -- Can reference Users.UserID or be NULL if created by client
    Description NVARCHAR(MAX) NOT NULL,
    Status NVARCHAR(30) DEFAULT 'open',
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ClientID) REFERENCES Clients(ClientID),
    FOREIGN KEY (DeviceID) REFERENCES Devices(DeviceID),
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID)
);

-- EDUCATION / TRAINING SESSIONS TABLE
CREATE TABLE EducationSessions (
    SessionID INT IDENTITY(1,1) PRIMARY KEY,
    ClientID INT NOT NULL,
    UserID INT NOT NULL,
    Topic NVARCHAR(100) NOT NULL,
    Date DATETIME NOT NULL,
    Notes NVARCHAR(MAX),
    FOREIGN KEY (ClientID) REFERENCES Clients(ClientID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- If you want many-to-many for group sessions:
CREATE TABLE SessionClients (
    SessionID INT NOT NULL,
    ClientID INT NOT NULL,
    PRIMARY KEY (SessionID, ClientID),
    FOREIGN KEY (SessionID) REFERENCES EducationSessions(SessionID) ON DELETE CASCADE,
    FOREIGN KEY (ClientID) REFERENCES Clients(ClientID) ON DELETE CASCADE
);
