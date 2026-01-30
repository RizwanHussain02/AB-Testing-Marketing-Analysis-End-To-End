CREATE DATABASE ab_testing_db;

-- STEP 1: Create Raw Table

CREATE TABLE marketing_ab_clean (
    test_group      VARCHAR(10),
    converted       BOOLEAN,
    total_ads       INTEGER,
    most_ads_day    VARCHAR(10),
    most_ads_hour   INTEGER
);


-- =====================================================
-- STEP 2: Verify Raw Data
-- =====================================================
SELECT COUNT(*) AS total_rows FROM marketing_ab_clean;

SELECT * FROM marketing_ab_clean LIMIT 10;


-- =====================================================
-- STEP 3: A/B Summary Table (Overall Performance)
-- =====================================================
CREATE TABLE ab_summary AS
SELECT
    test_group,
    COUNT(*) AS users,
    SUM(CASE WHEN converted = true THEN 1 ELSE 0 END) AS conversions,
    ROUND(
        SUM(CASE WHEN converted = true THEN 1 ELSE 0 END)::numeric
        / COUNT(*),
        4
    ) AS conversion_rate
FROM marketing_ab_clean
GROUP BY test_group;


-- =====================================================
-- STEP 4: Conversion Rate by Day
-- =====================================================
CREATE TABLE conversion_by_day AS
SELECT
    test_group,
    most_ads_day,
    COUNT(*) AS users,
    SUM(CASE WHEN converted = true THEN 1 ELSE 0 END) AS conversions,
    ROUND(
        SUM(CASE WHEN converted = true THEN 1 ELSE 0 END)::numeric
        / COUNT(*),
        4
    ) AS conversion_rate
FROM marketing_ab_clean
GROUP BY test_group, most_ads_day;


-- =====================================================
-- STEP 5: Conversion Rate by Hour
-- =====================================================
CREATE TABLE conversion_by_hour AS
SELECT
    test_group,
    most_ads_hour,
    COUNT(*) AS users,
    SUM(CASE WHEN converted = true THEN 1 ELSE 0 END) AS conversions,
    ROUND(
        SUM(CASE WHEN converted = true THEN 1 ELSE 0 END)::numeric
        / COUNT(*),
        4
    ) AS conversion_rate
FROM marketing_ab_clean
GROUP BY test_group, most_ads_hour;


-- =====================================================
-- STEP 6: Ad Exposure Bucket Summary
-- =====================================================
CREATE TABLE ads_exposure_summary AS
SELECT
    test_group,
    CASE
        WHEN total_ads <= 5 THEN 'Low'
        WHEN total_ads <= 20 THEN 'Medium'
        ELSE 'High'
    END AS ads_bucket,
    COUNT(*) AS users,
    SUM(CASE WHEN converted = true THEN 1 ELSE 0 END) AS conversions,
    ROUND(
        SUM(CASE WHEN converted = true THEN 1 ELSE 0 END)::numeric
        / COUNT(*),
        4
    ) AS conversion_rate
FROM marketing_ab_clean
GROUP BY test_group, ads_bucket;


-- =====================================================
-- STEP 7: Final Validation (Optional)
-- =====================================================
SELECT * FROM ab_summary;
SELECT * FROM conversion_by_day LIMIT 10;
SELECT * FROM conversion_by_hour LIMIT 10;
SELECT * FROM ads_exposure_summary;
