-- 1. Fetch all the paintings which are not displayed on any museums?
select w.name, a.full_name from work w
join artist a on w.artist_id=a.artist_id
where w.museum_id is null;

-- 2. Are there museums without any paintings?
select * from museum 
where museum_id not in 
( select museum_id from work
);

-- 3. How many paintings have an asking price of more than their regular price?
select * from product_size 
where sale_price>regular_price

-- 4. Identify the paintings whose asking price is less than 50% of its regular price
select * from product_size 
where sale_price< (regular_price)/2;

-- 5. Which canva size costs the most?
select cs.label as canva, ps.sale_price from canvas_size cs 
join product_size ps on cs.size_id::text=ps.size_id
order by sale_price desc 
limit 1;

-- 6. Delete duplicate records from work, product_size, subject and image_link tables
delete from work 
where ctid not in (
select min(ctid) from work
group by work_id
);

delete from product_size
where ctid not in (
select min(ctid) from product_size
group by work_id, size_id
);

delete from subject
where ctid not in (
select min(ctid) from subject
group by work_id, subject
);

delete from image_link
where ctid not in (
select min(ctid) from image_link
group by work_id
);

-- 7. Identify the museums with invalid city information in the given dataset
select museum,city from museum 
where city ~ '^[0-9]';

-- 8. Museum_Hours table has 1 invalid entry. Identify it and remove it.
delete from museum_hours 
where ctid not in (
select min(ctid) from museum_hours 
group by museum_id, day
);

--9. Fetch the top 10 most famous painting subject
select s.subject, count(1) as num 
from work w join subject s on w.work_id=s.work_id 
group by s.subject 
order by count(1) desc 
limit 10;

--10. Identify the museums which are open on both Sunday and Monday. Display museum name, city.
select m.name,m.city from museum_hours mh1
join museum m on m.museum_id=mh1.museum_id
where mh1.day='Sunday' 
and exists (select * from museum_hours mh2
		   where mh1.museum_id=mh2.museum_id
           and mh2.day='Monday'
           );

-- 11. How many museums are open every single day?
update museum_hours
set day = replace(day, 'Thusday', 'Thursday')
where day like '%Thusday%' ;

select count(1) as num_museums from (
select m.name from museum_hours mh
join museum m on mh.museum_id=m.museum_id 
group by m.name
having count(distinct day)=7);

-- 12. Which are the top 5 most popular museum? (Popularity is defined based on most no of paintings in a museum)
select m.name, m.city, m.country, count(w.work_id) as no_of_paintings from museum m 
join work w on m.museum_id=w.museum_id 
group by m.name, m.city, m.country
order by count(work_id) desc 
limit 5;

-- 13.  Who are the top 5 most popular artist? (Popularity is defined based on most no of paintings done by an artist)
select a.full_name as artist, count(w.work_id) as painting_count from work w
join artist a on w.artist_id=a.artist_id
group by a.full_name 
order by count(w.work_id) desc 
limit 5;

-- 14. Display the 3 least popular canva sizes
select * from(
select cs.label,cs.size_id,count(ps.size_id) as no_of_paintings,
dense_rank() over(order by count(ps.size_id)) as ranking
from canvas_size cs 
join product_size ps on cs.size_id::text=ps.size_id 
group by cs.size_id, cs.label
)
where ranking<=3;

-- 15. Which museum is open for the longest during a day. Dispay museum name, state and hours open and which day?
with duration_details as (
select m.name,m.state,mh.day,
to_timestamp(open,'HH:MI AM') as open_time,
to_timestamp(close,'HH:MI PM') as close_date,
to_timestamp(close,'HH:MI PM')-to_timestamp(open,'HH:MI AM') as duration,
rank() over(order by to_timestamp(close,'HH:MI PM')-to_timestamp(open,'HH:MI AM') desc) as rnk
from museum_hours mh 
join museum m on m.museum_id=mh.museum_id
)
select * from duration_details 
where rnk=1;

-- 16. Which museum has the most no of most popular painting style?
with popular_style as (
select style,
rank() over(order by count(1) desc) as ranking
from work 
group by style
),
cte_museum as (
select m.name, ps.style,count(1) as no_of_paintings,
rank() over(order by count(1) desc) as rnk 
from work w 
join popular_style ps on w.style=ps.style 
join museum m on w.museum_id=m.museum_id
group by m.name, ps.style
)
select * from cte_museum 
where rnk=1;

-- 17. Identify the artists whose paintings are displayed in multiple countries
select * from (
select a.full_name, count(distinct m.country) as num_country,
rank() over(order by count(distinct m.country) desc) as ranking
from work w 
join museum m on w.museum_id=m.museum_id 
join artist a on w.artist_id=a.artist_id
where w.museum_id is not null 
group by a.full_name
having count(distinct m.country)>1
)

-- 18. Display the country and the city with most no of museums. Output 2 seperate columns to mention the city and country. If there are multiple value, seperate them with comma.
with cte_country as
(select country, count(1),
rank() over(order by count(1) desc) as rnk 
from museum 
group by country),
cte_city as
(select city, count(1),
rank() over(order by count(1) desc) as rnk
from museum 
group by city)
select string_agg(distinct country,' , ') as country, string_agg(city,' , ') as city from cte_country 
cross join cte_city 
where cte_country.rnk=1 
and cte_city.rnk=1;

-- 19. Identify the artist and the museum where the most expensive and least expensive painting is placed. Display the artist name, sale_price, painting name, museum name, museum city and canvas label
with prices as (
select * ,
rank() over(order by sale_price desc) as max_price_rnk,
rank() over(order by sale_price asc) as min_price_rnk
from product_size
)
select a.full_name, prices.sale_price, w.name as painting_name,
m.name as museum_name, m.city as museum_city,
cs.label as canvas_label 
from prices 
join work w on prices.work_id=w.work_id
join artist a on w.artist_id=a.artist_id 
join museum m on m.museum_id=w.museum_id 
join canvas_size cs on cs.size_id=prices.size_id::NUMERIC
where max_price_rnk=1 
or min_price_rnk=1;

-- 20. Which country has the 5th highest no of paintings?
with details as (
select m.country, count(w.work_id) as no_of_painting,
rank() over(order by count(w.work_id) desc ) as rnk 
from museum m 
join work w on m.museum_id=w.museum_id
group by m.country
)
select country, no_of_painting from details 
where rnk=5;

-- 21. Which are the 3 most popular and 3 least popular painting styles?
with details as (
select w.style, count(1) as num_of_paintings,
rank() over(order by count(1) desc) as mp_rnk, 
rank() over(order by count(1) asc) as lp_rnk
from work w
where w.style is not null
group by w.style
)
select style, num_of_paintings from details 
where mp_rnk in (1,2,3)
or lp_rnk in (1,2,3)
order by num_of_paintings desc;

-- 22. Which artist has the most no of Portraits paintings outside USA?. Display artist name, no of paintings and the artist nationality.
with details as (
select a.full_name as artist_name, count(w.work_id) as num,
a.nationality,
rank() over(order by count(w.work_id) desc) as rnk 
from work w 
join subject s on w.work_id=s.work_id 
join museum m on m.museum_id=w.museum_id
join artist a on a.artist_id=w.artist_id
where m.country != 'USA' and 
s.subject='Portraits'
group by a.full_name, a.nationality
) 
select artist_name, num, nationality from details 
where rnk=1;	