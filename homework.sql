use sakila;
#1a. Displaying First & Last Name from Table Actor
	select first_name, last_name from actor;

#1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
    select upper(concat(first_name,' ', last_name)) Name from actor;

#2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
		select actor_id,first_name, last_name from actor
		where upper(first_name)= upper('Joe'); 

# 2b. Find all actors whose last name contain the letters GEN:
		select actor_id, first_name, last_name from actor
        where upper(last_name) like '%GEN%'

# 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
		select actor_id, first_name, last_name from actor
		where upper(last_name) like '%LI%'
		order by last_name, first_name

# 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
		select country_id, country from country where country in ('Afghanistan','Bangladesh','China')

#3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
		alter table actor add column description blob
		desc actor
#3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
		alter table actor drop column description
		desc actor
#4a. List the last names of actors, as well as how many actors have that last name.
		select last_name, count(actor_id) from actor
		group by last_name
		order by 2 desc

#4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
		select last_name, count(actor_id) from actor
		group by last_name
		having count(actor_id) > 1
		order by 2 desc

#4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
		update actor
		set first_name = 'HARPO'
		where first_name = 'GROUCHO'
		and last_name = 'WILLIAMS';
		commit;

#4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
		update actor
		set first_name = 'GROUCHO'
		where first_name = 'HARPO';
		commit;


#5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
#◦Hint: https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html 
		show create table address

#6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:

	select s.first_name, s.last_name, a.address, a.district from staff s, address a
	where s.address_id = a.address_id

#6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
	select concat(first_name, ' ',last_name) Name, sum(p.amount) as 'Total Amount' from staff s, payment p
	where date_format(payment_date,'%m-%Y')='05-2005'
	and p.staff_id = s.staff_id
	group by name
 
#6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
	select f.title, count(*)  from  film f
	inner join film_actor fa on  f.film_id = fa.film_id
	group by f.title

#6d. How many copies of the film Hunchback Impossible exist in the inventory system?
	select  f.title, count(inventory_id) copies from inventory i 
	inner join film f on f.film_id = i.film_id
	and upper(title) = 'Hunchback Impossible'

#6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
	select concat(c.last_name, ' ',c.first_name) as Name, sum(p.amount)  'Total Paid' from payment p
	inner join customer c on c.customer_id = p.customer_id
	group by Name
	order by Name

#7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
	select film_id, title from film where ((title like 'Q%') or (title like 'K%')) 
    and language_id in (select language_id from language where upper(name) = 'ENGLISH') 
    
#7b. Use subqueries to display all actors who appear in the film Alone Trip.
	select a.actor_id, first_name, last_name from actor a, film_actor fa where
	a.actor_id = fa.actor_id
	and fa.film_id in (select film_id from film where title = 'Alone Trip')
#7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.

SELECT cus.first_name, cus.last_name, cus.email  
	FROM customer cus 
	JOIN address a  
	ON (cus.address_id = a.address_id) 
	JOIN city cty 
	ON (cty.city_id = a.city_id) 
	JOIN country 
	ON (country.country_id = cty.country_id) 
	WHERE country.country= 'Canada'; 
 
 
# 7d. Sales have been lagging among young families, and you wish 
--       to target all family movies for a promotion. Identify all movies  
--       categorized as famiy films. 
 
	SELECT title, description FROM film  
	WHERE film_id IN 
	( 
		SELECT film_id FROM film_category 
		WHERE category_id IN 
    ( 
		SELECT category_id FROM category 
		WHERE name = "Family" 
    )); 

# 7e. Display the most frequently rented movies in descending order. 

	SELECT f.title, COUNT(rental_id) AS 'Times Rented' 
	FROM rental r 
	JOIN inventory i 
	ON (r.inventory_id = i.inventory_id) 
	JOIN film f 
	ON (i.film_id = f.film_id) 
	GROUP BY f.title 
	ORDER BY `Times Rented` DESC; 
	
#7f. Write a query to display how much business, in dollars, each store brought in. 
 
	SELECT s.store_id, SUM(amount) AS 'Revenue' 
	FROM payment p 
	JOIN rental r 
	ON (p.rental_id = r.rental_id) 
	JOIN inventory i 
	ON (i.inventory_id = r.inventory_id) 
	JOIN store s 
	ON (s.store_id = i.store_id) 
	GROUP BY s.store_id;  

# 7g. Write a query to display for each store its store ID, city, and country. 

	SELECT s.store_id, cty.city, country.country  
	FROM store s 
	JOIN address a  
	ON (s.address_id = a.address_id) 
	JOIN city cty 
	ON (cty.city_id = a.city_id) 
	JOIN country 
	ON (country.country_id = cty.country_id); 
	
#  7h. List the top five genres in gross revenue in descending order.  
--      (**Hint**: you may need to use the following tables: category, 
--       film_category, inventory, payment, and rental.
	SELECT c.name AS 'Genre', SUM(p.amount) AS 'Gross'  
	FROM category c 
	JOIN film_category fc  
	ON (c.category_id=fc.category_id) 
	JOIN inventory i  
	ON (fc.film_id=i.film_id) 
	JOIN rental r  
	ON (i.inventory_id=r.inventory_id) 
	JOIN payment p  
	ON (r.rental_id=p.rental_id) 
	GROUP BY c.name ORDER BY Gross  LIMIT 5; 
 
#  8a. In your new role as an executive, you would like to have an easy  
--      way of viewing the Top five genres by gross revenue. Use the solution 
--      from the problem above to create a view. If you haven't solved 7h, you 
--      can substitute another query to create a view. 

 
	CREATE VIEW genre_revenue AS 
	SELECT c.name AS 'Genre', SUM(p.amount) AS 'Gross'  
	FROM category c 
	JOIN film_category fc  
	ON (c.category_id=fc.category_id) 
	JOIN inventory i  
	ON (fc.film_id=i.film_id) 
	JOIN rental r  
	ON (i.inventory_id=r.inventory_id) 
	JOIN payment p  
	ON (r.rental_id=p.rental_id) 
	GROUP BY c.name ORDER BY Gross  LIMIT 5; 
 	 
#  8b. How would you display the view that you created in 8a? 

	SELECT * FROM genre_revenue; 
 
 
 #  8c. You find that you no longer need the view `top_five_genres`.  
  --      Write a query to delete it. 
 
 
	DROP VIEW genre_revenue; 
  
 -- end of SQL Home Work---

