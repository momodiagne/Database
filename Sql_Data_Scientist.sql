-- Exercice1:
-- CREATE TABLE t (a VARCHAR(20));
-- INSERT INTO t VALUES('Hello World');
-- INSERT INTO t VALUES('Good Bye world');
-- En utilisant le jeu de données ci dessus, donner la requête en sql permettant l affichage de la restitution des 4 premières caractères de la colonne a et les affichés sous une colonne de nom substring, selon l’affichage suivant : Utiliser la fonction SUBSTR()

connect sys as sysdba;

create table t (a varchar(20));
insert into t values('Hello World');
insert into t values('Good Bye world');

select a, substr(a,1,4) as substring from t;

-- Exercice 2
-- On dispose d'une liste de noms propres mal formatés avec des espaces inutiles.
CREATE TABLE nom_propres (
nom VARCHAR(50) PRIMARY KEY
);
 INSERT INTO nom_propres VALUES (' JoHnSoN ');
 INSERT INTO nom_propres VALUES (' thunberg ');
 INSERT INTO nom_propres VALUES (' aleXandrE ');
 INSERT INTO nom_propres VALUES (' zappA ');
-- Proposer une requête permettant d'afficher ces noms propres en majuscules et sans les espaces inutiles. (On pourra composer des fonctions)

select upper(trim(nom)) from nom_propres;

-- Exercice 3
-- Soit le schéma relationnel suivant :
-- Employe (NumEmp, Nom, fonction, #NumSup,dateEmbauche,sal,comm, #Numdep)
-- Departement (NumDept,NomD,lieu)
-- Projet (NumProj,NomP, #NumDept)
-- Travaille (#NumEmp, #NumProj, nbHeures)
-- *) Supérieur référence le NumEmp du supérieur

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

-- 1-Calculer la moyenne des salaires, le salaire minimum et maximum, ainsi que le nombre d'employés par département, exemple d affichage :

select 
    d.NomD, 
    avg(e.sal) as moyenne_sal, 
    max(e.sal) as MAX_sal, 
    min(e.sal) as MIN_sal, 
    count(e.NumEmp) as Total_emp
from 
    departement d
join 
    employe e 
on 
    d.NumDept = e.NumDep
group by 
    d.NomD;

-- 2- même question que 1), avec un nombre d employé >1.
select 
    d.NomD, 
    avg(e.sal) as moyenne_sal, 
    max(e.sal) as MAX_sal, 
    min(e.sal) as MIN_sal, 
    count(e.NumEmp) as Total_emp
from 
    departement d
join 
    employe e 
on 
    d.NumDept = e.NumDep
group by 
    d.NomD
having 
    count(e.NumEmp) > 1;

-- 3- même question que 1), plus une ligne supplémentaire représentant le total global. Comme le montre la figure suivante (utiliser ROLLUP avec group by )

select  
    d.NomD, 
    avg(e.sal) as moyenne_sal, 
    max(e.sal) as MAX_sal, 
    min(e.sal) as MIN_sal, 
    count(e.NumEmp) as Total_emp
from 
    departement d
join 
    employe e 
on 
    d.NumDept = e.NumDep
group by 
    rollup(d.NomD);

-- Exercice 4
-- 1- Créer la table : stock(piece, region, quantite);

create table stock (piece varchar(50), region varchar(50), quantite int);

-- 2- Insérera les données suivantes dans stock
insert into stock values ('ecrous', 'est', 50);
insert into stock values ('ecrous', 'ouest', 0);
insert into stock values ('ecrous', 'sud', 40);
insert into stock values ('clous', 'est', 70);
insert into stock values ('clous', 'nord', 0);
insert into stock values ('vis', 'ouest', 50);
insert into stock values ('vis', 'sud', 50);
insert into stock values ('vis', 'nord', 60);

-- 3-Donner la requête en sql qui permet de faire un regroupement des sommes des qt par pièce. 
select piece, sum(quantite) from stock group by piece;

-- 4-Donner la requête en sql qui permet de faire un regroupement des sommes des qt par région.
select region, sum(quantite) from stock group by region;

-- 5- Donner la requête en sql qui permet l’affichage des sommes des quantités pour les pièces et pour les régions (chacun à part) .
select piece, null as region, sum(quantite) as total_quantite from stock group by piece union all select null as piece, region, sum(quantite) as total_quantite from stock group by region;

