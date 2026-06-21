/*
Question 3 : What are the most in-demand skills for Data Analyst?
- Display the top 5 in-demand skills for Data Analyst.
- Focus on all job postings.
Why? Retreives the top 5 skills with the highest demand in the job marker,
providing insights into the most valuable skills for seekers
*/

SELECT 
    sd.skills AS skill_name,
    COUNT(DISTINCT jpf.job_id) AS postings_counts
FROM job_postings_fact jpf
INNER JOIN skills_job_dim sjd ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim sd ON sjd.skill_id = sd.skill_id
WHERE 
    jpf.job_title_short = 'Data Analyst'
GROUP BY 
    sd.skills
ORDER BY 
    postings_counts DESC
LIMIT 5;