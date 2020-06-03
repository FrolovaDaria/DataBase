---------Для заданного города выведите ближайшие открытия магазинов.
select sh.*
from shop sh
where sh.city='Москва' and sh.opening_date>now()
order by sh.opening_date
limit 10


---------Для заданного магазина вывести расписание работы его сотрудников на завтрашний день.
select ssh.employee_id, ssh.begin_workday, ssh.end_workday
from schedule_shop ssh
where shop_id = 13 and ssh.begin_workday::timestamp::date=now()::timestamp::date + integer '1'


---------Выведите клиентов, которые в любых магазинах компании за последние 14 дней потратили более 10000 рублей на покупки.
with tik as
(  select b.client_id, sum(pr.price)
   from buy b, price pr
   where b.product_id=pr.product_id and b.date_buy>(now()::timestamp::date-integer '14')
   group by b.client_id
)

select cl.*
from client cl, tik
where cl.id=tik.client_id and sum>10000


---------Выведите 10% ??(можете увеличить процент) клиентов, которые потратили за последние 240 часов наибольшую сумму.
with tik as
(  select b.client_id, sum(pr.price)
   from buy b, price pr
   where b.product_id=pr.product_id and b.date_buy>(now()::timestamp::date-integer '10')
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
   where b.product_id=pr.product_id and b.date_buy>(now()::timestamp::date-integer '10')
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
with firstweek as
(select b.product_id, count(b.product_id) as first_week
from buy b, product pr
where b.product_id=pr.id and b.date_buy>(now()::timestamp::date-integer '7')
group by b.product_id),
secondweek as
(select b.product_id, count(b.product_id) as second_week
from buy b, product pr
where b.product_id=pr.id and b.date_buy>(now()::timestamp::date-integer '14') and b.date_buy<(now()::timestamp::date-integer '7')
group by b.product_id),
thirdweek as
(select b.product_id, count(b.product_id) as third_week
from buy b, product pr
where b.product_id=pr.id and b.date_buy>(now()::timestamp::date-integer '21') and b.date_buy<(now()::timestamp::date-integer '14')
group by b.product_id),
fourthweek as
(select b.product_id, count(b.product_id) as fourth_week
from buy b, product pr
where b.product_id=pr.id and b.date_buy>(now()::timestamp::date-integer '28') and b.date_buy<(now()::timestamp::date-integer '21')
group by b.product_id)

select pr.id, pr.name, fw.first_week, sw.second_week, tw.third_week, fow.fourth_week
from product pr full outer join firstweek fw on pr.id=fw.product_id
full outer join secondweek sw on pr.id=sw.product_id
full outer join thirdweek tw on pr.id=tw.product_id
full outer join fourthweek fow on pr.id=fow.product_id
 

---------Cравните количество единиц товара на складе с полученными в результате предыдущего запроса данными. Вывести нужно те товары и их количество, которого не хватит на неделю исходя из статистики 4-х прошедших недель.
with uuu as
( with firstweek as
(select b.product_id, count(b.product_id) as first_week
from buy b, product pr
where b.product_id=pr.id and b.date_buy>(now()::timestamp::date-integer '7')
group by b.product_id),
secondweek as
(select b.product_id, count(b.product_id) as second_week
from buy b, product pr
where b.product_id=pr.id and b.date_buy>(now()::timestamp::date-integer '14') and b.date_buy<(now()::timestamp::date-integer '7')
group by b.product_id),
thirdweek as
(select b.product_id, count(b.product_id) as third_week
from buy b, product pr
where b.product_id=pr.id and b.date_buy>(now()::timestamp::date-integer '21') and b.date_buy<(now()::timestamp::date-integer '14')
group by b.product_id),
fourthweek as
(select b.product_id, count(b.product_id) as fourth_week
from buy b, product pr
where b.product_id=pr.id and b.date_buy>(now()::timestamp::date-integer '28') and b.date_buy<(now()::timestamp::date-integer '21')
group by b.product_id)

select pr.id, pr.name, fw.first_week, sw.second_week, tw.third_week, fow.fourth_week
from product pr full outer join firstweek fw on pr.id=fw.product_id
full outer join secondweek sw on pr.id=sw.product_id
full outer join thirdweek tw on pr.id=tw.product_id
full outer join fourthweek fow on pr.id=fow.product_id)

select u.name, qp.quantity_in_shop
from quantity_product qp inner join uuu as u on qp.product_id=u.id
where qp.quantity_in_shop<u.first_week or qp.quantity_in_shop<u.second_week or qp.quantity_in_shop<u.third_week  or qp.quantity_in_shop<u.fourth_week 


---------Для заданного сотрудника выведите его месячный график работы
select sd.begin_workday, sd.end_workday
from schedule_department_unit sd inner join schedule_shop ss on sd.employee_id=ss.employee_id
where sd.employee_id='13' and extract(month from sd.begin_workday)=11


---------Клиент может отказаться от карты лояльности, в таком случае, согласно GDPR хранить его данные нельзя. Объясните, как правильно организовать такое удаление, напишите запрос(ы).
delete from client
where phone_number='';

update buy 
set client_id = null;
	

---------Для заданного поставщика выведите в заданном магазине сотрудника, который принимал их товар наибольшее количество раз.
select sh.supplier_id, count(sh.employee_id)
from shipment sh
where supplier_id=3
group by sh.employee_id, sh.supplier_id
order by count 
limit 1


---------Посчитайте для каждого магазина доходы и расходы на последнюю неделю. Подумайте, какая очевидная проблема есть в расчёте и как можно её устранить.
---------Зарплата и прочие расходы,которые не учитываются в таблице?
with doh as
(select b.shop_id, sum(pr.price) as ds
from buy b, price pr
where b.product_id=pr.product_id and b.date_buy>(now()::timestamp::date-integer '7')
group by b.shop_id),
ras as 
(select sh.shop_id, sum(sh.price*sh.quantity) as rs
from shipment sh
where sh.date>(now()::timestamp::date-integer '7')
group by sh.shop_id)

select d.shop_id, d.ds, r.rs
from doh d inner join ras r on d.shop_id=r.shop_id


---------Появилась задача хранить зарплаты сотрудников. Подумайте, как можно это хранить и напишите запрос для изменения базы данных. Бухгалтерия сообщила, что самая распространённая з/п - 30000, поэтому попросили заполнить всё в начале этим значением. Напишите Update, который поставит всем з/п - 30000. Ещё з/п не может быть null, поэтому сделайте ALTER на добавление NOT NULL.
alter table employee
add salary DECIMAL(8,2) not null default 30000;