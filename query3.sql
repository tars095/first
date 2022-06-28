SELECT bonus_type, count(*)
FROM bonuses_report_beta
WHERE bonuses_report_beta.bonus_created_date >= '2022-01-01'
AND order_skin = 'ios_atd'
GROUP BY bonus_type;
