--########1########
--#1
select st.name, st.surname, st.score
from students st
where st.score<=4.5 and st.score>=4

select st.name, st.surname, st.score
from students st
where st.score between 4.0 and 4.5

--#2
select st.name, st.surname
from students st
where cast (st.n_group as text) like '2%'

--#3
select st.name, st.surname, st.n_group
from students st
order by st.n_group desc,st.surname

--#4
select st.name, st.surname, st.score
from students st
where st.score>4
order by st.score desc

--#5
select hb.name, hb.risk
from hobbies hb
where hb.name in('Хоккей','Футбол')

--#6
select sh.student_id, sh.hobby_id
from students_hobbies sh
where (sh.date_start between '2018-02-01' and '2018-05-01') and (sh.date_finish is null)

--#7
select st.name, st.surname, st.score
from students st
where st.score>4.5
order by st.score desc

--#8
select st.name, st.surname, st.score
from students st
where st.score>4.5
order by st.score desc
fetch first 5 rows only

select st.name, st.surname, st.score
from students st
where st.score>4.5
order by st.score desc
limit 5

--#9
select hb.name, hb.risk,
case
when hb.risk>=8 then 'очень высокий'
when hb.risk>=6 and hb.risk<8 then 'высокий'
when hb.risk>=4 and hb.risk<6 then 'средний'
when hb.risk>=2 and hb.risk<4 then 'низкий'
when hb.risk<2 then 'очень низкий'
END
from hobbies hb

--#10
select hb.name, hb.risk
from hobbies hb
order by hb.risk desc
limit 3

--########2########
--#1
select st.n_group, count(st.id)
from students st
group by st.n_group

--#2
select st.n_group, max(st.score)
from students st
group by st.n_group

--#3
select st.name, count(st.id)
from students st
group by st.name

--#4
select st.birth_date, count(st.id)
from students st
group by st.birth_date

--#5
select st.n_group, avg(st.score)
from students st
group by st.n_group

--#6
select st.n_group, max(st.score)
from students st
group by st.n_group
limit 1

--#7
select st.n_group, avg(st.score)
from students st
group by st.n_group
having avg(st.score)<=4.5
order by avg

--#8
select st.n_group, count(st.id), max(st.score), min(st.score), avg(st.score)
from students st
group by st.n_group

--#9
with t as
(  select st.n_group, max(st.score) as m
   from students st
   group by st.n_group)

select st.*
from students st
inner join (  select st.n_group, max(st.score) as m
   from students st
   group by st.n_group) t on st.n_group=t.n_group and st.score=t.m
where st.n_group = 3071

--#10
with t as
(  select st.n_group, max(st.score) as m
   from students st
   group by st.n_group)

select st.*
from students st
inner join (  select st.n_group, max(st.score) as m
   from students st
   group by st.n_group) t on st.n_group=t.n_group and st.score=t.m