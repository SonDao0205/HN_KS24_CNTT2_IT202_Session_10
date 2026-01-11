-- 2) Viết câu truy vấn Select tìm tất cả những User ở Hà Nội. Sử dụng EXPLAIN ANALYZE để kiểm tra truy vấn thực tế.
EXPLAIN ANALYZE
SELECT *
FROM users
WHERE hometown = 'Hà Nội';


-- 3) Tạo một chỉ mục có tên idx_hometown cho cột hometown của bảng User. 
CREATE INDEX idx_hometown
ON users (hometown);


-- 4) Chạy lại yêu cầu số (2) với EXPLAIN ANALYZE để kiểm tra kết quả sau khi đánh chỉ mục . So sánh kết quả trước và sau khi đánh chỉ mục.
EXPLAIN ANALYZE
SELECT *
FROM users
WHERE hometown = 'Hà Nội';

-- trước : cost = 2.75
-- sau : cost = 1.43
-- kết luận : khi dùng index thì việc truy vấn dữ liệu sẽ nhanh hơn

-- 6) Hãy xóa chỉ mục idx_hometown khỏi bảng user.
DROP INDEX idx_hometown ON users;

