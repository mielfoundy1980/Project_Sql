/*
Question 3 : What are the most in-demand skills for Data Analyst?
- Display the top 5 in-demand skills for Data Analyst.
- Focus on all job postings.
Why? Retreives the top 5 skills with the highest demand in the job marker,
providing insights into the most valuable skills for seekers
*/
WITH remote_job_skills AS (
    SELECT
        jpf.job_id AS job_id,
        sd.skill_id AS skill_id,
        sd.skills AS skill_name
    FROM job_postings_fact jpf
    INNER JOIN skills_job_dim sjd
    ON jpf.job_id = sjd.job_id
    INNER JOIN skills_dim sd
    ON sjd.skill_id = sd.skill_id
    WHERE
        job_title_short = 'Data Analyst'
) 
SELECT
    skill_name,
    COUNT(job_id) AS postings_counts
FROM remote_job_skills
GROUP BY
    skill_name
ORDER BY postings_counts DESC
LIMIT 5;