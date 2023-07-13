-- 1 +
SELECT id, fullname, SUM (o.books_count) AS sum_books
FROM readers AS r JOIN orders AS o ON r.id = o.reader_id
WHERE o.return_date IS NOT NULL
GROUP BY r.id
ORDER BY o.books_count DESC

-- 2
SELECT SUM (books_count) AS sum_books
FROM orders
WHERE date IN (SELECT CURRENT_DATE) AND return_date IS NULL

-- 3
SELECT fullname 
FROM readers r
RIGHT JOIN orders o ON r.id = o.reader_id
LEFT JOIN books b ON o.book_id = b.id
WHERE b.title == 'Определённая книга' AND o.return_date IS NULL

-- 4
SELECT b.title, SUM (o.books_count) AS receipted
FROM books AS b
JOIN orders AS o ON b.id = o.book_id
WHERE o.return_date IS NULL
GROUP BY b.title

-- 5
SELECT DISTINCT COUNT(id), (EXTRACT (DAY FROM (CURRENT_DATE) - receipt_date)) AS days_diff
FROM readers
WHERE days_diff > 14

-- 6
SELECT company 
FROM publisher AS p
JOIN books AS b ON p.id = b.publisher_id
JOIN orders AS o ON b.id = o.book_id
ORDER BY SUM(o.books_count) DESC

--7
SELECT p.fullname AS author
FROM author AS a
JOIN book_author AS ba ON a.id = ba.author_id
JOIN books b ON ba.book_id = b.id
ORDER BY COUNT(b.count) DESC
LIMIT 1

-- 8
SELECT 
   ((SELECT SUM(books_count) / (SELECT SUM(pages_count) FROM books b)) AS total_pages)/
      (SUM(EXTRACT(DAY FROM o.return_date - o.receipt_date) OVER () AS total_days))
AS avg_pages_read
FROM orders AS o 
JOIN books AS b ON o.book_id = b.id 