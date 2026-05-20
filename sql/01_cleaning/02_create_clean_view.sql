CREATE VIEW events AS (
    SELECT 
        LEFT(event_time, 19)::TIMESTAMP AS event_time,
        -- UTC at the end of event_type does not allow any engine to be treat it as timestamp, so it's a must to extract it
        RIGHT(event_time, 3) AS timezone, 
        -- Converts empty strings to nulls, appropiate for PowerBI and other tools
        NULLIF(TRIM(SPLIT_PART(category_code, '.', 1)), '') AS main_category,
        NULLIF(TRIM(SPLIT_PART(category_code, '.', 2)), '') AS sub_category,
        NULLIF(TRIM(SPLIT_PART(category_code, '.', 3)), '') AS product_type,
        event_type,
        product_id,
        category_id,
        category_code, 
        brand,
        price,
        user_id, -- null valid since might be guest traffic
        user_session
    FROM ecommerce_events
    -- Removes corrupted records which are not useful for the analysis.
    WHERE 
        event_time IS NOT NULL
        AND event_type IS NOT NULL
        AND product_id IS NOT NULL
        AND user_session IS NOT NULL
        AND NULLIF(TRIM(SPLIT_PART(category_code, '.', 1)), '') IS NOT NULL
)

-- NOTE: user_sessions might have UUIDs or different formats, however, they are all valid for this analysis.

