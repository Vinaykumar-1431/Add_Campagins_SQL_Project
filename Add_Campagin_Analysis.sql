select first_name,last_name,allergies,case when allergies is null then "no_allergies" end as update_allergies
from patients
where allergies is null;	
			
select  ifnull(allergies,"NKA") as Replaced
from patients;			
			
			
select distinct allergies 
from patients;

			
select (first_name + last_name)
from patients;		
				
select concat(left(concat(first_name,"" "",last_name),3), right(concat(first_name,"" "",last_name),2))as full_Name
from patients;			
				
select *, round(height/30.48,2) as height_in_feet
from patients
where patient_id = 1 or patient_id = 45 or patient_id = 534 or patient_id = 879 or patient_id = 1000;					
						
select distinct year(birth_date) as unique_year
from patients
order by unique_year;
						
						
select concat(d.first_name," ",d.last_name) as full_name,count(ad.attending_doctor_id) as total_admissions
from doctors d join admissions_data ad
on d.doctor_id = ad.attending_doctor_id
group by d.first_name,d.last_name,ad.attending_doctor_id
order by total_admissions desc;

use add_campaigns_dev;

select* from add_events_data;
update add_events_data set `event date` = str_to_date(`event date`, '%d-%m-%y');
alter table add_events_data modify `event date` Date;

alter table campaigns_data
change `name` campaign_name varchar(50);


select * from add_events_data;d



select *,case when clicks > 0 and conversions = 0 then 'lead' else event_type end as new_event_type
from add_events_dev;

use add_campaigns_dev;



-- 1. Query :- Find the top 3 ads per campaign based on number of clicks ?

select * from
(select a.ad_type,ad.ad_id,count(*) as clicks,
dense_rank() over(order by count(*) desc)as rnk -- This query is to find the overall on for top 3 clicks.
from add_events_data ad join ads a
on ad.ad_id = a.ad_id
where event_type = "click"
group by a.ad_id,a.ad_type
) Temp_one
where rnk <= 3;


select * from
(select a.ad_type,ad.ad_id,count(*) as clicks,
dense_rank() over (partition by  a.ad_type order by count(*) desc)as rnk -- This query is to find the overall on event_type for top 3 clicks.
from add_events_data ad join ads a
on ad.ad_id = a.ad_id
where event_type = "click"
group by a.ad_id,a.ad_type
) t
where rnk <= 3;


-- 2. Query :-Calculate daily CTR (Click Through Rate) for each campaign. CTR = Total Clicks / Total Impressions ? 

select ad.campaign_id,ae.event_date,
sum(case when event_type = 'Click' then 1 else 0 end) as clicks,
sum(case when event_type = 'impression' then 1 else 0 end) as impressions,
sum(case when event_type =  'click' then 1 else 0 end) * 10.0 / nullif(sum(case when event_type = 'impression' then 1 else 0 end),0) as CTR
from add_events_data ae join ads ad 
on ae.ad_id = ad.ad_id
group by ad.campaign_id,ae.event_date;

-- 3. Query :- Find users whose click count is above the average clicks of all users ?

select user_id,count(*) as clicks
from add_events_data
where event_type =  'click'
group by user_id
having count(*) >
(select avg(clicks)
from (
select count(*) as clicks
from add_events_data
where event_type = 'click'
group by user_id
) temp
);

-- 4. Query :- Identify the campaign with the highest conversion rate (click → lead).Conversion Rate = Leads / Clicks ?

select conversion_rate
from (
select a.ad_id,sum(case when ae.event_type in('comment','impression','like','purchase','share') then 1 else 0 end) * 1.0 /
nullif(sum(case when ae.event_type = 'click' then 1 else 0 end),0) as conversion_rate,
rank() over(order by sum(case when event_type in('comment','impression','like','purchase','share') then 1 else 0 end) * 1.0 / 
nullif(sum(case when ae.event_type = 'click' then 1 else 0 end),0) desc) as rnk
from add_events_data ae join ads a 
on ae.ad_id = a.ad_id join campaigns_data ca
on a.campaign_id = ca.campaign_id
group by a.ad_id
)t
where rnk = 1;




-- 5. Query :- Find the first interaction date for each user?

select user_id,min(event_date) as first_interaction_date
from add_events_data
group by user_id;







-- 6. Query :- Find users who clicked on ads from more than one campaign ?


select ad.user_id,c.campaign_name
from add_events_data ad join campaigns_data c
on ad.ad_id = c.campaign_id
where event_type = 'click'
group by ad.user_id,c.campaign_name
having user_id > 1;




-- 7. Query :- 	Calculate running total of clicks per campaign ordered by date.

select campaign_id, event_date,count(case when event_type = 'click' then 1 else 0 end) as clicks,
sum(count( case when event_type = 'click' then 1 else 0 end))
over(partition by campaign_id order by event_date desc)   AS Running_totals
from add_Events_data ad join Ads a 
on ad.Ad_id = A.Ad_id 
group by campaign_id, event_date;




-- 8. Query:- Find the day with highest impressions for each campaign ?

select campaign_id,event_date,impressions
from (
select a.campaign_id,ae.event_date,count(*) as impressions,
rank() over (partition by a.campaign_id order by count(*) desc) as rnk
from add_events_data ae join ads a on ae.ad_id = a.ad_id
where ae.event_type = "impression"
group by a.campaign_id,ae.event_date) sub_one
where rnk = 1;





-- 9. Query :- Identify ads where clicks > impressions (data quality check).count clicks per ad,Count impressions per ad?

