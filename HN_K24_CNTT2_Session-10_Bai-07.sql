USE social_network_pro;

-- 2) Tạo một view với tên view_user_activity_status hiển thị các cột:  user_id , username, gender, created_at, status. Trong đó status được xác định như sau: 
-- "Active" nếu người dùng có ít nhất 1 bài viết hoặc 1 bình luận.
-- "Inactive" nếu người dùng không có bài viết và không có bình luận.
CREATE OR REPLACE VIEW view_user_activity_status AS
SELECT 
    u.user_id, 
    u.username, 
    u.gender, 
    u.created_at,
    CASE 
        WHEN u.user_id IN (SELECT user_id FROM posts) 
         OR u.user_id IN (SELECT user_id FROM comments)
        THEN 'Active'
        ELSE 'Inactive'
    END AS status
FROM users u;
-- 3) Truy vấn view view_user_activity_status và kiểm tra kết quả thu được. Dưới đây là bảng kết quả tượng trưng:
SELECT * FROM view_user_activity_status;

-- 4)Truy vấn view view_user_activity_status để thống kê số lượng người dùng theo từng trạng thái (Active, Inactive). Thông tin bao gồm: Tên trạng thái (status) và Số lượng người dùng (user_count), sắp xếp theo số lượng người dùng giảm dần.
SELECT 
    status, 
    COUNT(user_id) AS user_count
FROM view_user_activity_status
GROUP BY status
ORDER BY user_count DESC;




