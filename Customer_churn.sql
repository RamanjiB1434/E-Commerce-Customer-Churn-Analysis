--(1) creation of customer_churn table
create table customer_churn(
CustomerID integer, Churn integer, Tenure integer, PreferredLoginDevice text, CityTier integer, 
WarehouseToHome integer, PreferredPaymentMode text, Gender text, HourSpendOnApp integer,
NumberOfDeviceRegistered integer, PreferedOrderCat text, SatisfactionScore text, MaritalStatus text, 
NumberOfAddress integer, Complain integer, OrderAmountHikeFromlastYear integer, CouponUsed integer, 
OrderCount integer, DaySinceLastOrder integer, CashbackAmount integer
)

-- (2) Total Number of customer
select distinct count(customerid) as Total_customers
from customer_churn
-- There are 5630 customers in the given dataframe

-- (3) Checking for Duplicate values
select
customerid,
count(customerid) as count
from customer_churn
group by customerid
having count(customerid)>1
-- this query showing empty table it means there is no duplicate values

-- (4) Checking for Null values
select 'churn' as column_name, count(*) as NullCount
from customer_churn
where churn is null
union
select 'tenure' as columns_name, count(*) as NullCount
from customer_churn
where tenure is null
union
select 'PreferredLoginDevice' as column_name, count(*) as NullCount
from customer_churn
where PreferredLoginDevice is null
union
select 'CityTier' as column_name, count(*) as NullCount
from customer_churn
where CityTier is null
union
select 'WarehouseToHome' as column_name, count(*) as NullCount
from customer_churn
where WarehouseToHome is null
union
select 'PreferredPaymentMode' as column_name, count(*) as NullCount
from customer_churn
where PreferredPaymentMode is null
union
select 'Gender' as column_name, count(*) as NullCount
from customer_churn
where Gender is null
union
select 'HourSpendOnApp' as column_name, count(*) as NullCount
from customer_churn
where HourSpendOnApp is null
union
select 'NumberOfDeviceRegistered' as column_name, count(*) as NullCount
from customer_churn
where NumberOfDeviceRegistered is null
union
select 'PreferedOrderCat' as column_name, count(*) as NullCount
from customer_churn
where PreferedOrderCat is null
union
select 'SatisfactionScore' as column_name, count(*) as NullCount
from customer_churn
where SatisfactionScore is null
union
select 'MaritalStatus' as column_name, count(*) as NullCount
from customer_churn
where MaritalStatus is null
union
select 'NumberOfAddress' as column_name, count(*) as NullCount
from customer_churn
where NumberOfAddress is null
union
select 'Complain' as columns_name, count(*) as NullCount
from customer_churn
where Complain is null
union
select 'OrderAmountHikeFromlastYear' as columns_name, count(*) as NullCount
from customer_churn
where OrderAmountHikeFromlastYear is null
union
select 'CouponUsed' as column_name, count(*) as NullCount
from customer_churn
where CouponUsed is null
union
select 'OrderCount' as column_name, count(*) as NullCount
from customer_churn
where OrderCount is null
union
select 'DaySinceLastOrder' as column_name, count(*) as NullCount
from customer_churn
where DaySinceLastOrder is null
union 
select 'CashbackAmount' as column_name, count(*) as NullCount
from customer_churn
where CashbackAmount is null

-- (3.1) Handling Null Values
update customer_churn
set tenure = (select avg(tenure) from customer_churn)
where tenure is null

update customer_churn
set HourSpendOnApp = (select avg(HourSpendOnApp) from customer_churn)
where HourSpendOnApp is null

update customer_churn
set WarehouseToHome = (select avg(WarehouseToHome) from customer_churn)
where WarehouseToHome is null

update customer_churn
set DaySinceLastOrder = (select avg(DaySinceLastOrder) from customer_churn)
where DaySinceLastOrder is null

update customer_churn
set OrderCount = (select avg(OrderCount) from customer_churn)
where OrderCount is null

update customer_churn
set OrderAmountHikeFromlastYear = (select avg(OrderAmountHikeFromlastYear) from customer_churn)
where OrderAmountHikeFromlastYear is null