select ad_id,sum(case when event_type = 'click' then 1 else 0 end) as clicks,sum(case when event_type = 'impression' then 1 else 0 end) as impressions
from add_events_data
group by ad_id
having sum(case when event_type = 'click' then 1 else 0 end) <= sum(case when event_type = 'impression' then 1 else 0 end); 




select *
from (
	select ad_id,sum(case when event_type = 'click' then 1 else 0 end) as clicks,sum(case when event_type = 'impression' then 1 else 0 end) as impressions
    from add_events_data
    group by ad_id
    )temp
where clicks <= impressions; -- see once this

select count(*)
from add_events_data
where event_type = 'click'
group by event_type;

select count(*)
from add_events_data
where event_type = 'impression'
group by event_type;


-- 11. Query :- Calculate percentage contribution of each campaign to total clicks.% Contribution = campaign_clicks / total_clicks * 100

select a.campaign_id,count(*) as campaign_clicks,round(count(*) * 100.0 / sum(count(*)) over(), 2 ) as percentage_contribution 
from add_events_data ae join ads a 
on ae.ad_id = a.ad_id
where ae.event_type = 'click'
group by a.campaign_id;



-- 12. Query :- Find campaigns where no leads were generated ? 

select campaign_id,count(case when event_type <> "purchase" then 1 else 0 end) as leads
from add_events_data join ads 
group by campaign_id
having count(case when event_type <> "purchase" then 1 else 0 end);



-- 13. Query :- Find users who viewed ads but never clicked.Logic: Users with impressions,Exclude users with clicks ?

select user_id,sum(case when event_type = "impression" then 1 else 0 end) as impressions,
sum(case when event_type = "click" then 1 else 0 end) as clicks
from add_events_data
where event_type != "click"
group by user_id;



-- 14. Query :- Find the most popular ad type based on total interactions ?

select ad_type,total_interactions
from(
select ad_type,count(*) as total_interactions,
dense_rank() over(order by count(*) desc) as rnk
from add_events_data ad join ads a
on ad.ad_id = a.ad_id
group by ad_type
) type
where rnk = 1;


-- 15. Query :- Calculate average time gap between user interactions ?

select user_id,avg(day_gap) as avg_days_gap
from(
select user_id,datediff(event_date,lag(event_date) over (partition by user_id order by event_date) ) as day_gap
from add_events_data ) temp
where day_gap is not null
group by user_id;





-- 16. Query :- Find campaigns where performance dropped (clicks decreased) compared to previous day ?

select campaign_id,event_date,clicks,prev_clicks
from (
select campaign_id,event_date,clicks,lag(clicks) over(partition by campaign_id order by event_date) as prev_clicks
from(
select a.campaign_id,ae.event_date,count(*) as clicks
from add_events_data ae join ads a 
on ae.ad_id = a.ad_id
where ae.event_type = "click"
group by a.campaign_id,ae.event_date) temp1
)temp2
where prev_clicks is not null
and clicks < prev_clicks;


-- 17. Query :- Identify users with continuous activity for 3 consecutive days ?

select distinct user_id
from(
select user_id,event_date,
lag(event_date, 1) over(partition by user_id order by event_date) as prev_day_1,lag(event_date, 2) over(partition by user_id order by event_date) as prev_day_2
from (
select distinct user_id,event_date
from add_events_data)temp1
)temp2
where datediff(event_date,prev_day_1) = 1 and datediff(prev_day_1,prev_day_2) = 1;




-- 18. Query :- Find top performing campaign per location ?

select location,campaign_id,clicks
from(
select u.location,a.campaign_id,count(*) as clicks,row_number() over (partition by location order by count(*) desc) as rn
from add_events_data ae
join ads a on ae.ad_id = a.ad_id 
join users u on ae.user_id = u.user_id
where ae.event_type = "click"
group by u.location,a.campaign_id ) temp
where rn = 1;




 -- 19. Query :- Calculate lead conversion rate per ad type. Conversion Rate = Leads / Clicks
 
select a.ad_type,sum(case when ae.event_type = "purchase" then 1 else 0 end) as leads,sum(case when ae.event_type = "click" then 1 else 0 end) as clicks,
round(sum(case when ae.event_type = "purchase" then 1 else 0 end) * 1.0/ nullif(sum(case when ae.event_type ="click" then 1 else 0 end),0),2) as conversion_rate
from add_events_data ae join ads a 
on ae.ad_id = a.ad_id
group by a.ad_type;





-- 20. Query :- Find ads that contributed to at least 80% of total clicks,Count clicks per ad,Sort DESC,Calculate cumulative sum:Divide by total clicks,Filter until ≤ 80% ?

select ad_id,clicks,cummlative_clicks,total_clicks,cummlative_clicks *1.0 /total_clicks as cummlative_percentage 
from (
select ad_id,clicks,sum(clicks) over (order by clicks desc) as cummlative_clicks,
sum(clicks) over () as total_clicks
from(
select ad_id,count(*) as clicks
from add_events_data
where event_type = "click"
group by ad_id
)temp1
)temp2
where cummlative_clicks * 1.0 / total_clicks <= 80;

-- 21. Query :- Derive the Age Group based on age ?

select user_id,age_group,
case when age_group between 16 and 17 then "child"
when age_group between 18 and 24 then "Youth"
when age_group between 25 and 34 then "Young Adult"
when age_group between 35 and 44 then "Adult"
when age_group between 45 and 54 then "Mid Age"
else "Senior" end as updated_age_group
from users;
