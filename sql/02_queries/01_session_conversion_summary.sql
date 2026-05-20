-- Hypothesis: Are users getting stuck somewhere? Does this business capitalize on their product views?
-- Standard conversion funnel (session based)

SET search_path TO ecommerce_events;

CREATE VIEW v_session_conversion_summary AS (   

WITH funnel_counts AS (
	SELECT
		COUNT(DISTINCT user_session) AS total_views,
		COUNT(DISTINCT CASE WHEN event_type = 'cart' THEN user_session END) AS total_add_to_cart,
		COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_session END) total_purchases
	FROM
		events
)

SELECT
	-- TOTAL VOLUMES --
	total_views,
    total_add_to_cart,
    total_purchases,
    -- possible view jail

    -- RATES --
    -- how many views became part of a cart? (Testing the view jail hypothesis) | view -> cart.
	ROUND((total_add_to_cart::NUMERIC / total_views) * 100, 2) AS view_to_cart_rate, 
    -- how many carts were bought in percentage? (Checkout efficiency) cart -> purchase.
    ROUND((total_purchases::NUMERIC / NULLIF(total_add_to_cart, 0)) * 100, 2) AS cart_to_purchase_rate,
    -- out of the total views, how many  ended up in a purchase? (Global conversion rate) | view -> cart -> purchase.
	ROUND((total_purchases::NUMERIC / total_views) * 100, 2) AS view_to_purchase_rate

FROM
	funnel_counts
);

-- Conclusion: 'view jail' hypothesis confirmed, out of all the views, only 10% of products were added to a cart and only 6% of the views were a purchase.
-- Acceptable cart to purchase rate = 58%, acceptable checkout efficiency by increasing views to cart rate might be the best way to increase purchases.