USE social_network_pro;
-- 2)Tạo một index có tên idx_user_gender trên cột gender của bảng users:
CREATE INDEX idx_user_gender ON users(gender);

-- 3) Tạo một view tên view_user_activity để hiển thị tổng số lượng bài viết và bình luận của mỗi người dùng. Các cột trong view bao gồm: user_id (Mã người dùng), total_posts (Tổng số bài viết), total_comments (Tổng số bình luận).
CREATE VIEW view_user_activity AS
SELECT 
    u.user_id,
    (SELECT COUNT(*) FROM posts p WHERE p.user_id = u.user_id) AS total_posts,
    (SELECT COUNT(*) FROM comments c WHERE c.user_id = u.user_id) AS total_comments
FROM users u;

-- 4) Hiển thị lại view trên. 
SELECT * FROM view_user_activity;

-- 5) Viết truy vấn kết hợp view_user_activity với bảng users để lấy thông tin người dùng:
-- - Điều kiện: total_posts > 5 và total_comments > 20.
-- - Sắp xếp theo total_comments (Tổng số bình luận) giảm dần.
-- - Giới hạn kết quả hiển thị 5 bản ghi đầu tiên.
SELECT 
    u.user_id, 
    u.username, 
    u.full_name, 
    v.total_posts, 
    v.total_comments
FROM users u
JOIN view_user_activity v ON u.user_id = v.user_id
WHERE v.total_posts > 5 
  AND v.total_comments > 20
ORDER BY v.total_comments DESC
LIMIT 5;