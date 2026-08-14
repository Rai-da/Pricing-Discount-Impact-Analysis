-- Pricing & Discount Impact Analysis
-- SQL analysis supporting the Power BI dashboard

-- How does profit margin change as discount increases?

SELECT
    discount,
    ROUND(
        (SUM(profit) / NULLIF(SUM(sales), 0) * 100)::numeric,
        2
    ) AS profit_margin_pct
FROM store_sales_data
GROUP BY discount
ORDER BY discount;

-- Does the increase in sales/revenue compensate for the lower margin?
-- For each discount level, how much total profit did the store make?

SELECT
      discount,
      SUM(sales) AS total_sales,
      SUM(profit) AS total_profit
FROM store_sales_data
GROUP BY discount
ORDER BY discount;

-- If the company wants to maximize total profit, which discount level should it prefer?

SELECT
      discount,
      SUM(sales) AS total_sales,
      SUM(profit) AS total_profit
FROM store_sales_data
GROUP BY discount
ORDER BY total_profit DESC
LIMIT 1;

-- If we give customers a bigger discount, do they actually buy more?

SELECT
     discount,
     SUM(quantity) AS total_purchase_units
FROM store_sales_data
GROUP BY discount
ORDER BY discount;

-- Which discount level gives us a good amount of sales while still keeping profit high?

SELECT
     discount,
     SUM(profit) AS total_profit,
     SUM(sales) AS total_sales
FROM store_sales_data
GROUP BY discount
ORDER BY discount;

-- Do discounts hurt some product categories' profits more than others?

SELECT category_of_goods,
       discount,
       SUM(profit) AS total_profit,
       SUM(sales) AS total_sales
FROM store_sales_data
GROUP BY category_of_goods, discount
ORDER BY total_profit;

-- Which product categories lose the most profit margin as discounts increase?

SELECT category_of_goods,
       discount,
       SUM(sales) AS total_sales,
       SUM(profit) AS total_profit,
       ROUND(
        (SUM(profit) / NULLIF(SUM(sales), 0) * 100)::numeric,
        2
    ) AS profit_margin
FROM store_sales_data
GROUP BY category_of_goods, discount
ORDER BY profit_margin;

-- When we don't give customers any discount, how profitable is each category?

SELECT
    category_of_goods,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    ROUND(
        (SUM(profit) / NULLIF(SUM(sales), 0) * 100)::numeric,
        2
    ) AS profit_margin
FROM store_sales_data
WHERE discount = 0
GROUP BY category_of_goods
ORDER BY profit_margin DESC;

-- When we increase the discount from 0% to 50%, which category loses the most profit margin?

SELECT
    category_of_goods,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    ROUND(
        (SUM(profit) / NULLIF(SUM(sales), 0) * 100)::numeric,
        2
    ) AS profit_margin
FROM store_sales_data
WHERE discount = 0.50
GROUP BY category_of_goods
ORDER BY profit_margin DESC;

-- If 50% discounts reduce profit margins so much, do they at least generate enough extra sales to make up for it?

SELECT
    category_of_goods,
    discount,
    SUM(sales) AS total_sales
FROM store_sales_data
WHERE discount IN (0, 0.50)
GROUP BY category_of_goods, discount
ORDER BY category_of_goods, discount;

-- Which categories actually benefit from a 50% discount, after considering both sales growth and profit?

SELECT
    category_of_goods,
    discount,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM store_sales_data
WHERE discount IN (0, 0.50)
GROUP BY category_of_goods, discount
ORDER BY category_of_goods, discount;

-- What discount level gives us the best combination of sales and profit?

SELECT
    CASE
        WHEN discount = 0 THEN 'No Discount'
        WHEN discount <= 0.10 THEN 'Low Discount'
        WHEN discount <= 0.20 THEN 'Moderate Discount'
        WHEN discount <= 0.30 THEN 'High Discount'
        ELSE 'Very High Discount'
    END AS discount_bucket,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM store_sales_data
GROUP BY
    CASE
        WHEN discount = 0 THEN 'No Discount'
        WHEN discount <= 0.10 THEN 'Low Discount'
        WHEN discount <= 0.20 THEN 'Moderate Discount'
        WHEN discount <= 0.30 THEN 'High Discount'
        ELSE 'Very High Discount'
    END;

-- Which discount range gives the best profit margin?

SELECT
    CASE
        WHEN discount = 0 THEN 'No Discount'
        WHEN discount <= 0.10 THEN 'Low Discount'
        WHEN discount <= 0.20 THEN 'Moderate Discount'
        WHEN discount <= 0.30 THEN 'High Discount'
        ELSE 'Very High Discount'
    END AS discount_bucket,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    ROUND(
        (SUM(profit) / NULLIF(SUM(sales), 0) * 100)::numeric,
        2
    ) AS profit_margin_pct
