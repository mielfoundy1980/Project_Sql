/*
Question 1 : What are the top-paying Data Analyst jobs?
- Identify the Top 10 highest-paying Data Analyst roles that are available remotely.
- Focuses on job postings with specified salaries (remove null values).
- Why? Highlight the top-paying opportunities for Data Analysts.
*/

SELECT
    jpf.job_title_short AS job_title_short,
    jpf.job_title AS job_title,
    jpf.job_location AS job_location,
    cd.name AS company_name,
    jpf.job_schedule_type AS job_schedule_type,
    jpf.job_posted_date::DATE AS job_post_date,
    jpf.salary_year_avg AS salary_year_avg
FROM job_postings_fact jpf
LEFT JOIN company_dim cd
ON jpf.company_id = cd.company_id
WHERE
    job_title_short = 'Data Analyst' 
    AND salary_year_avg IS NOT NULL
    AND job_location = 'Anywhere'
ORDER BY salary_year_avg DESC
LIMIT 10;