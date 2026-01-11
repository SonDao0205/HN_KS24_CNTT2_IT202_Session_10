-- ==============================
-- DATABASE: Social Network Mini Project
-- TOPIC: VIEW & INDEX (MySQL)
-- ==============================

DROP DATABASE IF EXISTS social_network;
CREATE DATABASE social_network;
USE social_network;

-- ==============================
-- 1. TABLE: users
-- ==============================
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ==============================
-- 2. TABLE: posts
-- ==============================
CREATE TABLE posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    content TEXT,
    privacy ENUM('PUBLIC', 'FRIEND', 'PRIVATE') DEFAULT 'PUBLIC',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- ==============================
-- 3. TABLE: comments
-- ==============================
CREATE TABLE comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    content TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES posts(post_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- ==============================
-- 4. TABLE: likes
-- ==============================
CREATE TABLE likes (
    like_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES posts(post_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- ==============================
-- INSERT SAMPLE DATA
-- ==============================

-- Users
INSERT INTO users (username, email, phone) VALUES
('alice', 'alice@gmail.com', '0901111111'),
('bob', 'bob@gmail.com', '0902222222'),
('charlie', 'charlie@gmail.com', '0903333333'),
('david', 'david@gmail.com', '0904444444');

-- Posts
INSERT INTO posts (user_id, content, privacy, created_at) VALUES
(1, 'Hello world from Alice', 'PUBLIC', '2024-01-10'),
(2, 'Bob private post', 'PRIVATE', '2024-02-01'),
(3, 'Charlie public sharing', 'PUBLIC', '2024-03-05'),
(1, 'Alice friend-only post', 'FRIEND', '2024-03-20'),
(4, 'David public post', 'PUBLIC', '2024-04-01');

-- Comments
INSERT INTO comments (post_id, user_id, content) VALUES
(1, 2, 'Nice post!'),
(1, 3, 'Welcome Alice'),
(3, 1, 'Good content'),
(5, 2, 'Great post David');

-- Likes
INSERT INTO likes (post_id, user_id) VALUES
(1, 2),
(1, 3),
(3, 1),
(3, 2),
(5, 1),
(5, 3);

-- ==============================
-- END OF FILE
-- ==============================

-- Câu 1. View hồ sơ người dùng công khai
CREATE VIEW view_public_profile AS
SELECT username, email, created_at
FROM users;

-- Kiểm tra
SELECT * FROM view_public_profile;

-- Câu 2. View News Feed bài viết công khai
CREATE VIEW view_news_feed AS
SELECT 
    u.username AS author, 
    p.content, 
    p.created_at, 
    COUNT(l.like_id) AS total_likes
FROM posts p
JOIN users u ON p.user_id = u.user_id
LEFT JOIN likes l ON p.post_id = l.post_id
WHERE p.privacy = 'PUBLIC'
GROUP BY p.post_id;

-- Kiểm tra
SELECT * FROM view_news_feed;

-- Câu 3. View có CHECK OPTION
CREATE VIEW view_public_posts_check AS
SELECT post_id, user_id, content, privacy
FROM posts
WHERE privacy = 'PUBLIC'
WITH CHECK OPTION;

-- Thử nghiệm hợp lệ: Thành công
INSERT INTO view_public_posts_check (user_id, content, privacy) 
VALUES (1, 'Test Public Post', 'PUBLIC');

-- Thử nghiệm không hợp lệ: Sẽ báo lỗi "CHECK OPTION failed"
-- INSERT INTO view_public_posts_check (user_id, content, privacy) 
-- VALUES (1, 'Test Private Post', 'PRIVATE');

-- Câu 4. Phân tích truy vấn News Feed
EXPLAIN SELECT * FROM posts WHERE privacy = 'PUBLIC' ORDER BY created_at DESC;

-- Câu 5. Tạo INDEX tối ưu
-- Index tăng tốc News Feed (Kết hợp lọc privacy và sắp xếp thời gian)
CREATE INDEX idx_privacy_created ON posts(privacy, created_at);

-- Index tăng tốc truy vấn lấy bài viết theo người dùng
CREATE INDEX idx_user_id ON posts(user_id);

-- So sánh lại bằng EXPLAIN
EXPLAIN SELECT * FROM posts WHERE privacy = 'PUBLIC' ORDER BY created_at DESC;

-- Câu 6. Phân tích hạn chế của INDEX
-- 1. Khi nào không nên tạo index?
-- Khi bảng có dữ liệu quá ít (tra cứu trực tiếp nhanh hơn tra cứu index).
-- Trên các cột có độ chọn lọc thấp (ví dụ: cột gender chỉ có Nam/Nữ).
-- Trên các bảng thường xuyên cập nhật/xóa dữ liệu liên tục.
-- 2. Vì sao không nên index cột nội dung bài viết (content)?
-- Cột content thường là kiểu dữ liệu TEXT (độ dài lớn). Việc index toàn bộ văn bản này gây tốn bộ nhớ lưu trữ cực lớn và làm chậm hiệu năng.
-- Giải pháp thay thế: Sử dụng FULLTEXT INDEX nếu cần tìm kiếm từ khóa bên trong nội dung.
-- 3. Index ảnh hưởng thế nào đến thao tác INSERT / UPDATE?
-- Làm chậm quá trình ghi dữ liệu. Mỗi khi thêm mới hoặc sửa đổi một dòng, hệ thống không chỉ cập nhật bảng chính mà còn phải tính toán và cập nhật lại tất cả các cây chỉ mục liên quan.