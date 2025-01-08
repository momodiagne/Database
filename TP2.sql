show databases;
create database TP2;
use TP2;
source C:\Users\Momo\Downloads\BD1.sql

-- 1- Le nom et la profession de l’employé numéro 7782
select ename, job from emp where empno = 7782;

-- 2- Calculer la moyenne des salaires des employés
select avg(sal) from emp;

-- 3- Liste des noms des employés, date d’embauche, salaire et le nom du département d’appartenance
select ename, embauche, sal, dname from emp, dept where emp.deptno = dept.deptno;

-- 4- Afficher salaire et nom des employés classé par nom de département et par salaire
select sal, ename, dname from emp, dept where emp.deptno = dept.deptno order by dname asc, sal desc;

-- 5- Nom des employés qui ont un salaire supérieur à 3000
select ename from emp where sal>3000;

-- 6- Nom des employés qui ont un salaire compris entre 2000 et 6000
select ename from emp where sal>2000 and sal<6000;

-- 7- Le nom des employés qui ont une commission
select ename from emp where comm is not null;

-- 8- Le nom des employés qui n’ont pas de commission
select ename from emp where comm is null;

-- 9- Afficher le nom et date d’embauche de tous les employés dont la deuxième lettre du nom est un ‘L’
select ename, embauche from emp where ename like '_L%';

-- 10- Liste des employés du département vente ayant un salaire supérieur à 2000
select ename from emp, dept where emp.deptno = dept.deptno and dname = 'vente' and sal >2000;

-- 11- Liste des employés qui n’appartiennent pas au département RECHERCHE
select ename from emp, dept where emp.deptno = dept.deptno and dname != 'recherche';

-- 12- Liste des employés dont le département de travail est 20, 10 ou 30.
select ename from emp where deptno = 20 or deptno = 10 or deptno = 30;

-- 13- Ecrire la requête permettant de renvoyer le total des salaires du département 30
select sal from emp where deptno = 30;

-- 14- Ecrire la requête permettant de renvoyer le salaire max
select max(sal) from emp;

-- 15- Le salarié qui a le salaire le plus élevé
select ename from emp where sal = (select max(sal) from emp);

-- 16- Calculer la somme des salaires pour chaque département
select sum(sal), dname from emp, dept where emp.deptno = dept.deptno group by dname;

-- 17- Calculer la somme des salaires pour chaque département et pour chaque job classé par département
select sum(sal), job from emp, dept where emp.deptno = dept.deptno group by dept.dname, emp.job order by dept.dname asc;

-- 18- La moyenne des salaires pour chaque job ayant plus de deux employés
select avg(sal), job from emp group by job having count(*) >=2;

-- 19- Le nombre d’employés par département et par job
select dname, job, count(*) from emp, dept where emp.deptno = dept.deptno group by dept.dname, emp.job order by dname asc, job asc;

-- 20- Le nombre de manager pour chaque département 
select job, count(*) from emp, dept where emp.deptno = dept.deptno and job = 'manager';

-- 21- La date d’embauche la plus récente par département
select ename from emp where embauche = (select max(embauche) from emp);