FROM store_sales_data
GROUP BY
    CASE
        WHEN discount = 0 THEN 'No Discount'
        WHEN discount <= 0.10 THEN 'Low Discount'
        WHEN discount <= 0.20 THEN 'Moderate Discount'
        WHEN discount <= 0.30 THEN 'High Discount'
        ELSE 'Very High Discount'
    END;

-- Which discount range gives the best overall trade-off between sales and profitability?

SELECT
    CASE
        WHEN discount = 0 THEN 'No Discount'
        WHEN discount <= 0.10 THEN 'Low Discount'
        WHEN discount <= 0.20 THEN 'Moderate Discount'
        WHEN discount <= 0.30 THEN 'High Discount'
        ELSE 'Very High Discount'
    END AS discount_bucket,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    ROUND(
        (SUM(profit) / NULLIF(SUM(sales), 0) * 100)::numeric,
        2
    ) AS profit_margin_pct,
    RANK() OVER (ORDER BY SUM(profit) DESC) AS profit_rank
FROM store_sales_data
GROUP BY
    CASE
        WHEN discount = 0 THEN 'No Discount'
        WHEN discount <= 0.10 THEN 'Low Discount'
        WHEN discount <= 0.20 THEN 'Moderate Discount'
        WHEN discount <= 0.30 THEN 'High Discount'
        ELSE 'Very High Discount'
    END;

-- How much profit does the business make per transaction at each discount range?

SELECT discount,
       COUNT(*) AS total_transaction,
       SUM(profit) AS total_profit,
       ROUND(AVG(profit)::NUMERIC, 2) AS profit_per_transaction
FROM store_sales_data
GROUP BY discount
ORDER BY total_transaction, total_profit;

-- When we give a bigger discount, do enough more customers/transactions happen to make up for the lower profit we earn from each transaction?

SELECT discount,
       COUNT(*) AS total_transaction,
       SUM(profit) AS total_profit,
       ROUND(AVG(profit)::NUMERIC, 2) AS profit_per_transaction
FROM store_sales_data
WHERE discount > 0.30
GROUP BY discount
ORDER BY total_transaction, total_profit;

-- Which discount level gives the highest profit for each transaction?

SELECT discount,
       COUNT(*) AS total_transaction,
       SUM(profit) AS total_profit,
       ROUND(AVG(profit)::NUMERIC, 2) AS profit_per_transaction
FROM store_sales_data
GROUP BY discount
ORDER BY profit_per_transaction DESC
LIMIT 1;

-- Does giving a discount bring enough extra transactions to make up for the lower profit per transaction?

SELECT discount,
       COUNT(*) AS total_transaction,
       ROUND(AVG(profit)::NUMERIC, 2) AS profit_per_transaction,
       ROUND((COUNT(*) * AVG(profit))::NUMERIC, 2) AS overall_profit
FROM store_sales_data
GROUP BY discount
ORDER BY overall_profit;

-- After which discount level do bigger discounts stop bringing significantly more transactions?

SELECT
    discount,
    COUNT(*) AS total_transactions
FROM store_sales_data
GROUP BY discount
ORDER BY discount;

-- When the discount increases, how many more or fewer transactions do we get compared with the previous discount level?

SELECT
    discount,
    COUNT(*) AS total_transactions,
    COUNT(*) - LAG(COUNT(*)) OVER (ORDER BY discount) AS transaction_change
FROM store_sales_data
GROUP BY discount
ORDER BY discount;

-- Which discounts give us a lot of transactions without sacrificing too much profit margin?

SELECT
    discount,
    COUNT(*) AS total_transactions,
    ROUND(
        (SUM(profit) / NULLIF(SUM(sales), 0) * 100)::numeric,
        2
    ) AS profit_margin_pct
FROM store_sales_data
GROUP BY discount
ORDER BY discount;

-- Does the best discount range differ depending on the product category?

SELECT category_of_goods,
       discount,
       COUNT(*) AS total_transaction,
       ROUND(
        (SUM(profit) / NULLIF(SUM(sales), 0) * 100)::numeric,
        2
    ) AS profit_margin_pct
FROM store_sales_data
GROUP BY category_of_goods, discount
ORDER BY category_of_goods, discount;

-- For each product category, which discount level gives the highest total profit?

SELECT category_of_goods,
       discount,
       SUM(profit) AS total_profit,
       RANK() OVER (
           PARTITION BY category_of_goods
           ORDER BY SUM(profit) DESC
       ) AS profit_rank
FROM store_sales_data
GROUP BY category_of_goods, discount
ORDER BY category_of_goods, profit_rank;

