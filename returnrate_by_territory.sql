-- Analyze return rates by territory
-----------------------------------------------------
--CTE
WITH CTE
AS (
   --
   SELECT a.TerritoryKey,
          a.order_quantity,
          b.return_quantity
   FROM
   (
       -- Combine 3 sales tables with the same structure, then calculate the total order quantity by territory key
       SELECT sales.TerritoryKey,
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
       GROUP BY sales.TerritoryKey
   ) a
       -- join with returns table
       LEFT JOIN
       -- Total number of returns by territory key in 3 years
       (
           SELECT r.TerritoryKey,
                  SUM(r.returnquantity) return_quantity
           FROM returns r
           GROUP BY r.TerritoryKey
       ) b
           ON a.TerritoryKey = b.TerritoryKey)
--join Territories table
SELECT CTE.TerritoryKey,
       t.Region,
       t.Country,
       CTE.order_quantity,
       CTE.return_quantity,
       (CTE.return_quantity / CTE.order_quantity) return_rate
FROM CTE
    LEFT JOIN Territories t
        ON CTE.TerritoryKey = t.SalesTerritoryKey;