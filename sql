-- 1. +Вибрати усіх клієнтів, чиє ім'я має менше ніж 6 символів.
use bank;

select *
from client
where length(firstname)<6;

-- 2. +Вибрати львівські відділення банку.+
select * 
from department
where departmentCity = 'Lviv';

-- 3. +Вибрати клієнтів з вищою освітою та посортувати по прізвищу.
select *
from client
where Education = 'high'
order by lastname;

-- 4. +Виконати сортування у зворотньому порядку над таблицею Заявка і вивести 5 останніх елементів.
select *
from application
order by idapplication desc
limit 5;




-- 5. +Вивести усіх клієнтів, чиє прізвище закінчується на OV чи OVA.
select *
from client
where lastname like '%ov' or lastname like '%ova';

-- 6. +Вивести клієнтів банку, які обслуговуються київськими відділеннями.
select t1.*
from client t1 inner join department t2 
	on t1.Department_idDepartment = t2.idDepartment
where t2.DepartmentCity = 'Kyiv';

-- 7. +Вивести імена клієнтів та їхні номера телефону, погрупувавши їх за іменами.
select FirstName,passport
from client
group by FirstName,passport;

-- 8. +Вивести дані про клієнтів, які мають кредит більше ніж на 5000 тисяч гривень.
select t2.idclient,t2.firstname,t2.lastname,sum(t1.sum) as sum_cred
from application t1 inner join client t2
	on t1.Client_idClient = t2.idClient
where t1.sum>5000 and t1.currency = 'Gryvnia'
group by t2.idclient,t2.firstname,t2.lastname;


-- 9. +Порахувати кількість клієнтів усіх відділень та лише львівських відділень.
select count(*)
from department;

select count(*)
from department
where DepartmentCity = 'Lviv';

-- 10. Знайти кредити, які мають найбільшу суму для кожного клієнта окремо.
select Client_idClient,max(Sum)
from application
group by Client_idClient;

-- 11. Визначити кількість заявок на крдеит для кожного клієнта.
select Client_idClient,max(count)
from application
group by Client_idClient;

-- 12. Визначити найбільший та найменший кредити.
select min(sum),max(sum)
from application;


-- 13. Порахувати кількість кредитів для клієнтів,які мають вищу освіту.
select t1.Client_idClient ,count(*)
from application t1 inner join client t2 
	on t2.Education = 'high'
group by t1.Client_idClient;

-- 14. Вивести дані про клієнта, в якого середня сума кредитів найвища.
create TEMPORARY table avg_sum
select Client_idClient,avg(sum) avg_sum
from application
group by Client_idClient;

select max(avg_sum)
into @avg_sum
from avg_sum;

select t1.Client_idClient,t2.FirstName,t2.LastName,t1.avg_sum
from avg_sum t1 inner join client t2
	on t1.Client_idClient = t2.idClient
where avg_sum = @avg_sum;

-- 15. Вивести відділення, яке видало в кредити найбільше грошей
create temporary table sum_department
select t3.idDepartment, sum(t1.Sum) sum_cred
from application t1 inner join client t2
	on t1.Client_idClient = t2.idClient
	inner join department t3
    on t2.Department_idDepartment = t3.idDepartment
group by t3.idDepartment;

select max(sum_cred)
into @max_sum_cred
from sum_department;

select idDepartment,sum_cred
from sum_department
where sum_cred = @max_sum_cred;

-- 16. Вивести відділення, яке видало найбільший кредит.
select max(sum)
into @max_credit_sum
from application;

select t2.Department_idDepartment ,t1.sum
from application t1 inner join client t2
	on t1.Client_idClient = t2.idClient
where t1.sum = @max_credit_sum;


-- 17. Усім клієнтам, які мають вищу освіту, встановити усі їхні кредити у розмірі 6000 грн.

update application
set Sum = 6000
where Client_idClient in 
	(select idClient from client where Education = 'high');

-- 18. Усіх клієнтів київських відділень пересилити до Києва.
update client
set City = 'Kyiv'
where Department_idDepartment in 
	(select idDepartment from department where DepartmentCity = 'Kyiv');

-- 19. Видалити усі кредити, які є повернені.
delete
from application
where CreditState = 'Returned';


-- 20. Видалити кредити клієнтів, в яких друга літера прізвища є голосною.
delete
from application
where Client_idClient in 
	(select idClient	from client	where substring(LastName,2,1) in ('a','o','i','y','e','u'));


-- Знайти львівські відділення, які видали кредитів на загальну суму більше ніж 5000




-- Знайти клієнтів, які повністю погасили кредити на суму більше ніж 5000





/* Знайти максимальний неповернений кредит.*/




/*Знайти клієнта, сума кредиту якого найменша*/




/*Знайти кредити, сума яких більша за середнє значення усіх кредитів*/



/*Знайти клієнтів, які є з того самого міста, що і клієнт, який взяв найбільшу кількість кредитів*/



#місто чувака який набрав найбільше кредитів



set sql_safe_updates = 0;
set sql_safe_updates = 1;