-- 6- Même chose que question 5 : utiliser GROUPING SETS .
select piece, region, sum(quantite) as total_quantite from stock group by grouping sets ((piece), (region));

-- 7- Donner la requête en sql qui permet l’affichage des sommes des quantités pour les pièces et pour les régions (chacun à part) et au même temps affiche la somme de chaque type d article.
select piece, region, sum(quantite) as total_quantite from stock group by grouping sets ((piece), (region), ());

-- 8- Donner requête qui permet de :
---Calculer les totaux dans la même requête et sur toutes les clauses de regroupement
-- a-Utiliser cube
select piece, region, sum(quantite) as total_quantite from stock group by cube(piece, region);

-- b-Utiliser grouping sets
select piece, region, sum(quantite) as total_quantite from stock group by grouping sets ((piece, region), (piece), (region), ());

-- Exercice 5
-- 1-creer la table :
CREATE TABLE inventory (
warehouse VARCHAR(255),
product VARCHAR(255) NOT NULL,
model VARCHAR(50) NOT NULL,
quantity INT,
PRIMARY KEY (warehouse,product,model)
);

-- 2- inserer data dans inventory table:
insert into inventory values('san jose', 'iphone', '6s', 100);
insert into inventory values('san fransisco', 'iphone', '6s', 50);
insert into inventory values('san jose', 'iphone', '7', 50);
insert into inventory values('san fransisco', 'iphone', '7', 10);
insert into inventory values('san jose', 'iphone', 'x', 150);
insert into inventory values('san fransisco', 'iphone', 'x', 200);
insert into inventory values('san jose', 'samsung', 'galaxy s', 200);
insert into inventory values('san fransisco', 'samsung', 'note 8', 100);
insert into inventory values('san jose', 'samsung', 'note 8', 150);

-- 3-Affiche la somme totale des qt de l'inventaire par entrepôt et par produit
select warehouse, product, sum(quantity) from inventory group by warehouse, product;

-- 4- La somme totale des qt par entrepot.
select warehouse, sum(quantity) from inventory group by warehouse;

-- 5-retourne tous les ensembles de regroupement à l'aide d'une seule requête, exemple d’affichage :
-- a- utiliser union all
select warehouse, product, sum(quantity) from inventory group by warehouse, product union select warehouse, null as product, sum(quantity) from inventory group by warehouse union select null as warehouse, product, sum(quantity) from inventory group by product;

-- b- Utiliser GROUPINGSETS
select warehouse, product, sum(quantity) as qty from inventory group by grouping sets ((warehouse, product), (warehouse), (product), ()) order by warehouse nulls last, product nulls last;

-- 6- Recuperer le total ds produits dans tous les entrepots
select warehouse, sum(quantity) from inventory group by rollup(warehouse);

-- 7-Même question que 6) mais donner un titre à somme qt (utiliser COALESCE)
select coalesce(warehouse, 'All warehouses') as warehouse, sum(quantity) as qty from inventory group by rollup(warehouse);

-- 8- Rollup avec multiple columns
-- Calculer l'inventaire par warehouse et par produit
select coalesce(warehouse, 'Total') as warehouse, coalesce(product, 'Total') as product, sum(quantity) as qty from inventory group by rollup(warehouse, product);

-- 9- Meme chose que le 8 mais le total general
select coalesce(warehouse, 'Total') as warehouse, coalesce(product, 'Total') as product, sum(quantity) as qty from inventory group by rollup(warehouse, product);

-- 10-Donner la Somme des qt par warhouse, utiliser group by seul, exemple d’affichage:
select warehouse, sum(quantity) from inventory group by warehouse;

-- 11- meme question que 8, en rajoutant la somme totale, exemple d’affichage:
select coalesce(warehouse, 'Total') as warehouse, sum(quantity) as qty from inventory group by rollup(warehouse);

-- 12- Donner la Somme des qt : plusieurs colonnes avec group by et avec un ordre de trie
select warehouse, product, sum(quantity) as qty from inventory group by rollup(warehouse, product);

select warehouse, coalesce(product, 'All Product') as product, sum(quantity) as qty from inventory group by rollup(warehouse, product);