update customer_churn
set CouponUsed = (select avg(CouponUsed) from customer_churn)
where CouponUsed is null

-- (4) Creating new column for an already existing column "Churn"
alter table customer_churn
add customer_status nvarchar(50)

update customer_churn
set customer_status = 
case
	when churn = 1 then 'churned'
	when churn = 0 then 'stayed'
end

select distinct customer_status from customer_churn

-- (5) creating new column for already existing column "complain"
alter table customer_churn
add complaint_received nvarchar(10)

update customer_churn
set complaint_received = 
case
	when complain = 1 then 'yes'
	when complain = 0 then 'no'
end

select distinct complaint_received from customer_churn

-- (6) Fixing redundancies in each column
---(6.1) Checking redundancy in "preferredlogindevice" column
select distinct(Preferredlogindevice)
from customer_churn
-- fixing redundancy in "preferredlogindevice" column
update customer_churn
set preferredlogindevice = 'Phone'
where preferredlogindevice = 'Mobile Phone'

select distinct preferredlogindevice from customer_churn

---(6.2) Checking redundancy in "PreferedOrderCat" column
select distinct(PreferedOrderCat)
from customer_churn
-- fixing redundancy in "PreferedOrderCat" column
update customer_churn
set PreferedOrderCat = 'Mobile Phone'
where PreferedOrderCat = 'Mobile'

select distinct PreferedOrderCat from customer_churn

---(6.3) Checking redundancy in "preferredpaymentmode" column
select distinct(preferredpaymentmode)
from customer_churn
-- fixing redundancy in "PreferedOrderCat" column
update customer_churn
set preferredpaymentmode = 'Cash on Delivery'
where preferredpaymentmode = 'COD'

select distinct preferredpaymentmode from customer_churn

-- (6.4) Fixing wrongly entered values in "warehousetohome" column
select distinct warehousetohome
from customer_churn

update customer_churn
set warehousetohome = '27'
where warehousetohome = '127'

update customer_churn
set warehousetohome = '26'
where warehousetohome = '126'

select distinct warehousetohome
from customer_churn

select * from customer_churn

/* Data Exploration
(1) The overall customer churn rate.
*/
select Totalnumberofcustomers,
Totalnumberofchurnedcustomers,
cast((Totalnumberofchurnedcustomers*1.0/Totalnumberofcustomers*1.0)*100 as decimal(10,2)) as churn_rate
from
(select count(*) as Totalnumberofcustomers
 from customer_churn)as total,
(select count(*) as Totalnumberofchurnedcustomers
from customer_churn
where customer_status = 'churned') as churned

-- (2) Churn_rate based on preferred login device
select preferredlogindevice,
count(*) as Totalcustomers,
sum(churn) as churnedcustomers,
cast((sum(churn)*1.0/count(*))*100 as decimal(10,2)) as churn_rate
from customer_churn
group by preferredlogindevice

-- (3) Churn rate based on city tiers
select
citytier,
count(*) as totalcustomer,
sum(churn) as churnedcustomers,
cast((sum(churn)*1.0/count(*))*100 as decimal(10,2))as churn_rate
from customer_churn
group by citytier
order by churn_rate

-- (4) Churn_rate by WareHouseToHomeDistance
/* now we will create new colum "warehousetohomerange"
*/
alter table customer_churn
add warehousetohomerange varchar(50)

update customer_churn
set warehousetohomerange = 
CASE
	when warehousetohome <= 10 then 'Very Close Distance'
	when warehousetohome > 10 and warehousetohome <= 20 then 'Close Distance'
	when warehousetohome > 20 and warehousetohome <= 30 then 'Moderate Distance'
	when warehousetohome > 30 then 'Far Distance'
end

select distinct warehousetohomerange from customer_churn

select warehousetohomerange,
count(*) as Total_customers,
sum(churn) as Churned_customers,
cast((sum(churn)*1.0/count(*)*1.0)*100 as decimal(10,2)) as Churn_rate
from customer_churn
Group by 1
order by 4 desc

