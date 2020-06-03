---------Для заданного города выведите ближайшие открытия магазинов.
select sh.*
from shop sh
where sh.city='Москва' and sh.opening_date>now() and (extract(year from age(now(), sh.opening_date))*12+extract(month from age(now(), sh.opening_date)))<= 2


---------Для заданного магазина вывести расписание работы его сотрудников на завтрашний день.
select ssh.*
from schedule_shop ssh
where shop_id = 13


---------Выведите клиентов, которые в любых магазинах компании за последние 14 дней потратили более 10000 рублей на покупки.
with tik as
(  select b.client_id, sum(pr.price)
   from buy b, price pr
   where b.product_id=pr.product_id and (extract(year from age(now(), b.date_buy))+extract(month from age(now(), b.date_buy))*12+extract(day from age(now(), b.date_buy)))<=14
   group by b.client_id
)

select cl.*
from client cl, tik
where cl.id=tik.client_id and sum>10000


---------Выведите 10% ??(можете увеличить процент) клиентов, которые потратили за последние 240 часов наибольшую сумму.

with tik as
(  select b.client_id, sum(pr.price)
   from buy b, price pr
   where b.product_id=pr.product_id and (extract(year from age(now(), b.date_buy))+extract(month from age(now(), b.date_buy))*12+extract(day from age(now(), b.date_buy)))<=10
   group by b.client_id
)

select cl.*
from client cl, tik
where cl.id=tik.client_id
order by sum
limit 5


---------На основе предыдущего запроса (сделайте его WITH) посчитайте среднюю сумму, потраченную этими клиентами.

with xaz as
(
	with tik as
(  select b.client_id, sum(pr.price)
   from buy b, price pr
   where b.product_id=pr.product_id and (extract(year from age(now(), b.date_buy))+extract(month from age(now(), b.date_buy))*12+extract(day from age(now(), b.date_buy)))<=10
   group by b.client_id
)

select cl.*
from client cl, tik
where cl.id=tik.client_id
order by sum
limit 5 )

select avg(id)
from xaz


---------За последние 4 недели выведите проданное количество единиц товара (Названия атрибутов: ID, Название товара, 1, 2, 3, 4 недели).
select z1.*, z2.*, z3.*, z4.*
from (select b.product_id, pr.name, count(b.product_id) as first_week
	from buy b, product pr
	where b.product_id=pr.id and (extract(year from age(now(), b.date_buy))+extract(month from age(now(), b.date_buy))*12+extract(day from age(now(), b.date_buy)))<=7
 	group by b.product_id, pr.name) as z1, 
	(select b.product_id, pr.name, count(b.product_id) as second_week
	from buy b, product pr
 	where b.product_id=pr.id and (extract(year from age(now(), b.date_buy))+extract(month from age(now(), b.date_buy))*12+extract(day from age(now(), b.date_buy)))>=7 and (extract(year from age(now(), b.date_buy))+extract(month from age(now(), b.date_buy))*12+extract(day from age(now(), b.date_buy)))<=14
 	group by b.product_id, pr.name) as z2, 
	(select b.product_id, pr.name, count(b.product_id) as third_week
	from buy b, product pr
 	where b.product_id=pr.id and (extract(year from age(now(), b.date_buy))+extract(month from age(now(), b.date_buy))*12+extract(day from age(now(), b.date_buy)))>=14 and (extract(year from age(now(), b.date_buy))+extract(month from age(now(), b.date_buy))*12+extract(day from age(now(), b.date_buy)))<=21
 	group by b.product_id, pr.name) as z3,
	(select b.product_id, pr.name, count(b.product_id) as fourth_week
	from buy b, product pr
 	where b.product_id=pr.id and (extract(year from age(now(), b.date_buy))+extract(month from age(now(), b.date_buy))*12+extract(day from age(now(), b.date_buy)))>=21 and (extract(year from age(now(), b.date_buy))+extract(month from age(now(), b.date_buy))*12+extract(day from age(now(), b.date_buy)))<=28
 	group by b.product_id, pr.name) as z4


---------Cравните количество единиц товара на складе с полученными в результате предыдущего запроса данными. Вывести нужно те товары и их количество, которого не хватит на неделю исходя из статистики 4-х прошедших недель.


---------Для заданного сотрудника выведите его месячный график работы
select sd.begin_workday, sd.end_workday
from schedule_department_unit sd inner join schedule_shop ss on sd.employee_id=ss.employee_id
where sd.employee_id='13'


---------По центру-текущая цена, слева цена на прошлой и позапрошлой неделе, справа следующая и после след. неделя. Если в течение данной недели нету или не было указанной цены (изменения), то указать "нет инф."


---------Для каждого клиента найдите самый частый день недели и время его посещения магазина


---------Клиент может отказаться от карты лояльности, в таком случае, согласно GDPR хранить его данные нельзя. Объясните, как правильно организовать такое удаление, напишите запрос(ы).


---------Для заданного поставщика выведите в заданном магазине сотрудника, который принимал их товар наибольшее количество раз.


---------Посчитайте относительную (напр.: 25%) и абсолютную (напр.: 35 р.) наценку на каждый товар в момент последней поставки.


---------Посчитайте для каждого магазина доходы и расходы на последнюю неделю. Подумайте, какая очевидная проблема есть в расчёте и как можно её устранить.


---------Появилась задача хранить зарплаты сотрудников. Подумайте, как можно это хранить и напишите запрос для изменения базы данных. Бухгалтерия сообщила, что самая распространённая з/п - 30000, поэтому попросили заполнить всё в начале этим значением. Напишите Update, который поставит всем з/п - 30000. Ещё з/п не может быть null, поэтому сделайте ALTER на добавление NOT NULL.
