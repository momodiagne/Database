-- Partie 1
create database BD3;
use BD3;

-- 1- Créer la table Departement et Employe sans tenir compte de contrainte d’intégrité dans la définition de cette table (sans clés étrangère , ni clés primaire)
create table Departement(
    NumDept int,
    NomD Varchar(50),
    lieu varchar(50)
);

create table Employe(
    NumEmp int, 
    Nom varchar(50), 
    fonction varchar (50), 
    NumSup int, 
    dateEmbauche date, 
    sal int, 
    comm int, 
    Numdep int
);

-- 2- Insérer le tuple ci-après dans la table Departement
-- (10,'DIRECTION,'NEW YORK')
insert into departement values (10, 'DIRECTION', 'NEW YORK');

-- Insérer le même tuple plusieurs fois dans la table Departement
insert into departement values (10, 'DIRECTION', 'NEW YORK');
insert into departement values (10, 'DIRECTION', 'NEW YORK');
insert into departement values (10, 'DIRECTION', 'NEW YORK');
-- Conclusion: Les requetes s'executent.

-- 3- Insérer le tuple suivant dans la table Employe plusieurs fois.
-- (7782,'CLARK','MANAGER',7839, '1981-11-18',2450,NULL,10);
insert into employe values (7782, 'CLARK', 'MANAGER', 7839, '1981-11-18', 2450, NULL, 10);
insert into employe values (7782, 'CLARK', 'MANAGER', 7839, '1981-11-18', 2450, NULL, 10);
insert into employe values (7782, 'CLARK', 'MANAGER', 7839, '1981-11-18', 2450, NULL, 10);
--Conclusion: Meme conclusion que la quetion 2

-- 4- Insérer un tuple suivant dans la table EMP. 
-- (7782,'CLARK','MANAGER',7839, '1981-06-8',2450,NULL,20);
insert into employe values (7782,'CLARK','MANAGER',7839, '1981-06-8',2450,NULL,20);
-- Ce tuple référencie un numéro de département qui n’existe pas dans la table Departement. Est ce que cette insertion est cohérente ?
-- Non.

-- 5- Comment résoudre les problèmes posés dans la question 2, 3, et 4 ?
-- Il faut definir les contraintes.

-- Partie 2

-- 1- Supprimer les 2 tables Departement et Employe

drop table Employe;
drop table Departement;

-- 2- Créer de nouveau les tables Departement et Employe en tenant en compte les contraintes suivantes:
--la contrainte d’intégrité, concernant la clé primaire, sur la table Departement.
-- la contrainte d’intégrité, concernant la clé primaire sur la table Employe.
-- la contrainte d’intégrité, concernant la clé étrangère (Numdep ) sur la table Employe fais reference à Numdep de la table département.
-- la contrainte d’intégrité, concernant la clé étrangère (NumSup) de la table Employe, qui fait référence à NumEmp de la table employé 

create table Departement (
    NumDept int primary key,
    NomD varchar(50),
    lieu varchar(50)
);

create table Employe (
    NumEmp int primary key,
    Nom varchar(50),
    fonction varchar(100),
    NumSup int,
    dateEmbauche date,
    sal decimal(10, 2),
    comm decimal(10, 2),
    Numdep int,
    constraint fk_NumDep foreign key (Numdep) references Departement(NumDept),
    constraint fk_NumSup foreign key (NumSup) references Employe(NumEmp)
);

alter table Departement add (constraint uk_lieu unique (lieu));
insert into departement values (1, 'College_of_computing', 'Benguerir');
insert into departement values (1, 'College_of_computing', 'RUfisque');
--ERROR 1062 (23000): Duplicate entry '10' for key 'departement.PRIMARY'

alter table employe add (constraint ch_sal check (sal>500));
insert into employe values (1111, 'MOMO', 'Etudiant', 1111, '1981-11-18', 250, NULL, 1);
--ERROR 3819 (HY000): Check constraint 'ch_sal' is violated.

-- 3- Insérer le tuple ci-après dans la table Departement 
insert into departement values (10,'DIRECTION','NEW YORK');
insert into departement values (10,'DIRECTION','NEW YORK');
--ERROR 1062 (23000): Duplicate entry '10' for key 'departement.PRIMARY'
-- La clé primaire ne peut pas etre dupliquée.

-- 4- Insérer le tuple suivant dans la table Employe .
insert into employe values (7839,'KING','PRESIDENT',NULL,'1982-11-13',5000,NULL,10);

-- 5- Insérer une autre fois le même tuple dans la table Employe . Conclusion
insert into employe values (7839,'KING','PRESIDENT',NULL,'1982-11-13',5000,NULL,10);
--ERROR 1062 (23000): Duplicate entry '7839' for key 'employe.PRIMARY'
-- La clé primaire ne peut pas etre dupliquée.

-- 6- Insérer le tuple suivant dans la table Employe .

insert into employe values (7782,'CLARK','MANAGER', 7839, '1981-11-18',2450,NULL,10);
select * from employe where NumEmp = 7782;

-- 7- Insérer le tuple suivant dans la table Employe. 
insert into employe values (7566,'JONES','MANAGER',7839,'1982-03-18',2975,NULL,20);
--ERROR 1452 (23000): Cannot add or update a child row: a foreign key constraint fails (`bd3`.`employe`, CONSTRAINT `fk` FOREIGN KEY (`Numdep`) REFERENCES `departement` (`Numdept`))

-- 8- On doit d'abord initialiser le departement 20 ou supprimer la contrainte 
