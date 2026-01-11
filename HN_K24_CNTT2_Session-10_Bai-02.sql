-- Tạo một view tên view_user_post hiển thị danh sách các User với các cột: user_id(mã người dùng) và total_user_post (Tổng số bài viết mà từng người dùng đã đăng).
CREATE VIEW view_user_post AS
SELECT
    u.user_id,
    COUNT(p.post_id) AS total_user_post
FROM users u
LEFT JOIN posts p ON u.user_id = p.user_id
GROUP BY u.user_id;

-- Kết hợp view view_user_post với bảng users để hiển thị các cột: full_name(họ tên) và  total_user_post (Tổng số bài viết mà từng người dùng đã đăng).
SELECT
    u.full_name,
    v.total_user_post
FROM users u
JOIN view_user_post v ON u.user_id = v.user_id;

-- hiển thị view
SELECT * FROM view_user_post;

