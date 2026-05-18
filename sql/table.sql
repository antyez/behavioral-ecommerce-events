CREATE SCHEMA ecommerce_events
SET search_path TO ecommerce_events

CREATE TABLE ecommerce_events (
    event_time TEXT,
    event_type TEXT,
    product_id INTEGER,
    category_id BIGINT,
    category_code TEXT,
    brand TEXT,
    price DECIMAL(10, 2),
    user_id BIGINT,
    user_session TEXT
)