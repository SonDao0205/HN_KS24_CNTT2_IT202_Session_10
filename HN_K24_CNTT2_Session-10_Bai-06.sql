USE social_network_pro;

-- 2) Tạo một view tên view_users_summary để thống kê số lượng bài viết của từng người dùng.user_id (Mã người dùng), username (Tên người dùng), 
-- total_posts (Tổng số lượng bài viết của người dùng)
CREATE VIEW view_users_summary AS
SELECT 
    u.user_id, 
    u.username, 
    COUNT(p.post_id) AS total_posts
FROM users u
LEFT JOIN posts p ON u.user_id = p.user_id
GROUP BY u.user_id, u.username;

-- 3) Truy vấn từ view_users_summary để hiển thị các thông tin về user_id, username và total_posts của các người dùng có total_posts lớn hơn 5.
SELECT 
    user_id, 
    username, 
    total_posts
FROM view_users_summary
WHERE total_posts > 5;



 

