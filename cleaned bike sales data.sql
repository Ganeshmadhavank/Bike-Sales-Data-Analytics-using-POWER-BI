select * from [dbo].[bike_sales_cleaned_data];

--Write a SQL query to find the top 3 bike brands with the highest average mileage (Mileage (km/l)) across all states.

select top(3)* from (
select Brand,AVG(Mileage_km_l)as ml from [dbo].[bike_sales_cleaned_data]
group by Brand)as t3;

-- Write a SQL query to find the most expensive bike model (Model) in each state.

with cte as
(select State,Brand,Model,Price_INR,
ROW_NUMBER() over(partition by state order by Price_INR desc)as price_by_state
from [dbo].[bike_sales_cleaned_data])

select * from cte
where price_by_state=1;

--List the top 2 bike models with the highest average daily distance (Avg Daily Distance (km)) in each state.

with cte as
(select state,Brand,model,avg_daily_distance_km,
ROW_NUMBER() over(partition by state order by avg_daily_distance_km desc)as avdg
from [dbo].[bike_sales_cleaned_data])
select state,Brand,model,avg_daily_distance_km  from cte
where avdg <=2;

--Which brand has the highest total sales (Price (INR)) across all models?
select top (1)* from 
(select Brand ,SUM(Price_INR) as total_price from [dbo].[bike_sales_cleaned_data]
group by Brand)as t1;

-- Find the number of bikes sold in each state that have a mileage (Mileage (km/l)) above the overall average mileage.

select state, count(*) as above_avg_ml from [dbo].[bike_sales_cleaned_data]
where mileage_km_l >
(select AVG(Mileage_km_l) from [dbo].[bike_sales_cleaned_data])
group by state;

--Which state recorded the highest number of Royal Enfield Interceptor 650 sales according to the dataset
select State,brand,model,count(Model)as count_Interceptor_650 from [dbo].[bike_sales_cleaned_data]
where model='Interceptor 650'
group by State,brand,model;

--Rank all bike models within each brand based on their price (Price (INR)) in descending order. Show the brand, model, price, and rank

with cte as(
select  Brand,model,Price_INR,
dense_RANK() over(partition by brand order by Price_INR desc )as rnk
from [dbo].[bike_sales_cleaned_data])
select Brand,model,Price_INR,rnk from cte
group by Brand,model,Price_INR,rnk
order by brand,rnk;




