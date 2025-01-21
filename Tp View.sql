--Partie 1

create table Departement (
    NumDept int primary key,
    NomD varchar(20),
    lieu varchar(20)    
);

create table Employe (
    NumEmp int primary key,
    Nom varchar(20),
    fonction varchar(20),
    NumSup int,
    dateEmbauche date,
    sal int,
    comm int,
    Numdep int,     
    constraint fk_Numdep foreign key (Numdep) references Departement(NumDept),
    constraint fk_NumSup foreign key (NumSup) references Employe(NumEmp)
);   

create table Projet (
    NumProj int primary key,    
    NomP varchar(20),
    NumDept int,
    constraint fk_NumDept foreign key (NumDept) references Departement(NumDept)
);

create table Travaille (
    NumEmp int,
    NumProj int,
    nbHeures int,
    primary key (NumEmp, NumProj),    
    constraint fk_NumEmp foreign key (NumEmp) references Employe(NumEmp),
    constraint fk_NumProj foreign key (NumProj) references Projet(NumProj)
);

-- 1) Créer la vue empv1
create or replace view empv1 as select nom, sal from employe;

-- 2) Insérer les données suivantes
insert into empv1 values ('tittt12', 1000);
-- ORA-01400: cannot insert NULL into ("SYS"."EMPLOYE"."NUMEMP")

-- 3) Créer les view suivante
create or replace view empv1 as select numemp, nom, sal from employe where sal < 4000 with check option;
-- 4) insérer les donnes suivantes
insert into empv1 values (8000, 'Toto', 1000);
insert into empv1 values (8000, 'Toto', 1000);

-- la clé primaire ne peut pas etre dupliquée

-- Partie 2
-- 1-a-Créer la vue EMPDIR (select EMPNO, ENAME from emp) à partir de la table EMP.
create or replace view EMPDIR as select numemp, nom from employe;

-- b-Vérifier son contenu.
select * from EMPDIR;

--c- visualiser la requête de définition de cette vue
describe EMPDIR;

-- 2-a-Créer la vue EMPDEP (select EMPNO, ENAME, DEPTNO, DNAME from emp, dept where jointure….) à partir de la table EMP et DEPT.
create or replace view empdep as select e.numemp, e.nom, e.numdep, d.nomd from employe e, departement d where e.numdep = d.numdept;

-- b-Vérifier son contenu.
select * from empdep;

-- 3-
-- a- Depuis la vue EMPDIR, modifier le nom de l’employé n° 7839 en 'DARMONT'. (Vérifier si update sur empdir marche)
update empdir set nom = 'darmont' where numemp = 7839;

-- b-Vérifier son contenu.
select * from empdir where numemp = 7839;

-- 4. À travers la vue EMPDEPT, modifier le nom de l’employé n° 7698 en 'SINBAD'. Que se passe-t-il ? (Vérifier si update marche sur EMPDEPT)
update empdep set nom = 'sinbad' where numemp = 7698;
-- Nothing happen  

-- 5. Insérer un uplet quelconque dans la vue EMPDEPT. Est-ce que ca marche ? Ex : (9999, 'NEWEMP', 99, 'NEWDEPT');
insert into empdep (numemp, nom, numdep, nomd) values (9999, 'newemp', 99, 'newdept');
-- On ne peut pas insérer dans une vue basée sur une jointure

-- 6-supprimer la vue EMPDEP, vérifier si ca supprime les données des tables d’origines
drop view empdep;

-- 7. Lister toutes les tables qui vous sont accessibles (nom et propriétaire) en interrogeant la vue système ALL_TABLES.
select owner, table_name from all_tables;

-- 8. Lister les tables et les vues de votre compte, ainsi que leurs types (table ou vue), à l’aide de la vue système : USER_CATALOG.
select * from user_catalog;

-- 9. Lister toutes les contraintes d’intégrité définies sur vos tables à l’aide de la vue système
select constraint_name, table_name, constraint_type, status from user_constraints;

-- 10. À partir de la vue système USER_TAB_COLUMNS, afficher les attributs de la table EMP.
select * from user_tab_columns where table_name = 'employe';

-- 11. À partir de la vue système USER_TAB_COLUMNS, afficher le nom des tables et des vues qui ont pour attribut DEPTNO. Commentaire ?
select table_name, column_name from user_tab_columns where column_name = 'num_dep';