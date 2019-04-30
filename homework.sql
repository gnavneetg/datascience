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

•6d. How many copies of the film Hunchback Impossible exist in the inventory system?
	select  f.title, count(inventory_id) copies from inventory i 
	inner join film f on f.film_id = i.film_id
	and upper(title) = 'Hunchback Impossible'

•6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
	select concat(c.last_name, ' ',c.first_name) as Name, sum(p.amount)  'Total Paid' from payment p
	inner join customer c on c.customer_id = p.customer_id
	group by Name
	order by Name



