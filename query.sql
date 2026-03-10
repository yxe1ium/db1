SELECT 
    c.last_name || ' ' || c.first_name AS client,
    COUNT(d.id) AS domains_count,
    SUM(CASE WHEN d.status = 'active' THEN 1 ELSE 0 END) AS active_domains
FROM clients c
LEFT JOIN domains d ON c.id = d.client_id
GROUP BY c.id
ORDER BY domains_count DESC;