WITH ranked_discounts AS (
    SELECT
        category_of_goods,
        discount,
        SUM(profit) AS total_profit,
        RANK() OVER (
            PARTITION BY category_of_goods
            ORDER BY SUM(profit) DESC
        ) AS profit_rank
    FROM store_sales_data
    GROUP BY category_of_goods, discount
)
SELECT
    category_of_goods,
    discount,
    total_profit
FROM ranked_discounts
WHERE profit_rank = 1
ORDER BY category_of_goods;

-- Are these category-specific best discounts also good for profit margin?

SELECT category_of_goods,
       discount,
       SUM(profit) AS total_profit,
       ROUND(
        (SUM(profit) / NULLIF(SUM(sales), 0) * 100)::numeric,
        2
    ) AS profit_margin_pct,
       RANK() OVER (
           PARTITION BY category_of_goods
           ORDER BY SUM(profit) DESC
       ) AS profit_rank
FROM store_sales_data
GROUP BY category_of_goods, discount
ORDER BY category_of_goods, profit_rank;

WITH ranked_discounts AS (
    SELECT
        category_of_goods,
        discount,
        SUM(profit) AS total_profit,
        ROUND(
            (SUM(profit) / NULLIF(SUM(sales), 0) * 100)::numeric,
            2
        ) AS profit_margin,
        RANK() OVER (
            PARTITION BY category_of_goods
            ORDER BY SUM(profit) DESC
        ) AS profit_rank
    FROM store_sales_data
    GROUP BY category_of_goods, discount
)
SELECT
    category_of_goods,
    discount,
    total_profit,
    profit_margin
FROM ranked_discounts
WHERE profit_rank = 1
ORDER BY category_of_goods;

-- Which categories are most dependent on discounts to generate sales?

WITH category_discount AS (
    SELECT
        category_of_goods,
        discount,
        SUM(sales) AS total_sales,
        SUM(profit) AS total_profit,
        RANK() OVER (
            PARTITION BY category_of_goods
            ORDER BY SUM(profit) DESC
        ) AS profit_rank
    FROM store_sales_data
    GROUP BY category_of_goods, discount
),
best_discount AS (
    SELECT
        category_of_goods,
        discount AS best_discount,
        total_sales AS sales_at_best_discount,
        total_profit AS profit_at_best_discount
    FROM category_discount
    WHERE profit_rank = 1
),
no_discount AS (
    SELECT
        category_of_goods,
        SUM(sales) AS sales_at_no_discount
    FROM store_sales_data
    WHERE discount = 0
    GROUP BY category_of_goods
)
SELECT
    b.category_of_goods,
    b.best_discount,
    ROUND(n.sales_at_no_discount::numeric, 2) AS sales_at_no_discount,
    ROUND(b.sales_at_best_discount::numeric, 2) AS sales_at_best_discount,
    ROUND((b.sales_at_best_discount - n.sales_at_no_discount)::numeric, 2) AS sales_change,
    ROUND(
        ((b.sales_at_best_discount - n.sales_at_no_discount)
         / NULLIF(n.sales_at_no_discount, 0) * 100)::numeric,
        2
    ) AS sales_change_pct,
    ROUND(b.profit_at_best_discount::numeric, 2) AS profit_at_best_discount
FROM best_discount b
JOIN no_discount n
    ON b.category_of_goods = n.category_of_goods
ORDER BY sales_change_pct DESC;

-- Which categories lose the most profit margin from 0% to 50% discount?

WITH category_level AS (
    SELECT category_of_goods,
           discount,
           SUM(sales) AS total_sales,
           SUM(profit) AS total_profit,
           ROUND(
                (SUM(profit) / NULLIF(SUM(sales), 0) * 100)::numeric,
                2
           ) AS profit_margin
    FROM store_sales_data
    WHERE discount = 0
    GROUP BY category_of_goods, discount
),
margin_calc AS (
    SELECT category_of_goods,
           discount,
           SUM(sales) AS total_sales,
           SUM(profit) AS total_profit,
           ROUND(
                (SUM(profit) / NULLIF(SUM(sales), 0) * 100)::numeric,
                2
           ) AS profit_margin
    FROM store_sales_data
    WHERE discount = 0.50
    GROUP BY category_of_goods, discount
)
SELECT c.category_of_goods,
       c.profit_margin AS margin_at_0_percent,
       m.profit_margin AS margin_at_50_percent,
       ROUND((c.profit_margin - m.profit_margin)::NUMERIC, 2) AS margin_loss
FROM category_level c
JOIN margin_calc m
  ON c.category_of_goods = m.category_of_goods
ORDER BY margin_loss DESC;

-- Which categories are most profitable per transaction at different discounts?

