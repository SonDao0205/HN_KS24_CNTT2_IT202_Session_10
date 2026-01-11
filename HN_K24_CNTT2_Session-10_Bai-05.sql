DROP INDEX idx_hometown ON users;
-- 2) Tạo chỉ mục có tên idx_hometown trên cột hometown của bảng users
CREATE INDEX idx_hometown
ON users (hometown);

-- 3) Thực hiện truy vấn với các yêu cầu sau:
-- Viết một câu truy vấn để tìm tất cả các người dùng (users) có hometown là "Hà Nội"
EXPLAIN ANALYZE
SELECT
    u.username,
    p.post_id,
    p.content
FROM users u
JOIN posts p ON u.user_id = p.user_id
WHERE u.hometown = 'Hà Nội'
ORDER BY u.username DESC
LIMIT 10;

-- Kết hợp với bảng posts để hiển thị thêm post_id và content về các lần đăng bài. 
SELECT 
    u.username, 
    p.post_id, 
    p.content
FROM users u
JOIN posts p ON u.user_id = p.user_id
WHERE u.hometown = 'Hà Nội'
ORDER BY u.username DESC
LIMIT 10;

-- Sắp xếp danh sách theo username giảm dần và giới hạn kết quả chỉ hiển thị 10 bài đăng đầu tiên.
-- 4) Sử dụng EXPLAIN ANALYZE để kiểm tra lại kế hoạch thực thi trước và sau khi có chỉ mục.
EXPLAIN ANALYZE
SELECT
    u.username,
    p.post_id,
    p.content
FROM users u
JOIN posts p ON u.user_id = p.user_id
WHERE u.hometown = 'Hà Nội'
ORDER BY u.username DESC
LIMIT 10;

-- trước : cost = 7.62
-- sau : cost = 34.6

