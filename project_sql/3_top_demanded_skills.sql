SELECT 
    skills,
    COUNT(skd.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim AS skd
ON job_postings_fact.job_id = skd.job_id
INNER JOIN skills_dim AS sd
ON skd.skill_id = sd.skill_id
WHERE job_title_short = 'Data Analyst' AND job_work_from_home = TRUE
GROUP BY skills
ORDER BY demand_count DESC
LIMIT 5