SELECT
    category_of_goods,
    discount,
    COUNT(*) AS total_transactions,
    SUM(profit) AS total_profit,
    ROUND((SUM(profit) / COUNT(*))::numeric, 2) AS profit_per_transaction
FROM store_sales_data
GROUP BY category_of_goods, discount
ORDER BY category_of_goods, discount;

-- Which sub-categories are most affected by high discounts?

SELECT "Sub-Category",
        discount,
        SUM(sales) AS total_sales,
        SUM(profit) AS total_profit,
        ROUND(
            (SUM(profit) / NULLIF(SUM(sales), 0) * 100)::numeric,
            2
        ) AS profit_margin
FROM store_sales_data
WHERE discount >= 0.30
GROUP BY "Sub-Category", discount
ORDER BY "Sub-Category", discount;

-- Which products generate high sales but surprisingly low profit?

SELECT
    "Product_ID",
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    ROUND(
        (SUM(profit) / NULLIF(SUM(sales), 0) * 100)::numeric,
        2
    ) AS profit_margin
FROM store_sales_data
GROUP BY "Product_ID"
ORDER BY total_sales DESC, profit_margin ASC;

-- Among the top 10% highest-selling products, which products have the weakest profit margins?

WITH product_performance AS (
    SELECT
        "Product_ID",
        SUM(sales) AS total_sales,
        SUM(profit) AS total_profit,
        ROUND(
            (SUM(profit) / NULLIF(SUM(sales), 0) * 100)::numeric,
            2
        ) AS profit_margin
    FROM store_sales_data
    GROUP BY "Product_ID"
),
top_selling_products AS (
    SELECT *,
        NTILE(10) OVER (ORDER BY total_sales DESC) AS sales_decile
    FROM product_performance
)
SELECT
    "Product_ID",
    ROUND(total_sales::numeric, 2) AS total_sales,
    ROUND(total_profit::numeric, 2) AS total_profit,
    profit_margin
FROM top_selling_products
WHERE sales_decile = 1
ORDER BY profit_margin ASC
LIMIT 20;

-- Which products generate high profit even when they are discounted?

SELECT "Product_ID",
        discount,
        SUM(sales) AS total_sales,
        SUM(profit) AS total_profit,
        ROUND(
            (SUM(profit) / NULLIF(SUM(sales), 0) * 100)::numeric,
            2
        ) AS profit_margin
FROM store_sales_data
GROUP BY "Product_ID", discount
ORDER BY total_profit DESC, profit_margin DESC
LIMIT 20;

-- Does the best-performing discount differ between customer segments?

SELECT
    "Segment",
    discount,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    ROUND(
        (SUM(profit) / NULLIF(SUM(sales), 0) * 100)::numeric,
        2
    ) AS profit_margin,
    RANK() OVER (
        PARTITION BY "Segment"
        ORDER BY SUM(profit) DESC
    ) AS profit_rank
FROM store_sales_data
GROUP BY "Segment", discount
ORDER BY "Segment", profit_rank;

-- For each discount level, which customer segment generates the most total profit?

SELECT
    "Segment",
    discount,
    SUM(profit) AS total_profit,
    RANK() OVER (
        PARTITION BY discount
        ORDER BY SUM(profit) DESC
    ) AS profit_rank
FROM store_sales_data
GROUP BY "Segment", discount
ORDER BY discount, total_profit DESC;

-- Does the relationship between discount and profitability differ by region?

SELECT
    "Region",
    discount,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    ROUND(
        (SUM(profit) / NULLIF(SUM(sales), 0) * 100)::numeric,
        2
    ) AS profit_margin
FROM store_sales_data
GROUP BY "Region", discount
ORDER BY "Region", discount;

-- Rank the discounts within each region

SELECT
    "Region",
    discount,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    ROUND(
        (SUM(profit) / NULLIF(SUM(sales), 0) * 100)::numeric,
        2
    ) AS profit_margin,
    RANK() OVER (
        PARTITION BY "Region"
        ORDER BY SUM(profit) DESC
    ) AS profit_rank
FROM store_sales_data
GROUP BY "Region", discount
ORDER BY "Region", profit_rank;

-- Has the business been giving bigger or smaller discounts over time?

SELECT
    "Year",
    ROUND((AVG(discount) * 100)::numeric, 2) AS avg_discount_pct
FROM store_sales_data
GROUP BY "Year"
ORDER BY "Year";

-- How did profit margin change from 2019 to 2023?

SELECT "Year",
       SUM(sales) AS total_sales,
       SUM(profit) AS total_profit,
       ROUND(
        (SUM(profit) / NULLIF(SUM(sales), 0) * 100)::numeric,
        2
    ) AS profit_margin
FROM store_sales_data
GROUP BY "Year"
ORDER BY "Year";
