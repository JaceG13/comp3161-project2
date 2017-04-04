drop database if exists comp3161_proj;
create database if not exists comp3161_proj;
use comp3161_proj;

CREATE TABLE Patient (pID varchar(6) PRIMARY KEY,
	pNum INT(7),
	pFName VARCHAR(30) NOT NULL,
	pLname VARCHAR(30) NOT NULL);

CREATE TABLE Family_History(famID varchar(6) PRIMARY KEY,
	famFName VARCHAR(30) NOT NULL,
	famLName VARCHAR(30) NOT NULL);

CREATE TABLE Doctor(docID varchar(6) PRIMARY KEY,
	docFName VARCHAR(30) NOT NULL,
	docLName VARCHAR(30) NOT NULL,
	dNum INT(7) NOT NULL);

CREATE TABLE Consultant(docID varchar(6) NOT NULL primary key,
	specialization VARCHAR(50) NOT NULL,
	FOREIGN KEY (docID) references Doctor(docID) on update cascade on delete cascade);

CREATE TABLE Nurse(nID varchar(6) PRIMARY KEY,
	nFName VARCHAR(30) NOT NULL,
	nLName VARCHAR(30) NOT NULL,
	dob DATE NOT NULL,
	address VARCHAR(50) NOT NULL,
	nurNum INT(7) NOT NULL);

CREATE TABLE Disease(disease_ID varchar(6) PRIMARY KEY,
	disease_name VARCHAR(50) NOT NULL
	);
	
CREATE TABLE Medication(med_ID varchar(6) PRIMARY KEY,
	med_name VARCHAR(50) NOT NULL
	);

CREATE TABLE Allergies(pID varchar(6),
	med_ID varchar(6) NOT NULL,
	primary key (pID,med_ID),
	FOREIGN KEY (pID) references Patient(pID) on delete cascade on update cascade,
	FOREIGN KEY (med_ID) references Medication(med_ID) on delete cascade on update cascade
	);
	
CREATE TABLE Accesses(nID varchar(6) NOT NULL,
	pID varchar(6) NOT NULL,
	famID varchar(6) NOT NULL,
	PRIMARY KEY (nID,pID,famID),
	FOREIGN KEY (nID) references Nurse(nID) on delete cascade on update cascade,
	FOREIGN KEY (pID) references Patient(pID) on delete cascade on update cascade,
	FOREIGN KEY (famID) references Family_History(famID) on delete cascade on update cascade);

CREATE TABLE Administers_Medication_To(nID varchar(6),
	pID varchar(6) NOT NULL,
	med_ID varchar(6) NOT NULL,
	process VARCHAR(50) NOT NULL,
	med_date date,
	primary key (nID,pID,med_ID),
	FOREIGN KEY (nID) references Nurse(nID) on delete cascade on update cascade,
	FOREIGN KEY (pID) references Patient(pID) on delete cascade on update cascade,
	FOREIGN KEY (med_ID) references Medication(med_ID) on delete cascade on update cascade);

CREATE TABLE Updates(nID varchar(6),
	pID varchar(6) NOT NULL,
	primary key (nID,pID),
	vital_signs VARCHAR(50) NOT NULL,
	FOREIGN KEY (nID) references Nurse(nID) on delete cascade on update cascade);

CREATE TABLE Belongs_To(pID varchar(6),
	famID varchar(6) NOT NULL,
	primary key(pID,famID),
	FOREIGN KEY (famID) references Family_History(famID) on delete cascade on update cascade,
	FOREIGN KEY (pID) references Patient(pID) on delete cascade on update cascade);

CREATE TABLE Present_In(famID varchar(6),
	disease_ID varchar(6) NOT NULL,
	primary key(famID,disease_ID),
	FOREIGN KEY (famID) references Family_History(famID) on delete cascade on update cascade,
	FOREIGN KEY (disease_ID) references Disease(disease_ID) on delete cascade on update cascade);

CREATE TABLE Records_Data_On(pID varchar(6),
	famID varchar(6) NOT NULL,
	docID varchar(6) NOT NULL,
	primary key(pID,famID,docID),
	FOREIGN KEY (pID) references Patient(pID) on delete cascade on update cascade,
	FOREIGN KEY (famID) references Family_History (famID) on delete cascade on update cascade,
	FOREIGN KEY (docID) references Doctor (docID) on delete cascade on update cascade);

create table Diagnosis(diagID varchar(6) not null primary key,
	diagName varchar(50) not null,
	diag_date date
);

CREATE TABLE Records_Medicals_For(pID varchar(6),
	docID varchar(6) NOT NULL,
	diagID varchar(6),
	date_created date,
	date_modified date,
	scans varchar(30) NOT NULL,
	procedures varchar(30) NOT NULL,
	treatment varchar(30) NOT NULL,
	test_results varchar(50) NOT NULL,
	primary key(pID,docID,diagID),
	FOREIGN KEY (pID) references Patient(pID) on delete cascade on update cascade,
	FOREIGN KEY (docID) references Doctor(docID) on delete cascade on update cascade,
	FOREIGN KEY (diagID) references Diagnosis(diagID) on delete cascade on update cascade);

