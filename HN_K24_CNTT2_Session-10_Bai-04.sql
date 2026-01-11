-- 2) Tạo chỉ mục phức hợp (Composite Index)
-- Tạo một truy vấn để tìm tất cả các bài viết (posts) trong năm 2026 của người dùng có user_id là 1. Trả về các cột post_id, content, và created_at.
EXPLAIN ANALYZE
SELECT
    post_id,
    content,
    created_at
FROM posts
WHERE user_id = 1
  AND created_at >= '2026-01-01'
  AND created_at < '2027-01-01';

-- Tạo chỉ mục phức hợp với tên idx_created_at_user_id trên bảng posts sử dụng các cột created_at và user_id.
CREATE INDEX idx_created_at_user_id
ON posts (created_at, user_id);

-- Sử dụng EXPLAIN ANALYZE để kiểm tra kế hoạch thực thi của truy vấn trên trước và sau khi tạo chỉ mục idx_created_at_user_id. So sánh kết quả thực thi giữa hai lần này.
EXPLAIN ANALYZE
SELECT
    post_id,
    content,
    created_at
FROM posts
WHERE user_id = 1
  AND created_at >= '2026-01-01'
  AND created_at < '2027-01-01';

-- trước : cost = 3.56
-- sau : cost = 3.56
-- kết luận : khi dùng index hoặc không dùng thì vẫn cost bằng nhau

-- 3) Tạo chỉ mục duy nhất (Unique Index)
-- Tạo một truy vấn để tìm tất cả các người dùng (users) có email là 'an@gmail.com'. Trả về các cột user_id, username, và email.
EXPLAIN ANALYZE
SELECT
    user_id,
    username,
    email
FROM users
WHERE email = 'an@gmail.com';

-- Tạo chỉ mục duy nhất với tên idx_email trên cột email trong bảng users.
CREATE UNIQUE INDEX idx_email
ON users (email);

-- Sử dụng EXPLAIN ANALYZE để kiểm tra kế hoạch thực thi của truy vấn trên trước và sau khi tạo chỉ mục idx_email. So sánh kết quả thực thi giữa hai lần này.
EXPLAIN ANALYZE
SELECT
    user_id,
    username,
    email
FROM users
WHERE email = 'an@gmail.com';

-- kết luận : khi sử dụng index thì thời gian truy vấn sẽ nhanh hơn

-- 4) Xóa chỉ mục
-- Xóa chỉ mục idx_created_at_user_id khỏi bảng posts.
DROP INDEX idx_created_at_user_id ON posts;

-- Xóa chỉ mục idx_email khỏi bảng users.
DROP INDEX idx_email ON users;
