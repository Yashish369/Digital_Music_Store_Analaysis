create database music_db;

use music_db;

create table employee (
employee_id int,
last_name varchar (30),
first_name varchar (30),
title varchar (100),
reports_to int,
levels varchar (100),
birthdate date,
hire_date date,
address varchar (100),
city varchar (100),
state varchar (100),
country varchar (20),
postal_code varchar (10),
phone varchar (100),
fax varchar (30),
email varchar (30));

load data infile
'C:\Users\aatma\Desktop\music store data\music store data\employee.csv'
into table employee
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;


create table album2 (
album_id int not null,
title varchar (100),
artist_id int not null);

load data infile
'C:\Users\aatma\Desktop\music store data\music store data\album2.csv'
into table album2
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;


create table artist (
artist_id int not null,
name varchar (100));

load data infile
'C:\Users\aatma\Desktop\music store data\music store data\artist.csv'
into table artist
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

Create table customer (
customer_id int not null,
first_name varchar (30),
last_name varchar (30),
company varchar (20),
address varchar (100),
city varchar (20),
state varchar (20),
country varchar (20),
postal_code varchar (10),
phone varchar (15),
fax varchar (20),
email varchar (20),
support_rep_id int not null);

load data infile
'C:\Users\aatma\Desktop\music store data\music store data\customer.csv'
into table customer
fields terminted by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows

create table genre (
genre_id int not null,
name varchar (20));

load data infile
'C:\Users\aatma\Desktop\music store data\music store data\genre.csv'	
into table genre
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

create table invoice (
invoice_id int not null,
customer_id int not null,
invoice_date date,
billing_address varchar (100),
billing_city varchar (30),
billing_state varchar (20),
billing_country varchar (20),
billing_postal_code varchar (20),
total int);

load data infile
'C:\Users\aatma\Desktop\music store data\music store data\invoice.csv'
into table invoice
fields terminated by ','
enclosed  by '"'
lines terminated by '\n'
ignore 1 rows;


create table invoice_line (
invoice_line_id int not null,
invoice_id int not null,
track_id int not null,
unit_price int,
quantity int);

load data infile
'C:\Users\aatma\Desktop\music store data\music store data\invoice_line.csv'	
into table invoice_line
fields terminted by ','
enclosed by '"'
lines termianted by '\n'
ignore 1 rows;


