-- Utiliser la base de données de nom TP4 vue en tp4
-- Choisir cette base (use)
use tp4;
-- A- Création des tables et insertion des données
-- a- vider le contenu de toutes les tables de la base tp4 
truncate table Employe;
truncate table Departement;

-- b- Créer le reste des tables du schéma(tenir compte des contraintes d’intégrité)
create table Projet (
    NumProj int primary key,
    NomP varchar(255) not null,
    NumDept int not null,
    constraint fk_NumDept foreign key (NumDept) references Departement(NumDept)
);

create table Travaille (
    NumEmp int,
    NumProj int,
    nbHeures int not null,
    primary key (NumEmp, NumProj),
    constraint fk_NumEmp foreign key (NumEmp) references Employe(NumEmp),
    constraint fk_NumProj foreign key (NumProj) references Projet(NumProj)
);

-- f- Insérer le jeu de données ci-dessous (voir script ci joint) vérifier le contenue de vos tables
insert into Departement values
    (10, 'DIRECTION', 'GENEVE'),
    (20, 'RECHERCHE', 'DALLAS'),
    (30, 'VENTE', 'CHICAGO'),
    (40, 'FABRICATION', 'BOSTON');

insert into Employe values
    (7839, 'KING', 'PRESIDENT', NULL, '1981-11-17', 5000, NULL, 10),
    (7566, 'JONES', 'MANAGER', 7839, '1981-04-02', 2975, NULL, 20),
    (7698, 'BLAKE', 'MANAGER', 7839, '2000-05-01', 2850, NULL, 30),
    (7782, 'CLARK', 'MANAGER', 7839, '1981-06-09', 2450, NULL, 10),
    (7369, 'SMITH', 'COMMERCIAL', 7566, '2002-12-17', 800, 20, 20),
    (7499, 'ALLEN', 'INGENIEUR', 7698, '1981-02-20', 1600, 300, 30),
    (7521, 'WARD', 'INGENIEUR', 7698, '1999-02-22', 1250, 500, 30),
    (7654, 'MARTIN', 'INGENIEUR', 7698, '1010-09-28', 1250, 1400, 30),
    (7844, 'TURNER', 'INGENIEUR', 7698, '1981-09-08', 1500, 0, 30),
    (7900, 'JAMES', 'COMMERCIAL', 7698, '1981-12-03', 950, NULL, 30),
    (7788, 'SCOTT', 'ANALYST', 7566, '1987-04-19', 3000, NULL, 20),
    (7876, 'ADAMS', 'COMMERCIAL', 7788, '1987-05-23', 1100, NULL, 20),
    (7902, 'FORD', 'ANALYST', 7566, '1981-12-03', 3000, NULL, 20),
    (7934, 'MILLER', 'COMMERCIAL', 7782, '1982-01-23', 1300, NULL, 10),
    (7935, 'ATIKIN', 'ANALYST', 7782, '1990-01-23', 1200, NULL, 10);

insert into Projet values
    (1, 'ALIO', 10),
    (2, 'SIP1', 20),
    (3, 'VENIP', 30),
    (4, 'ABLAY', 30),
    (5, 'ASIP', 10),
    (6, 'SIP2', 20);

insert into Travaille values
    (7499, 1, 100),
    (7499, 2, 70),
    (7521, 1, 30),
    (7566, 1, 45),
    (7654, 1, 25),
    (7654, 2, 30),
    (7654, 3, 70),
    (7654, 4, 45),
    (7654, 6, 100),
    (7902, 6, 35),
    (7902, 2, 75),
    (7935, 1, 67),
    (7935, 2, 75),
    (7844, 3, 66),
    (7844, 5, 33);

select * from Departement;
select * from Employe;
select * from Projet;
select * from Travaille;

-- B- Mise à jour des données
-- 1- Augmenter le salaire des commerciaux de 5% 
update employe set sal = sal * 1.05 where fonction = 'COMMERCIAL';

-- 2-Augmenter le salaire de SMITH de 10% et sa commission de 500
update employe set sal = sal * 1.1, comm = 500 where nom = 'SMITH';

-- 3-Changer le nom de l employé n° 7521 par : ALI 
update employe set nom = 'ALI' where NumEmp = 7521;

-- 4-Supprimer l’employé ATKIN qui a quitté l’entreprise 
delete from employe where nom = 'ATKIN';

-- 5-Rajouter une commission de 300 aux employés de noms qui commencent par la lettre M
update employe set comm = comm + 300 where nom like 'M%';

-- 6-Rajouter une commission de 350 aux employés qui n’ont pas de commission
update employe set comm = 350 where comm is null;

-- 7-Augmenter le nombre d’heures de l’employé ATKIN sur le projet ‘SIP1’ de 20h.
update travaille set nbHeures = nbHeures + 20 where NumEmp = (select NumEmp from Employe where nom = 'ATKIN') and NomP = 'SIP1';

-- 8-Créer un nouveau département : 50, COMPTABILITE, TOULOUSE
insert into Departement values (50, 'COMPTABILITE', 'TOULOUSE');

-- 9-Créer un nouveau département : 60, DIRECTION
insert into Departement (NumDept, NomD) values (60, 'DIRECTION');

-- 10-Dupliquer l'enregistrement du département 20, en lui donnant le numéro de département 25 (en utilisant un select pour récupérer les informations sur le département 20).
insert into Departement select 25, t.NomD, t.lieu from (select NomD, lieu from Departement where NumDept = 20) as t;

-- 11-Promouvoir Mr. MERCIER au poste de PDG, dans le département 60.
update Employe set fonction = 'PRESIDENT', NumDep = 60 where nom = 'MERCIER';

-- 12-Éliminer de la table EMP la ligne de Mr. BIRAUD qui prend sa retraite.
delete from Employe where nom = 'BIRAUD';

-- 13-Diminuer de 10 % le salaire de tous les employés du département 10.
update Employe set sal = sal * 0.9 where NumDep = 10;

-- 14-Mr. SIMON vient d'être embauché comme commercial au salaire de 10000 Frs. 
-- L'enregistrer sous le matricule 7910 dans le département 30.
insert into Employe values (7910, 'SIMON', 'COMMERCIAL', 7698, '2000-01-01', 10000, NULL, 30);

-- 15-supprimer tous les employés travaillant à CHICAGO
delete from Employe where NumDep = (select NumDept from Departement where lieu = 'CHICAGO');

-- 16-archiver le contenue de la table département dans une autre table de même structure de nom dept_archiv (voir cours)
create table Departement_Archive like Departement;
insert dept_archiv select * from Departement;