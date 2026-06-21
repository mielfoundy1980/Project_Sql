/*
Question 5: What are the most optimal skill to learn (high demand & high-paying skill) ?
- Identify skills inhigh demand and associated with high average salary for Data Analyst roles
- Concentrate on remote positions with specified salaries
- Why? target skills that offer job security (high demand) and financial benefits (high salaries),
offering startegic insights for career development in data analysis
*/
SELECT
    sd.skill_id AS skill_id,
    sd.skills AS skill_name,
    ROUND(AVG(jpf.salary_year_avg), 2) AS avg_salary,
    COUNT(jpf.job_id) AS demand_count
FROM job_postings_fact jpf
INNER JOIN skills_job_dim sjd ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim sd ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Analyst'
    AND jpf.salary_year_avg IS NOT NULL
    AND jpf.job_location = 'Anywhere'
GROUP BY
    sd.skill_id
HAVING COUNT(jpf.job_id) > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;