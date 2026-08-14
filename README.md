# Pricing & Discount Impact Analysis

## Business Context

This project analyzes how discounting affects sales, transaction volume, total profit, profit per transaction, and profit margin in a retail business.

The objective is not simply to find the discount that generates the highest sales or total profit. It is to understand the trade-off between **volume and profitability** and identify where discounts should be targeted rather than applied broadly.

## Tools Used

- **PostgreSQL / SQL** — business analysis, aggregation, ranking, CTEs, window functions, and profitability analysis
- **Power BI** — dashboard development and executive reporting
- **DAX** — KPI measures and analytical calculations
- **Power Query** — data preparation and transformation

## Project Structure

```text
Pricing-Discount-Impact-Analysis/
│
├── PowerBI/
│   └── Pricing & Discount Impact Analysis.pbix
│
├── sql/
│   └── pricing_discount_impact_analysis.sql
│
├── screenshots/
│   └── dashboard screenshots
│
├── README.md
└── LICENSE
```

## Executive KPI Snapshot

| KPI | Value |
|---|---:|
| Total Sales | 2.51B |
| Total Profit | 375.53M |
| Profit Margin | 14.97% |
| Average Discount | 25.13% |
| Profit / Transaction | 3.76K |

## Dashboard

The Power BI report contains five pages designed to move from overall performance to detailed pricing decisions.

### 1. Executive Pricing Overview

Provides the high-level business view using:

- Total Sales
- Total Profit
- Profit Margin %
- Average Discount %
- Profit per Transaction
- Profit Margin by Discount Bucket
- Average Discount % vs Profit Margin % by Year

### 2. Discount Impact Analysis

Examines how increasing discounts affect:

- Profit margin
- Profit per transaction
- Transaction count
- Total profit

The key tension is visible here: higher discounts can increase total profit through volume while simultaneously reducing margin and profit per transaction.

### 3. Category & Product Pricing Analysis

Drills into pricing behavior by product category and individual products, including:

- Observed best-profit discount by category
- Profit margin loss from 0% to 50% discount
- High-selling products with weak margins
- Highest-profit product / discount combinations

### 4. Customer & Regional Analysis

Tests whether discount performance differs by customer segment and geography.

Observed best-profit discount levels in the historical data were:

| Dimension | Observed best-profit discount |
|---|---:|
| Consumer | 5% |
| Corporate | 1% |
| North | 1% |
| East | 2% |
| South | 5% |
| West | 8% |

### 5. Executive Pricing Recommendations

Translates the analysis into an actionable pricing strategy:

- Use **small, targeted discounts** rather than blanket high discounts.
- Treat **1%–5%** as the general observed/recommended range for most situations rather than using high discounts universally.
- Allow **category, segment, and regional flexibility** where the historical data differs.
- Prioritize **profit margin and profit per transaction**, not total profit alone.
- Validate proposed pricing changes with controlled testing before full rollout.

## Key Findings

### 1. Discounting creates a clear margin trade-off

Profit margin declines as discount levels increase. The discount-bucket analysis shows a consistent downward relationship between discount intensity and margin.

### 2. Total profit can be misleading

Very high discounts can produce higher total profit because of transaction volume. That does **not** mean they are financially better on a per-sale basis. Profit margin and profit per transaction provide the counter-view.

### 3. Discount sensitivity is category-specific

The observed loss in profit margin from 0% to 50% discount differs by category, ranging from approximately **8.9 to 10.7 percentage points**.

### 4. Small discounts are more defensible than blanket high discounts

The analysis suggests that the business should capture volume with targeted low discounts while avoiding unnecessary margin erosion from aggressive blanket discounting.

### 5. The right discount differs by customer and region

The historical data does not support one universal discount level. Customer segment and regional results show different observed profit-maximizing discount levels.

## SQL Analysis

The `sql/pricing_discount_impact_analysis.sql` file contains the analysis used to investigate:

- Discount vs profit margin
- Discount vs total sales and total profit
- Profit per transaction
- Transaction volume changes by discount
- Category-level discount profitability
- Margin loss from 0% to 50% discount
- Category-specific best-profit discounts
- High-selling products with weak margins
- High-profit product / discount combinations
- Segment-level discount profitability
- Region-level discount profitability
- Year-level discount and margin trends

Window functions such as `RANK()`, `ROW_NUMBER()`, `NTILE()`, and `LAG()` were used where ranking or comparison across groups was required.

## Business Recommendation

The central recommendation from the analysis is:

> **Use small, targeted discounts rather than blanket high discounts. Prioritize margin and profit per transaction over total profit alone.**

The analysis should be interpreted as **observational**, not causal. A higher discount and higher/lower sales outcome do not by themselves prove that the discount caused the change. Controlled experiments or A/B tests would be required before making a causal pricing decision.

## Dashboard Preview

Dashboard screenshots can be added under `screenshots/` for quick portfolio viewing. The `.pbix` file contains the full interactive Power BI report.

## Author

**Rai-da**

Data Analytics / Business Intelligence Portfolio Project
