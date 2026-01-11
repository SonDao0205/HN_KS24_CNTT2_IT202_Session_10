USE social_network_pro;
-- 2) Tạo một index idx_user_gender trên cột gender của bảng users.
CREATE INDEX idx_user_gender ON users(gender);

-- 3) Tạo một View tên view_popular_posts để lưu trữ post_id, username người đăng,content(Nội dung bài viết), số like, số comment (sử dụng JOIN giữa posts, users, likes, comments; GROUP BY post_id).
CREATE VIEW view_highly_interactive_users AS
SELECT 
    u.user_id, 
    u.username, 
    COUNT(c.comment_id) AS comment_count
FROM users u
JOIN comments c ON u.user_id = c.user_id
GROUP BY u.user_id, u.username
HAVING COUNT(c.comment_id) > 5;

-- 4) Truy vấn các thông tin của view view_popular_posts 
SELECT * FROM view_highly_interactive_users;

-- 5) viết query sử dụng View này để liệt kê các bài viết có số like + comment > 10, ORDER BY tổng tương tác giảm dần.
SELECT 
    v.username, 
    SUM(v.comment_count) AS sum_comment_user
FROM view_highly_interactive_users v
JOIN posts p ON v.user_id = p.user_id
GROUP BY v.username
ORDER BY sum_comment_user DESC; 