create table media_type (
media_type_id int,
name varchar (30);

load data infile
'C:\Users\aatma\Desktop\music store data\music store data\media_type.csv'
into table media_type
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

create table playlist (
playlist_id int not null,
name varchar (50);

load data infile
'C:\Users\aatma\Desktop\music store data\music store data\playlist.csv'
into table playlist
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows

create table playlist_track (
playlist_id int not null,
track_id int not null;

load data infile
'C:\Users\aatma\Desktop\music store data\music store data\playlist_track.csv'
into table playlist_track
fields terminated by ','
enclosed by '"'
lines termiante by '\n'
ignore 1 rows

create table track (
track_id int not null,
name varchar (30),
album_id int not null,
media_type_id int not null,
genre_id int not null,
composer varchar (50),
milliseconds int,
bytes int,
unit_price int);

load data infile
'C:\Users\aatma\Desktop\music store data\music store data\track.csv'	
into table track
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;
	
	


Q1. Who is senior most employee based on Job title ?;
select * from employee
order by levels desc
limit 1; 

Q2. Which Country has the most invoices?;
select * from invoice;
select count(*), billing_country from invoice group by billing_country order by count(*) desc;


Q3. What are top 3 values of total invoice ?;
select total, invoice_id from invoice order by total desc limit 3;


Q4. Which city has the best customers ? We would like to throw a promotional Music Festival in the city we made the most money.
Write a query returns one city that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals.;
select * from invoice;
select billing_city as City, sum(total) as Total from invoice group by city order by total desc;
select * from invoice where billing_city = 'New York';


Q5. Who is the best customer? The Customer who has spend the most money will be declared the best customer. Write the query that returns
the person who has spent the most money.;
select * from customer;
select * from invoice;
select customer.first_name, customer.last_name, customer.customer_id, sum(invoice.total) as total from customer
join invoice on customer.customer_id = invoice.customer_id
group by customer.customer_id order by total desc limit 1;

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));




Q1. Write a query to return email, fist name, last name & Genre of all Rock Music Listeners. Return your list ordered alphabetically
by email starting with A;

select distinct customer.email, customer.first_name, customer.last_name
from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
join track on invoice_line.track_id = track.track_id
join genre on genre.genre_id = track.genre_id
where genre.name like 'Rock'
order by email;

Q2. Lets invite the artist who have written the most rock music	in our dataset. Write a query that returns the Artist name and total
track count of the Top 10 rock bands;

select artist.artist_id , artist.name , count(artist.artist_id) as number_of_songs from artist
join album2 on album2.artist_id = artist.artist_id
join track on album2.album_id = track.album_id
join genre on track.genre_id = genre.genre_id
where genre.name like 'Rock'
group by artist.artist_id
order by number_of_songs desc;

select * from artist;

Q3. //Return all the track names that have a song length longer than the average song length. Return the Name and Milliseconds
for each track. Order by the song length with the longest songs listed first.//;

select name as Track_name, milliseconds as Song_length from track
where milliseconds > (select avg(milliseconds) from track)
order by Song_length;


--Advanced--
Q1. Find how much amount spent on artist by each customer? Write a query to return customer name, artist name and total spent?;
select * from invoice_line;

with best_selling_artist as (
	select artist.artist_id as Artist_ID, artist.name as Artist_Name, 
	sum(invoice_line.unit_price*invoice_line.quantity) as Total_Sales from invoice_line
	join track on invoice_line.track_id = track.track_id
	join album2 on track.album_id = album2.album_id
	join artist on album2.artist_id = artist.artist_id
	group by 1
	order by 3 desc
    limit 1
)
select c.customer_id, c.first_name, c.last_name, bsa.artist_name, sum(il.unit_price*il.quantity) as Total_Spent
from invoice i
join customer c on c.customer_id = i.customer_id
join invoice_line il on il.invoice_id = i.invoice_id
join track t on t.track_id = il.track_id
join album2 alb on alb.album_id = t.album_id
join best_selling_artist bsa on bsa.artist_id = alb.artist_id
group by 1, 2, 3, 4
order by 5 desc;


Q2. We want to find out the most popular music genre for each country. We determind the most popular genre with the highest amount of purchases.
Write a query returns each country along with the top genre. For country where the maximum number of purchases is shared return all genres.;

with popular_genre as (
	select count(invoice_line.quantity) as Purchases, genre.genre_id, genre.name, customer.country,
    row_number() over(partition by customer.country order by count(invoice_line.quantity)desc) as Row_Num
    from customer
    join invoice on invoice.customer_id = customer.customer_id
    join invoice_line on invoice_line.invoice_id = invoice.invoice_id
    join track on track.track_id = invoice_line.track_id
    join genre on genre.genre_id = track.genre_id
    group by 2, 3, 4
    order by 4 asc, 1 desc
)
select * from popular_genre where row_num <= 1;

with recursive sales_per_country as (
	select count(*) as purchases_per_genre, customer.country, genre.name, genre.genre_id
    from invoice_line
    join invoice on invoice.invoice_id = invoice_line.invoice_id
    join customer on customer.customer_id = invoice.customer_id
    join track on track.track_id = invoice_line.track_id
    join genre on genre.genre_id = track.genre_id
    group by 2, 3, 4
    order by 2
),
max_genre_per_country as (select max(purchases_per_genre) as max_genre_number, country
	from sales_per_country
    group by 2
    order by 2)
    
select sales_per_country.*
from sales_per_country
join max_genre_per_country on sales_per_country.country = max_genre_per_country.country
where sales_per_country.purchases_per_genre = max_genre_per_country.max_genre_number;

Q3. Write a query that determines the customer that has spent the most on music for each country. Write a query that returns the country
along with the top customer and how much they spent. For countries where the top amount spent is shared, provide all customers who spent this amount.;

with recursive customer_with_country as (
	select customer.customer_id, customer.first_name, customer.last_name, billing_country, sum(total) as total_spending
    from invoice
    join customer on customer.customer_id = invoice.customer_id
    group by 1, 2, 4
    order by 5 desc),
country_max_spending as (
	select billing_country, max(total_spending) as Max_spendings
    from customer_with_country
    group by 1)
select cc.customer_id, cc.first_name, cc.last_name, cc.billing_country, cc.total_spending
from customer_with_country cc
join country_max_spending cs on cc.billing_country = cs.billing_country
where cc.total_spending = cs.Max_spendings
order by 4;

with customer_and_country as (
	select c.customer_id, c.first_name, c.last_name, billing_country, sum(total) as max_spending,
    row_number() over(partition by billing_country order by sum(total) desc) as Row_Num
    from invoice i
    join customer c on c.customer_id = i.customer_id
    group by 1, 4
    order by 4 asc, 5 desc)
select * from customer_and_country where Row_Num <= 1;
