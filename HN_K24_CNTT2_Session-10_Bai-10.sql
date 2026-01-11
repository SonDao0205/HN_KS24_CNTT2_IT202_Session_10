USE social_network_pro;

-- 2)Tạo một chỉ mục (index) trên cột username của bảng users.
CREATE INDEX idx_username ON users(username);

-- 3)Tạo một View có tên view_user_activity_2 để thống kê tổng số bài viết (total_posts) và tổng số bạn bè (total_friends) của mỗi người dùng. Cột total_posts được tính dựa trên số lượng bản ghi trong bảng posts của mỗi người dùng. Cột total_friends được tính theo trạng thái kết bạn là accepted trong bảng friends.
CREATE VIEW view_user_activity_2 AS
SELECT 
    u.user_id,
    u.username,
    (SELECT COUNT(*) FROM posts p WHERE p.user_id = u.user_id) AS total_posts,
    (SELECT COUNT(*) FROM friends f 
     WHERE (f.user_id = u.user_id OR f.friend_id = u.user_id) 
     AND f.status = 'accepted') AS total_friends
FROM users u;

-- 4) Hiển thị lại view trên. 
SELECT * FROM view_user_activity_2;

-- 5)Viết một truy vấn kết hợp view_user_activity với bảng users để hiển thị danh sách người dùng (bao gồm full_name, total_posts, total_friends), chỉ bao gồm người dùng có total_posts > 0 (số bài viết lớn hơn 0), sắp xếp theo total_posts giảm dần (từ cao đến thấp).
-- Thêm một cột friend_description vào kết quả. Cột này chứa mô tả rút gọn về số bạn bè, cụ thể:
-- Nếu total_friends > 5, hiển thị "Nhiều bạn bè".
-- Nếu total_friends từ 2 đến 5, hiển thị "Vừa đủ bạn bè".
-- Nếu total_friends < 2, hiển thị "Ít bạn bè".
-- Thêm một cột post_activity_score (điểm hoạt động bài viết) với công thức:
-- Nếu total_posts > 10, post_activity_score = total_posts * 1.1 (tăng 10%).
-- Nếu total_posts từ 5 đến 10, post_activity_score = total_posts.
-- Nếu total_posts < 5, post_activity_score = total_posts * 0.9 (giảm 10%).
SELECT 
    u.full_name, 
    v.total_posts, 
    v.total_friends,
    CASE 
        WHEN v.total_friends > 5 THEN 'Nhiều bạn bè'
        WHEN v.total_friends BETWEEN 2 AND 5 THEN 'Vừa đủ bạn bè'
        ELSE 'Ít bạn bè'
    END AS friend_description,
    CASE 
        WHEN v.total_posts > 10 THEN v.total_posts * 1.1
        WHEN v.total_posts BETWEEN 5 AND 10 THEN v.total_posts
        ELSE v.total_posts * 0.9
    END AS post_activity_score
FROM users u
JOIN view_user_activity_2 v ON u.user_id = v.user_id
WHERE v.total_posts > 0
ORDER BY v.total_posts DESC;