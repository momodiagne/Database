-- Partie 1: Prise en comptes des contraintes d’intégrité :

-- 1- Créer de nouveau les tables Departement et Employe en tenant en compte des contraintes suivantes:
-- la contrainte d’intégrité, concernant la clé primaire, sur la table Departement.
-- la contrainte d’intégrité, concernant la clé primaire sur la table Employe.
-- la contrainte d’intégrité, concernant la clé étrangère sur la table Employe. 
-- Ne pas oublier d’ajouter aussi la contrainte sur le champ numSup (chaque employé à un supérieur qui doit exister). Numsup est une clé étrangère qui fait référence à numemp dans la même table(employe) : auto jointure

create database TP4;
use TP4;

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
    NumDep int,
    constraint fk_NumDep foreign key (NumDep) references Departement(NumDept),
    constraint fk_NumSup foreign key (NumSup) references Employe(NumEmp)
);

-- 2-Les clauses UNIQUE et CHECK : 
-- a) Rajouter une contraint imposant que la valeur du champ 'lieu' soit unique
alter table Departement add (constraint uk_lieu unique (lieu));
insert into departement values (1, 'College_of_computing', 'Benguerir');
insert into departement values (1, 'College_of_computing', 'RUfisque');
--ERROR 1062 (23000): Duplicate entry '1' for key 'departement.PRIMARY'

-- b) Pour la table Employe imposer à ce que le salaire ne soit pas inférieur à 500.
alter table employe add (constraint ch_sal check (sal>500));

-- c) Teste sur table employe : insérer une ligne contenant un salaire inferieur à 500.
insert into employe values (1111, 'MOMO', 'Etudiant', 1111, '1981-11-18', 250, NULL, 1);
--ERROR 3819 (HY000): Check constraint 'ch_sal' is violated.

--3 -Insérer le tuple ci-après dans la table Departement 
insert into departement values (10,'DIRECTION','NEW YORK');
insert into departement values (10,'DIRECTION','NEW YORK');
--ERROR 1062 (23000): Duplicate entry '10' for key 'departement.PRIMARY'

-- 4- Insérer le tuple ci-après dans la table Departement
insert into departement values (30,'VENTE','CHICAGO');

-- 5- Insérer le tuple suivant dans la table Employe .
insert into employe values (7839,'KING','PRESIDENT',NULL,'1982-11-13',5000,NULL,10);

-- 6- Insérer une autre fois le même tuple dans la table Employe. Conclusion
insert into employe values (7839,'KING','PRESIDENT',NULL,'1982-11-13',5000,NULL,10);
--ERROR 1062 (23000): Duplicate entry '7839' for key 'employe.PRIMARY'
-- La clé primaire ne peut pas etre dupliquée.

-- 7- Insérer le tuple suivant dans la table Employe
insert into employe values (7782,'CLARK','MANAGER',7839, '1981-11-18',2450,NULL,10);

-- 8- Verifier le contenue de la table emp Avec select
select * from employe;

-- 7- Insérer le tuple suivant dans la table Employe. 
insert into employe values (7566,'JONES','MANAGER',7839,'1982-03-18',2975,NULL,20);
-- Va generer une erreur , Insertion non cohérente pourquoi ?
-- On doit d'abord initialiser le departement 20 ou supprimer la contrainte 

-- Partie 2: Manipulation de données

-- 1- Ajouter une colonne Adresse et e-mail dans la table emp en respectant ces conditions : l’email doit contenir un @.
alter table employe add Adresse varchar(255);
alter table employe add Email varchar(255), add constraint ch_email check (Email like '%@%');

-- 2- Tester la contrainte sur le champ email : en insérant une adresse email ne contenant pas @
insert into employe values (1,'JONES','MANAGER',7839,'1982-03-18',2975,NULL,20,'rufisque','mailsansarobase');
-- ERROR 3819 (HY000): Check constraint 'ch_email' is violated.

-- 3- consulter la table departement avec select
select * from departement;

-- 4-a) supprimer le département 30 de la table DEPT;
delete from departement where numdept = 30;
-- b) supprimer le département 10 de la table DEPT. Conclusion
delete from departement where numdept = 10;
-- ERROR 1451 (23000): Cannot delete or update a parent row: a foreign key constraint fails (`tp4`.`employe`, CONSTRAINT `fk_NumDep` FOREIGN KEY (`Numdep`) REFERENCES `departement` (`NumDept`))
-- On ne peut pas supprimer le departement 10 parce qu'il existe une contrainte de clé étrangère empêchant la suppression, sauf si elle est modifiée ou supprimée.

-- 5- Essayer de supprimer, à l aide d Alter et drop, la contrainte clé primaire dela table DEPT. Conclusion.
alter table Departement drop primary key;
-- ERROR 1553 (HY000): Cannot drop index 'PRIMARY': needed in a foreign key constraint
-- La colonne NumDept est la clé primaire, donc automatiquement définie comme NOT NULL. Supprimer la clé primaire ne supprime pas la contrainte NOT NULL.

--6- a) Insérer le tuple ci-après dans la table Departement
insert into departement values (70,'DIRECTION','BOSTON');

-- b) Rajouter une contraint imposant que la valeur du champ NomD (nom departement) soit unique
alter table Departement add constraint uk_nom unique (NomD);
-- ERROR 1062 (23000): Duplicate entry 'DIRECTION' for key 'departement.uk_nom'

-- c) Supprimer de la table département la ligne où num de departement =70
delete from departement where numdept = 70;

-- d) essayer maintenant de rajouter la contraint imposant que la valeur du champ NomD (nom departement) soit unique
alter table Departement add constraint uk_nom unique (NomD);
--La contrainte UNIQUE n'a pas pu être ajoutée initialement car MySQL vérifie l'unicité de toutes les valeurs existantes dans la colonne avant d'appliquer la contrainte.

-- 7- On souhaite supprimer toutes les tables. Indiquez l’ordre de suppression ou l’option de suppression.
-- On supprime d'abord les tables dépendantes pour éviter les violations des contraintes de clé étrangère.
-- Donc on supprime d'abord la table Employe en premier ensuite la table Departement.

-- 8- Supprimer toutes les tables.
drop table employe;
drop table departement;