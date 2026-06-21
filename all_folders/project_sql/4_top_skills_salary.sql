/*
Question 4: What are the top skills based on salary?
- Look at the average salary associated with each skill for Data Analyst positions
- Focuses on roles with specified salaries, regardless of location
- Why? it reveals how different skills impact salary levels for Data Analyst and helps
identify the most financially rewarding skills to acquire or improve
*/
SELECT
    sd.skills AS skill_name,
    ROUND(AVG(jpf.salary_year_avg), 2) AS avg_salary
FROM job_postings_fact jpf
INNER JOIN skills_job_dim sjd ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim sd ON sjd.skill_id = sd.skill_id
WHERE 
    jpf.job_title_short = 'Data Analyst'
    AND jpf.salary_year_avg IS NOT NULL
    AND jpf.job_location = 'Anywhere'
GROUP BY 
    sd.skills
ORDER BY avg_salary DESC
LIMIT 25;

/*

============================================================
📋 FINAL SUMMARY REPORT
============================================================
• Total skills analyzed: 25
• Unique categories: 9
• Salary range: $121,619.25 - $208,172.25
• Average salary: $143,380.00
• Median salary: $141,906.60
• Top paying skill: pyspark ($208,172.25)
• Category with highest avg salary: Big Data ($158,727.28)

============================================================
🎯 RECOMMENDATIONS
============================================================

• Big Data rules - PySpark, Databricks, Airflow command top salaries
• DevOps matters - Bitbucket, GitLab, Linux are highly valued
• Python ecosystem - Jupyter, Pandas, NumPy are essential
• AI/ML platforms - Watson, DataRobot are emerging
• Cloud skills - GCP, Databricks are critical

============================================================
💡 TOP 5 SKILLS TO LEARN
============================================================

1. PySpark
2. Bitbucket
3. Couchbase/Watson
4. DataRobot
5. GitLab
*/