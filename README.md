# Pricing & Discount Impact Analysis

## Business Context

This project analyzes how discounting affects sales, transaction volume, total profit, profit per transaction, and profit margin in a retail business.

The goal is to understand the trade-off between **volume and profitability** and identify where discounts should be targeted rather than applied broadly.

**Dataset:** [Indian Store Data](https://www.kaggle.com/datasets/abuhumzakhan/store-data) — 100,000 retail sales records covering 2019–2023, with customer, regional, product, sales, discount, quantity, and profit fields. The dataset is provided under a CC0 license.

I built this project to answer a practical pricing question: **when a discount increases sales, is the business actually better off?** The most interesting result was that there was no single best discount across the business — the observed profit-maximizing level varied by customer segment and region, while very high discounts could increase total profit through volume but reduce margin and profit per transaction.

## Key Findings

### 1. Discounting creates a measurable margin trade-off

Profit margin fell from **20.01% with no discount to 11.97% in the Very High Discount bucket**, an **8.04 percentage-point decline** across the discount buckets.

### 2. Total profit can be misleading

Very high discounts generated higher total profit through transaction volume, but the same discount levels produced lower **profit margin and profit per transaction**. Looking at total profit alone can therefore lead to an overly aggressive discount strategy.

### 3. Discount sensitivity varies by category

The observed profit-margin loss between **0% and 50% discount** ranged from approximately **8.9 to 10.7 percentage points**, showing that some categories are more sensitive to discounting than others.

### 4. Small discounts are more defensible than blanket high discounts

The dashboard identified **1%–5%** as the general observed/recommended range for most situations, while allowing exceptions where category, segment, or regional results support a different level.

### 5. Discount performance varies by customer and region

The observed profit-maximizing discounts were **5% for Consumer vs 1% for Corporate**, and **1% North, 2% East, 5% South, and 8% West**. This supports a more targeted pricing strategy rather than one universal discount.

## Business Recommendation

> **Use small, targeted discounts rather than blanket high discounts. Prioritize profit margin and profit per transaction over total profit alone.**

Allow discount levels to vary by category, customer segment, and region where the historical data supports it. Proposed pricing changes should be validated with controlled testing before full rollout because this analysis is **observational, not causal**.

## Executive KPI Snapshot

| KPI | Value |
|---|---:|
| Total Sales | 2.51B |
| Total Profit | 375.53M |
| Profit Margin | 14.97% |
| Average Discount | 25.13% |
| Profit / Transaction | 3.76K |

## Dashboard Preview

The Power BI report contains five pages designed to move from overall performance to detailed pricing decisions.

### 1. Executive Pricing Overview

![Executive Pricing Overview](screenshots/executive-pricing-overview.png)

Provides the high-level business view using Total Sales, Total Profit, Profit Margin %, Average Discount %, Profit per Transaction, Profit Margin by Discount Bucket, and Average Discount % vs Profit Margin % by Year.

### 2. Discount Impact Analysis

![Discount Impact Analysis](screenshots/discount-impact-analysis.png)

Examines how increasing discounts affect profit margin, profit per transaction, transaction count, and total profit.

### 3. Category & Product Pricing Analysis

![Category & Product Pricing Analysis](screenshots/category-product-pricing-analysis.png)

Drills into pricing behavior by category and product, including observed best-profit discount by category, profit-margin loss from 0% to 50% discount, high-selling products with weak margins, and high-profit product/discount combinations.

### 4. Customer & Regional Analysis

![Customer & Regional Analysis](screenshots/customer-regional-analysis.png)

Tests whether discount performance differs by customer segment and geography.

### 5. Executive Pricing Recommendations

![Executive Pricing Recommendations](screenshots/executive-pricing-recommendations.png)

Translates the analysis into an actionable pricing strategy.

## Tools Used

- **PostgreSQL / SQL** — business analysis, aggregation, ranking, CTEs, window functions, and profitability analysis
- **Power BI** — dashboard development and executive reporting
- **DAX** — KPI measures and analytical calculations
- **Power Query** — data preparation and transformation

## Project Structure

```text
Pricing-Discount-Impact-Analysis/
│
├── Pricing & Discount Impact Analysis.pbix
├── sql/
│   └── pricing_discount_impact_analysis.sql
├── screenshots/
│   ├── executive-pricing-overview.png
│   ├── discount-impact-analysis.png
│   ├── category-product-pricing-analysis.png
│   ├── customer-regional-analysis.png
│   └── executive-pricing-recommendations.png
├── README.md
└── LICENSE
```

## How to Reproduce

1. Download the [Indian Store Data](https://www.kaggle.com/datasets/abuhumzakhan/store-data) dataset and load it into PostgreSQL as `store_sales_data`.
2. Open `sql/pricing_discount_impact_analysis.sql` and run the analysis queries in PostgreSQL.
3. Open the `.pbix` file in Power BI Desktop.
4. Refresh the data connection/model and review the five dashboard pages.

## SQL Analysis

The `sql/pricing_discount_impact_analysis.sql` file contains the analysis used to investigate:

- Discount vs profit margin
- Discount vs total sales and total profit
- Profit per transaction
- Transaction-volume changes by discount
- Category-level discount profitability
- Margin loss from 0% to 50% discount
- Category-specific best-profit discounts
- High-selling products with weak margins
- High-profit product/discount combinations
- Segment-level discount profitability
- Region-level discount profitability
- Year-level discount and margin trends

Key SQL techniques include `RANK()`, `ROW_NUMBER()`, `NTILE()`, `LAG()`, CTEs, aggregation, conditional bucketing, and profitability calculations.

## Author

**Rai-da**  
Data Analytics / Business Intelligence Portfolio Project
