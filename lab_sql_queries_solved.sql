-- Write SQL queries to perform the following tasks using the Sakila database:
-- 1.Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
use sakila;

select count(film_id) from inventory
where film_id in (
select film_id from film
where title = "Hunchback Impossible");


-- 2.List all films whose length is longer than the average length of all the films in the Sakila database.

select title as "film title with length greater than average length" , length from film
where length > (
select avg(length)
from film) ;

-- 3. Use a subquery to display all actors who appear in the film "Alone Trip".

select concat(first_name, ' ' , last_name) as "Name of Actor" from actor
where actor_id in(
select a.actor_id  
from film as f
join film_actor as a
on f.film_id = a.film_id
where title = "Alone Trip");

-- 4.Sales have been lagging among young families, and you want to target family movies for a promotion. Identify all movies categorized as family films.

select title as "Name of Family movies"from film 
where film_id in 
(select film_id 
from film_category where category_id in 
(select category_id from category
where name= "family"));

-- 5.Retrieve the name and email of customers from Canada using both subqueries and joins. To use joins, you will need to identify the relevant tables and 
-- their primary and foreign keys.
select  concat(first_name," " ,last_name) as "Customer Name" , email as "Email ID " from customer 
where address_id in ( 
select address_id from address 
where city_id in
(select city_id
from city where country_id
 in
(select country_id from country
where country = "Canada")));

-- 6.Determine which films were starred by the most prolific actor in the Sakila database. A prolific actor is defined as the actor who has acted in the most 
-- number of films. First, you will need to find the most prolific actor
 -- and then use that actor_id to find the different films that he or she starred in.

select title as "films starred by the most prolific actor" from film 
 where film_id in
 (
select film_id from film_actor 
where actor_id =
(
select actor_id as "num_films" from film_actor
group by actor_id
order by count(*) desc
limit 1
)
);


-- 7.Find the films rented by the most profitable customer in the Sakila database. You can use the customer and payment tables to 
-- find the most profitable customer, i.e., the customer who has made the largest sum of payments.


select title as "rented by the most profitable customer" from film
where film_id 
in (
select film_id from inventory where 
inventory_id in(
select inventory_id from rental
where customer_id = (
select customer_id from payment
group by customer_id
order by sum(amount) desc
limit 1 )
)
);

-- 8.Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. You can use subqueries to accomplish this.

select customer_id,sum(amount) as "total amount spend"
from payment 
group by customer_id
having sum(amount) > ( select avg(total_amount) from
( select  customer_id , sum(amount) as "total_amount"
from payment 
group by customer_id) as sub
);









