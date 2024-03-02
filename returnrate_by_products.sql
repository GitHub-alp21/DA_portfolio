-- Analyze return rates by product
-----------------------------------------------------
--CTE
WITH CTE
AS (
   --
   SELECT a.ProductKey,
          a.order_quantity,
          b.return_quantity
   FROM
   (
       -- Combine 3 sales tables with the same structure, then calculate the total order quantity by product key
       SELECT sales.productkey,
              SUM(sales.orderquantity) order_quantity
       FROM
       (
           SELECT *
           FROM sales2015
           UNION
           SELECT *
           FROM sales2016
           UNION
           SELECT *
           FROM sales2017
       ) AS sales
       GROUP BY sales.ProductKey
   ) a
       -- join with returns table
       LEFT JOIN
       -- Total number of returns by product key in 3 years
       (
           SELECT r.ProductKey,
                  SUM(r.returnquantity) return_quantity
           FROM returns r
           GROUP BY r.ProductKey
       ) b
           ON a.ProductKey = b.ProductKey)
-- join with products table
-- Calculate the return rate
SELECT CTE.ProductKey,
       p.ProductSKU,
       CTE.order_quantity,
       CTE.return_quantity,
       (CTE.return_quantity / CTE.order_quantity) AS return_rate
FROM CTE
    JOIN products p
        ON CTE.ProductKey = p.ProductKey;