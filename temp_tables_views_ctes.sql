use sakila;
show tables;

-- Step 1: Create a view
/* 
First, create a view that summarizes rental information for each customer. 
The view should include the customer's ID, name, email address, and total number of rentals (rental_count). 
*/
drop view if exists v_renatal_info;

create view v_renatal_info as
select customer_id, first_name, last_name, email, count(customer_id) as rental_count
from customer
left join rental
	using (customer_id)
group by customer_id;

select * from v_renatal_info;

-- Step 2: Create a temporary table
/* 
Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer. 
*/

drop temporary table if exists temp_payment_summary;

create temporary table temp_payment_summary as 
select customer_id, sum(amount) as total_paid
from payment
join v_renatal_info
	using (customer_id)
group by customer_id;

select * from temp_payment_summary;

-- Step 3:
/*
Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
The CTE should include the customer's name, email address, rental count, and total amount paid.
Next, using the CTE, create the query to generate the final customer summary report, which should include: 
customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count. 
*/ 

with rental_summary as (
select * 
from v_renatal_info
inner join temp_payment_summary
	using (customer_id)
)

select first_name, last_name, email, rental_count, total_paid, total_paid/rental_count as average_payment_per_rental 
from rental_summary;

