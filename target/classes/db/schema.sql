-- 医院信息管理系统数据库设计
-- 创建数据库
CREATE DATABASE IF NOT EXISTS hospital_db DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE hospital_db;

-- 用户表
CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '用户ID',
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    password VARCHAR(255) NOT NULL COMMENT '密码',
    real_name VARCHAR(50) COMMENT '真实姓名',
    role VARCHAR(20) DEFAULT 'user' COMMENT '角色：admin-管理员, user-普通用户',
    department VARCHAR(100) COMMENT '部门',
    phone VARCHAR(20) COMMENT '联系电话',
    status TINYINT DEFAULT 1 COMMENT '状态：1-启用, 0-禁用',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 物资分类表
CREATE TABLE IF NOT EXISTS material_categories (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '分类ID',
    category_name VARCHAR(50) NOT NULL COMMENT '分类名称',
    description TEXT COMMENT '分类描述',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='物资分类表';

-- 供应商表
CREATE TABLE IF NOT EXISTS suppliers (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '供应商ID',
    supplier_name VARCHAR(100) NOT NULL COMMENT '供应商名称',
    contact_person VARCHAR(50) COMMENT '联系人',
    phone VARCHAR(20) COMMENT '联系电话',
    email VARCHAR(100) COMMENT '邮箱',
    address TEXT COMMENT '地址',
    status TINYINT DEFAULT 1 COMMENT '状态：1-启用, 0-禁用',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='供应商表';

-- 物资表
CREATE TABLE IF NOT EXISTS materials (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '物资ID',
    material_code VARCHAR(50) NOT NULL UNIQUE COMMENT '物资编码',
    material_name VARCHAR(100) NOT NULL COMMENT '物资名称',
    category_id INT COMMENT '分类ID',
    unit VARCHAR(20) COMMENT '单位',
    specification VARCHAR(100) COMMENT '规格',
    price DECIMAL(10, 2) DEFAULT 0.00 COMMENT '单价',
    supplier_id INT COMMENT '供应商ID',
    description TEXT COMMENT '物资描述',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (category_id) REFERENCES material_categories(id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='物资表';

-- 库存表
CREATE TABLE IF NOT EXISTS inventory (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '库存ID',
    material_id INT NOT NULL COMMENT '物资ID',
    quantity INT NOT NULL DEFAULT 0 COMMENT '库存数量',
    min_stock INT DEFAULT 0 COMMENT '最低库存',
    max_stock INT DEFAULT 0 COMMENT '最高库存',
    location VARCHAR(100) COMMENT '存放位置',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (material_id) REFERENCES materials(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='库存表';

-- 入库记录表
CREATE TABLE IF NOT EXISTS stock_in (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '入库ID',
    material_id INT NOT NULL COMMENT '物资ID',
    quantity INT NOT NULL COMMENT '入库数量',
    operator_id INT COMMENT '操作员ID',
    supplier_id INT COMMENT '供应商ID',
    in_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '入库日期',
    batch_no VARCHAR(50) COMMENT '批次号',
    remark TEXT COMMENT '备注',
    FOREIGN KEY (material_id) REFERENCES materials(id),
    FOREIGN KEY (operator_id) REFERENCES users(id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='入库记录表';

-- 出库记录表
CREATE TABLE IF NOT EXISTS stock_out (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '出库ID',
    material_id INT NOT NULL COMMENT '物资ID',
    quantity INT NOT NULL COMMENT '出库数量',
    operator_id INT COMMENT '操作员ID',
    department VARCHAR(100) COMMENT '领用部门',
    recipient VARCHAR(50) COMMENT '领用人',
    out_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '出库日期',
    purpose TEXT COMMENT '用途说明',
    remark TEXT COMMENT '备注',
    FOREIGN KEY (material_id) REFERENCES materials(id),
    FOREIGN KEY (operator_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='出库记录表';

-- 初始化数据
-- 插入默认管理员用户（密码：admin123）
INSERT INTO users (username, password, real_name, role, department) VALUES
('admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iwK8pJwC', '系统管理员', 'admin', '信息科');

-- 插入物资分类
INSERT INTO material_categories (category_name, description) VALUES
('医疗设备', '各类医疗设备及器械'),
('药品', '各类药品及药剂'),
('耗材', '一次性医疗耗材'),
('办公用品', '办公用品及文具');

-- 插入示例供应商
INSERT INTO suppliers (supplier_name, contact_person, phone, address) VALUES
('医疗设备有限公司', '张经理', '13800138000', '北京市朝阳区xxx路xxx号'),
('药品供应商', '李经理', '13900139000', '上海市浦东新区xxx路xxx号');

