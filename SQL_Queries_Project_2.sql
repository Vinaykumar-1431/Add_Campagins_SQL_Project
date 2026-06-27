


-- 1. Query :- Show patient_id and first_name from patients where their first_name starts and ends with 's' and is at least 6 characters long?

select patient_id,first_name
from patient_data
where first_name like 's%______s%';






-- 2. Query :- Show patient_id, first_name, last_name from patients whose diagnosis is 'Dementia'. Primary diagnosis is stored in the admissions table?

select p.patient_id,p.first_name,p.last_name,a.diagnosis 
from patient_data p join admissions_data a 
where p.patient_id = a.patient_id
having diagnosis = "Dementia";




-- 3. Query :- Display every patient's first_name. Order the list by the length of each name and then by alphabetically ?

select first_name
from patients
order by length(first_name),first_name;



-- 4. Query :- Show the total number of male patients and the total number of female patients in the patients table. Display the two results in the same row ?

select 
sum(case when gender = "M" then 1 else 0 end) as male_count,
sum(case when gender = "F" then 1 else 0 end) as female_count
from patients;



-- 5. Query :- Show patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis?

select patient_id,diagnosis,count(*) as admission_Count
from admissions_data
group by patient_id, diagnosis
having count(*) > 1 ;



-- 6. Query :- Show the city and the total number of patients in the city. Order from most to least patients and then by city name ascending?

select city,count(*) as Patients_Count
from patients
group by city  
order by count(*)desc,city asc;




-- 7. Query :- Show first name, last name and role of every person that is either patient or doctor. The roles are either "Patient" or "Doctor" ?

(select first_name,last_name, patient_id,'patient' as role
from patients)
union 
(select first_name,last_name,doctor_id, speciality
from doctors);

-- 8. Query :- Show all allergies ordered by popularity. Remove NULL values from the query ?

select allergies,count(*) as total_diagnosis_count
from patients
where allergies is not null
group by allergies
order by total_diagnosis_count desc ;




/* 9. Query :- Show all patient's first_name,last_name, and birth_date who were born in the 1970s decade. 
Sort the list starting from the earliest birth_date ?*/

select first_name,last_name,birth_date 
from patients
where year(birth_date) between 1970 and 1979 
order by birth_date;

/* 10. Query :- We want to display each patient's full name in a single column. Their last_name in all upper letters must appear first, 
then first_name in all lower case letters. Separate the last_name and first_name with a comma. Order the list by the first_name in descending order 
EX: SMITH,jane ? */

select upper(last_name) as Upper_Case,Lower(first_name) as Lower_Case,concat(upper(last_name),",",lower(first_name)) as full_name
from patients
order by first_name desc;

-- 11. Query :- Show the province_id(s), sum of height; where the total sum of its patient's height is greater than or equal to 7,000 ?

select province_id,sum(height) as total_height
from patients
group by province_id
having sum(height) >= 7000;

-- 12. Query :- Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni' ?

select max(weight)as Max_Weight,min(weight)as Min_weight,max(weight)-min(weight) as weight_difference,last_name
from patients
where last_name = 'Maroni';

/* 13. Query:-Show all of the days of the month (1-31) and how many admission_dates occurred on that day. 
Sort by the day with most admissions to least admissions ? */

select day(admission_date) as In_days,count(*) as Total_admissions
from admissions_data
group by day(admission_date)
order by Total_admissions desc;

/* 14. Query :- Show all of the patients grouped into weight groups. Show the total number of patients in each weight group. 
Order the list by the weight group descending. e.g. if they weigh 100 to 109 they are placed in the 100 weight group,
110-119 = 110 weight group, etc?*/

select floor(weight / 10) * 10 as weight_group,count(*) as Total_Patients
from patients
group by weight_group
order by weight_group desc;

/*15. Query :- Show patient_id, weight, height, isObese from the patients table. Display isObese as a boolean 0 or 1. 
Obese is defined as weight(kg)/(height(m). Weight is in units kg. Height is in units cm? */

select patient_id,weight,height,case when weight / power(height / 100, 2) >= 30 then 1 else 0 end as isObese
FROM patients;

/*16. Query :- Show patient_id, first_name, last_name, and attending doctor's speciality. 
Show only the patients who has a diagnosis as 'Epilepsy' and the doctor's first name is 'Lisa'. 
Check patients, admissions, and doctors tables for required information.?*/

select p.patient_id,p.first_name,p.last_name,d.speciality,a.diagnosis,d.first_name
from patients p join admissions_data a 
on p.patient_id = a.patient_id join doctors d 
on a.attending_doctor_id = d.doctor_id
where a.diagnosis = 'Epilepsy' and d.first_name = 'Lisa';     

/*17. Query :- All patients who have gone through admissions, can see their medical documents on our site. 
Those patients are given a temporary password after their first admission. Show the patient_id and temp_password.
The password must be the following, in order:
-	patient_id
-	the numerical length of patient's last_name
-	year of patient's birth_date ? */

select p.patient_id,concat(length(last_name),year(birth_date)) as temp_password
from patients p join admissions_data ad
on p.patient_id = ad.patient_id;