-- (5)  Churn_rate by preferredpaymentmode
select preferredpaymentmode,
count(*) as Total_customers,
sum(churn) as Churned_customers,
cast((sum(churn)*1.0/count(*)*1.0)*100 as decimal(10,2)) as Churn_rate
from customer_churn
group by 1
order by 4 desc

-- (6) Churn rate by Tenure
/* Create new column called "tenure_range"
*/
alter table customer_churn
add tenure_range varchar(20)

update customer_churn
set tenure_range = 
case
	when tenure <=6 then '6 Months'
	when tenure >6 and tenure <=12 then '1 Year'
	when tenure >12 and tenure <=24 then '2 Years'
	when tenure >24 then 'More than 2 years'

end

select distinct tenure_range from customer_churn

select tenure_range,
count(*) as Total_customers,
sum(churn) as Churned_customers,
cast((sum(churn)*1.0/count(*)*1.0)*100 as decimal(10,2)) as Churn_rate
from customer_churn
group by 1
order by 4 desc

-- (7) Churn_rate by Gender
select gender,
count(*) as Total_customers,
sum(churn) as Churned_customers,
cast((sum(churn)*1.0/count(*)*1.0)*100 as decimal(10,2)) as Churn_rate
from customer_churn
group by 1
order by 4 desc

-- (8) Churn_status by  average hourspendonapp
select customer_status,
avg(hourspendonapp) as averagehourspentonApp
from customer_churn
group by customer_status

-- (9) Churn_rate by NumberOfRegisteredDevices
select numberofdeviceregistered,
count(*) as Total_customers,
sum(churn) as Churned_customers,
cast((sum(churn)*1.0/count(*)*1.0)*100 as decimal(10,2))as Churn_rate
from customer_churn
group by 1
order by 4

-- (10) Churn_rate by PreferorderCat
select preferedordercat,
count(*) as total_customers,
sum(churn) as Churned_customers,
cast((sum(churn)*1.0/count(*)*1.0)*100 as decimal(10,2)) as churn_rate
from customer_churn
group by 1
order by 4 desc

-- (11) Churn_rate by SatisfactionScores.
select satisfactionscore,
count(*) as total_customers,
sum(churn) as Churned_customers,
cast((sum(churn)*1.0/count(*)*1.0)*100 as decimal(10,2)) as Churn_rate
from customer_churn
group by 1
order by 4 asc

-- (12) Churn_rate by Marrital_status
select maritalstatus,
count(*) as total_customers,
sum(churn) as Churned_Customers,
cast((sum(churn)*1.0/count(*)*1.0)*100 as decimal(10,2)) as Churn_rate
from customer_churn
group by 1

-- (13) Churn_rate by avrage NumberofAddresses
select avg(numberofaddress) as AverageNumberofchurnedcustomers
from customer_churn
where customer_status = 'churned'

-- (14) Churn_rate by Complaint_received
select complaint_received,
count(*) as Total_customers,
sum(churn) as Churned_customers,
cast((sum(churn)*1.0/count(*)*1.0)*100 as decimal(10,2)) as Churn_rate
from customer_churn
group by 1
order by 4

-- (15) customer_status by Couponused
select customer_status,
sum(couponused) as SumofCouponsUsed
from customer_churn
group by customer_status

-- (16) Average Numberofdays since the last for churned customers.
select avg(daysincelastorder) as AverageNumofdayssinceLastOrder
from customer_churn
where customer_status = 'churned'

-- (17) Churn_rate by CashbackAmount
-- Create new column called cashbackamountRange
alter table customer_churn
add cashbackamountRange varchar(50)

update customer_churn
set cashbackamountrange = 
case
	when cashbackamount <= 100 then 'Low Cashback Amount'
	when cashbackamount > 100 and cashbackamount <= 200 then 'Moderate Cashback Amount'
	when cashbackamount > 200 and cashbackamount <= 300 then 'High Cashback Amount'
	when cashbackamount >300 then 'Very High Cashback Amount'
end

select cashbackamountRange,
count(*) as total_customers,
sum(churn) as Churned_Customers,
cast((sum(churn)*1.0/count(*)*1.0)*100 as decimal(10,2)) as churn_rate
from customer_churn
group by 1
order by 4 asc

select * from customer_churn

