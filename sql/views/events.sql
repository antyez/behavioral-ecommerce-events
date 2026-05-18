-- event_time has "UTC" which forces the engine to treat it as a string
-- I transformed event_time to timestamp in this view and separated timezone to a different column in case it is needed for later analysis.=
CREATE OR REPLACE VIEW events AS
SELECT

    LEFT(event_time, 19)::TIMESTAMP AS event_time,
    RIGHT(event_time, 3) AS timezone,
    
	event_type,
    product_id,
    category_id,
    category_code,
    brand,
    price,
    user_id,
    user_session

FROM ecommerce_events;