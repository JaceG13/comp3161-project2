drop database if exists comp3161_proj;
create database if not exists comp3161_proj;
use comp3161_proj;

CREATE TABLE Patient (pID varchar(8) not null PRIMARY KEY,
	pNum INT(7),
	pFName VARCHAR(30) NOT NULL,
	pLname VARCHAR(30) NOT NULL,
	pDob date not null);

CREATE TABLE Family_History(famID varchar(8) PRIMARY KEY,
	famFName VARCHAR(30) NOT NULL,
	famLName VARCHAR(30) NOT NULL);

CREATE TABLE Doctor(docID varchar(8) PRIMARY KEY,
	docFName VARCHAR(30) NOT NULL,
	docLName VARCHAR(30) NOT NULL,
	dNum INT(7) NOT NULL,
	dDob date not null);

create table Intern(docID varchar(8) primary key,
	foreign key (docID) references Doctor(docID) on update cascade on delete cascade);
	
create table Resident(docID varchar(8) primary key,
	foreign key (docID) references Doctor(docID) on update cascade on delete cascade);

CREATE TABLE Consultant(docID varchar(8) NOT NULL primary key,
	specialization VARCHAR(50) NOT NULL,
	FOREIGN KEY (docID) references Doctor(docID) on update cascade on delete cascade);

CREATE TABLE Nurse(nID varchar(8) PRIMARY KEY,
	nFName VARCHAR(30) NOT NULL,
	nLName VARCHAR(30) NOT NULL,
	nDob DATE NOT NULL,
	address VARCHAR(50) NOT NULL,
	nurNum INT(7) NOT NULL
	);

CREATE TABLE Disease(disease_ID varchar(6) PRIMARY KEY,
	disease_name VARCHAR(50) NOT NULL
	);
	
CREATE TABLE Medication(med_ID varchar(6) PRIMARY KEY,
	med_name VARCHAR(50) NOT NULL
	);

CREATE TABLE Allergies(pID varchar(8),
	med_ID varchar(6) NOT NULL,
	primary key (pID,med_ID),
	FOREIGN KEY (pID) references Patient(pID) on delete cascade on update cascade,
	FOREIGN KEY (med_ID) references Medication(med_ID) on delete cascade on update cascade
	);
	
CREATE TABLE Accesses(nID varchar(8) NOT NULL,
	pID varchar(8) NOT NULL,
	famID varchar(8) NOT NULL,
	PRIMARY KEY (nID,pID,famID),
	FOREIGN KEY (nID) references Nurse(nID) on delete cascade on update cascade,
	FOREIGN KEY (pID) references Patient(pID) on delete cascade on update cascade,
	FOREIGN KEY (famID) references Family_History(famID) on delete cascade on update cascade);
	
create table Secretary(
	sID varchar(8) not null primary key,
	sFName varchar(50),
	sLName varchar(50),
	sDob DATE,
	sNum int(7)
);

create table Registers(
	sID varchar(8) not null,
	pID varchar(8) not null,
	primary key (sID,pID),
	FOREIGN KEY (pID) references Patient(pID) on delete cascade on update cascade,
	FOREIGN KEY (sID) references Secretary(sID) on delete cascade on update cascade
	);

CREATE TABLE Administers_Medication_To(nID varchar(8),
	pID varchar(8) NOT NULL,
	med_ID varchar(6) NOT NULL,
	process VARCHAR(50) NOT NULL,
	med_date date,
	primary key (nID,pID,med_ID),
	FOREIGN KEY (nID) references Nurse(nID) on delete cascade on update cascade,
	FOREIGN KEY (pID) references Patient(pID) on delete cascade on update cascade,
	FOREIGN KEY (med_ID) references Medication(med_ID) on delete cascade on update cascade);

CREATE TABLE Updates(nID varchar(8),
	pID varchar(8) NOT NULL,
	vital_signs VARCHAR(50) NOT NULL,
	primary key (nID,pID),
	FOREIGN KEY (nID) references Nurse(nID) on delete cascade on update cascade);

CREATE TABLE Belongs_To(pID varchar(8),
	famID varchar(8) NOT NULL,
	primary key(pID,famID),
	FOREIGN KEY (famID) references Family_History(famID) on delete cascade on update cascade,
	FOREIGN KEY (pID) references Patient(pID) on delete cascade on update cascade);

CREATE TABLE Present_In(famID varchar(8),
	disease_ID varchar(6) NOT NULL,
	primary key(famID,disease_ID),
	FOREIGN KEY (famID) references Family_History(famID) on delete cascade on update cascade,
	FOREIGN KEY (disease_ID) references Disease(disease_ID) on delete cascade on update cascade);

CREATE TABLE Records_Data_On(pID varchar(8),
	famID varchar(8) NOT NULL,
	docID varchar(8) NOT NULL,
	primary key(pID,famID,docID),
	FOREIGN KEY (pID) references Patient(pID) on delete cascade on update cascade,
	FOREIGN KEY (famID) references Family_History (famID) on delete cascade on update cascade,
	FOREIGN KEY (docID) references Doctor (docID) on delete cascade on update cascade);

create table Diagnosis(diagID varchar(6) not null,
	disease_ID varchar(6) not null,
	pID varchar(8) not null,
	diag_date date,
	primary key (diagID,disease_ID,pID),
	foreign key (pID) references Patient(pID) on update cascade on delete cascade,
	foreign key (disease_ID) references Disease(disease_ID) on update cascade on delete cascade
);

CREATE TABLE Records_Medicals_For(pID varchar(8),
	docID varchar(8) NOT NULL,
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


delimiter //
create procedure getAllergies(patient varchar(8))
BEGIN
	select pID, Medication.med_ID, med_name from Allergies join Medication on Allergies.med_ID = Medication.med_ID where pID = patient;
END//
DELIMITER ;



delimiter //
create procedure searchByDiagnosis(diag varchar(50), date1 date, date2 date)
begin
	Select pFName, pLName, Patient.pID From Diagnosis join Patient on(Diagnosis.pID = Patient.pID) join Records_Medicals_For on
	(Diagnosis.pID = Records_Medicals_For.pID) join Disease on Diagnosis.disease_ID = Disease.disease_ID Where disease_name = diag and diag_date between date1 and date2;
end//
delimiter ;



-- delimiter //
-- create procedure mostAllergic
-- begin
-- 	Select count(med_ID)
-- 	from allergies
-- 	group by med_ID



delimiter //
create procedure mostAllergic()
begin
	SELECT       Medication.med_ID, med_name, COUNT(Medication.med_ID) AS frequentMedicine
	    FROM     Allergies join Medication on Allergies.med_ID = Medication.med_ID
	    GROUP BY  Medication.med_ID
	    ORDER BY frequentMedicine DESC
	    LIMIT    1;
end//
delimiter ;



delimiter //
create procedure allTests(patient varchar(8))
begin
	Select test_results, scans from Records_Medicals_For where pID = patient;
end//
delimiter ;



delimiter //
create procedure allNurses(date1 date)
begin
	Select Nurse.nID, nFName, nLName
	from Nurse join Administers_Medication_To on(Nurse.nID = Administers_Medication_To.nID)
	where med_date = date1;
end//
delimiter ;



delimiter //
create procedure allInterns()
begin
	Select docFName, docLName, count(Intern.docID) as docCount from Intern join Records_Medicals_For on (Intern.docID = Records_Medicals_For.docID)
	join Doctor on (Doctor.docID = Intern.docID)
	group by Intern.docID
	order by docCount DESC
	Limit 1;
end//
delimiter ;

