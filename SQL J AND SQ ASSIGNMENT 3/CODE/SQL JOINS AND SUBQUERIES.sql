use mavenmovies;

 -- 1. write a query to display the customer's first name, last name, email, and city they live in.

-- solution 1
select c.first_name, c.last_name, c.email, a.district from customer c join address a on c.address_id = a.address_id;

-- 2. Retrieve the film title, description, and release year for the film that has the longest duration.
-- solution 2
select title, description, release_year from film where length= (select max(length) from film );

-- 3 List the customer name, rental date, and film title for each rental made. Include customers who have never rented a film.
-- solution 3
select c.first_name, c.last_name, r.rental_date, f.title from customer c left join rental r on c.customer_id = r.customer_id left join inventory i on r.inventory_id = i.inventory_id left join film f on i.film_id = f.film_id;

-- 4. Find the number of actors for each film. Display the film title and the number of actors for each film.
-- solution 4
select f.title , count(actor_id) as actor_count from film f left join film_actor fa on f.film_id=fa.film_id group by f.title;

-- 5 Display the first name, last name, and email of customers along with the rental date, film title, and rental return date.
-- solution 5
select c.first_name, c.last_name, c.email, r.rental_date, f.title , r.return_date from customer c join rental r on c.customer_id=r.customer_id join inventory i on r.inventory_id=i.inventory_id join film f on i.film_id=f.film_id;

-- 6 Retrieve the film titles that are rented by customers whose email domain ends with '.net'.
-- solution 6
SELECT title
FROM film
WHERE film_id IN (
SELECT film_id
FROM inventory
WHERE store_id IN (
SELECT store_id
FROM customer
WHERE email LIKE '%.net'
)
);

-- 7 Show the total number of rentals made by each customer, along with their first and last names.
-- solution 7
select c.first_name, c.last_name , sum(rental_id) as total_rental from customer c left join rental r on c.customer_id=r.customer_id group by c.customer_id order by total_rental desc;

-- 8 List the customers who have made more rentals than the average number of rentals made by all customers.
-- solution 8
SELECT first_name, last_name
FROM customer
WHERE customer_id IN (
SELECT customer_id
FROM rental
GROUP BY customer_id
HAVING COUNT(rental_id) > (
SELECT AVG(rental_count)
FROM (
SELECT COUNT(rental_id) AS rental_count
FROM rental
GROUP BY customer_id
) AS avg_rentals
)
);

-- 9. Display the customer first name, last name, and email along with the names of other customers living in the same city.
-- solution 9
SELECT c1.first_name, c1.last_name, c1.email, c2.first_name AS other_first_name,
c2.last_name AS other_last_name
FROM customer c1
JOIN address a1 ON c1.address_id = a1.address_id
JOIN address a2 ON a1.district = a2.district AND a1.address_id != a2.address_id
JOIN customer c2 ON a2.address_id = c2.address_id;

-- 10. Retrieve the film titles with a rental rate higher than the average rental rate of films in the same category.
-- solution 10
SELECT title, rental_rate
FROM film f
WHERE rental_rate > (
SELECT AVG(rental_rate)
FROM film

);

-- 11 Retrieve the film titles along with their descriptions and lengths that have a rental rate greater than the average rental rate of films released in the same year.
-- solution 11
SELECT title, description, length
FROM film
WHERE rental_rate > (
SELECT AVG(rental_rate)
FROM film
WHERE release_year = film.release_year
);

-- 12. List the first name, last name, and email of customers who have rented at least one film in the 'Documentary' category.
-- solution 12
SELECT first_name, last_name, email
FROM customer
WHERE customer_id IN (
SELECT DISTINCT c.customer_id
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film_category fc ON i.film_id = fc.film_id
JOIN category cat ON fc.category_id = cat.category_id
WHERE cat.name = 'Documentary'
);

-- 13 Show the title, rental rate, and difference from the average rental rate for each film.
-- solution 13
SELECT title, rental_rate,
rental_rate - (SELECT AVG(rental_rate) FROM film) AS rate_difference
FROM film;

-- 14 . Retrieve the titles of films that have never been rented.
-- solution 14
select title from film where film_id not in (select distinct film_id from inventory where film_id is not null);

-- 15 List the titles of films whose rental rate is higher than the average rental rate of films released in the same year and belong to the 'Sci-Fi' category.
-- solution 15
SELECT title
FROM film f
WHERE rental_rate > (
SELECT AVG(rental_rate)
FROM film
WHERE release_year = f.release_year
)
AND film_id IN (
SELECT fc.film_id
FROM film_category fc
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Sci-Fi'
);

-- 16. Find the number of films rented by each customer, excluding customers who have rented fewer than five films.
-- solution 16

SELECT customer_id, COUNT(rental_id) AS film_count
FROM rental
GROUP BY customer_id
HAVING COUNT(rental_id) >= 5;
