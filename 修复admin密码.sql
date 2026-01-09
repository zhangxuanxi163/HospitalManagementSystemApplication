-- 修复admin用户密码（MD5加密）
-- 密码：admin123
-- MD5：0192023a7bbd73250516f069df18b500

USE hospital_db;

-- 更新admin用户密码
UPDATE users 
SET password='0192023a7bbd73250516f069df18b500', 
    status=1 
WHERE username='admin';

-- 如果admin用户不存在，创建新用户
INSERT INTO users (username, password, real_name, role, department, status) 
SELECT 'admin', '0192023a7bbd73250516f069df18b500', '系统管理员', 'admin', '信息科', 1
WHERE NOT EXISTS (SELECT 1 FROM users WHERE username='admin');

-- 查看结果
SELECT username, real_name, role, status FROM users WHERE username='admin';







