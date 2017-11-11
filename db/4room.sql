/*
Navicat MySQL Data Transfer

Source Server         : localhost
Source Server Version : 50620
Source Host           : localhost:3306
Source Database       : 4room

Target Server Type    : MYSQL
Target Server Version : 50620
File Encoding         : 65001

Date: 2017-07-27 20:12:19
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for ar_internal_metadata
-- ----------------------------
DROP TABLE IF EXISTS `ar_internal_metadata`;
CREATE TABLE `ar_internal_metadata` (
  `key` varchar(255) NOT NULL,
  `value` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of ar_internal_metadata
-- ----------------------------
INSERT INTO `ar_internal_metadata` VALUES ('environment', 'development', '2017-06-13 09:51:06', '2017-06-13 09:53:39');

-- ----------------------------
-- Table structure for schema_migrations
-- ----------------------------
DROP TABLE IF EXISTS `schema_migrations`;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  PRIMARY KEY (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of schema_migrations
-- ----------------------------
INSERT INTO `schema_migrations` VALUES ('20170522070129');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(24) NOT NULL,
  `password` varchar(128) NOT NULL,
  `name` varchar(128) DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  `joined_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `salt` varchar(128) DEFAULT NULL,
  `last_login` varchar(45) DEFAULT NULL,
  `level` tinyint(4) DEFAULT NULL,
  `manager_id` int(11) DEFAULT NULL,
  `status` tinyint(4) DEFAULT '0',
  `job` varchar(256) DEFAULT NULL,
  `phone` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_name_UNIQUE` (`user_name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='Table account';

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES ('1', 'admin', '7c4a8d09ca3762af61e59520943dc26494f8941b', 'Super Admin', '1990-05-05', null, null, '2017-07-22 00:20:11', null, '2017-07-22', '1', null, '1', 'DEV', '0123456');

-- ----------------------------
-- Table structure for user_acl
-- ----------------------------
DROP TABLE IF EXISTS `user_acl`;
CREATE TABLE `user_acl` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `fk_user_role` int(10) unsigned NOT NULL,
  `fk_user_privilege` int(10) unsigned NOT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of user_acl
-- ----------------------------

-- ----------------------------
-- Table structure for user_component
-- ----------------------------
DROP TABLE IF EXISTS `user_component`;
CREATE TABLE `user_component` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_hungarian_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL COMMENT 'Component',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci;

-- ----------------------------
-- Records of user_component
-- ----------------------------
INSERT INTO `user_component` VALUES ('1', 'CMS', null);
INSERT INTO `user_component` VALUES ('2', 'Operation', null);

-- ----------------------------
-- Table structure for user_module
-- ----------------------------
DROP TABLE IF EXISTS `user_module`;
CREATE TABLE `user_module` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_hungarian_ci DEFAULT NULL,
  `fk_user_component` int(11) unsigned NOT NULL,
  `priority` tinyint(4) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL COMMENT 'module',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci;

-- ----------------------------
-- Records of user_module
-- ----------------------------
INSERT INTO `user_module` VALUES ('1', 'Administration', '1', '100', '0000-00-00 00:00:00');
INSERT INTO `user_module` VALUES ('2', 'User', '1', '100', '2017-06-27 06:36:37');

-- ----------------------------
-- Table structure for user_permission
-- ----------------------------
DROP TABLE IF EXISTS `user_permission`;
CREATE TABLE `user_permission` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `fk_user` int(10) unsigned NOT NULL,
  `fk_user_privilege` int(10) unsigned NOT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of user_permission
-- ----------------------------
INSERT INTO `user_permission` VALUES ('1', '1', '1', '2017-06-28 02:16:29');
INSERT INTO `user_permission` VALUES ('2', '1', '2', '2017-06-28 02:16:29');
INSERT INTO `user_permission` VALUES ('3', '1', '3', '2017-06-28 02:16:29');
INSERT INTO `user_permission` VALUES ('4', '1', '4', '2017-06-28 02:16:29');
INSERT INTO `user_permission` VALUES ('5', '1', '5', '2017-06-28 02:16:29');
INSERT INTO `user_permission` VALUES ('6', '1', '6', '2017-06-28 02:16:29');
INSERT INTO `user_permission` VALUES ('7', '1', '7', '2017-06-28 02:16:29');
INSERT INTO `user_permission` VALUES ('8', '1', '8', '2017-06-28 02:16:29');

-- ----------------------------
-- Table structure for user_privilege
-- ----------------------------
DROP TABLE IF EXISTS `user_privilege`;
CREATE TABLE `user_privilege` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `fk_user_resource` int(10) unsigned NOT NULL,
  `name` varchar(127) NOT NULL,
  `action` varchar(127) DEFAULT NULL,
  `active` tinyint(4) DEFAULT NULL,
  `priority` tinyint(4) DEFAULT NULL,
  `display` tinyint(4) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of user_privilege
-- ----------------------------
INSERT INTO `user_privilege` VALUES ('1', '1', 'Danh sach', 'index', '1', '100', '1', '2017-06-28 02:16:29', '2017-06-28 02:52:30');
INSERT INTO `user_privilege` VALUES ('2', '1', 'Them moi', 'new', '1', '100', '1', '2017-06-28 02:16:29', '2017-06-28 02:16:29');
INSERT INTO `user_privilege` VALUES ('3', '2', 'Danh sách', 'index', '1', '100', '1', '2017-06-28 04:52:11', '2017-06-28 04:52:11');
INSERT INTO `user_privilege` VALUES ('4', '2', 'Them moi', 'new', '1', '90', '1', '2017-07-22 07:44:46', '2017-07-22 07:44:48');
INSERT INTO `user_privilege` VALUES ('5', '3', 'Danh sach', 'index', '1', '100', '1', '2017-07-22 07:46:51', '2017-07-22 07:46:53');
INSERT INTO `user_privilege` VALUES ('6', '3', 'Them moi', 'new', '1', '90', '1', '2017-07-22 07:47:14', '2017-07-22 07:47:17');
INSERT INTO `user_privilege` VALUES ('7', '4', 'Danh sach', 'index', '1', '100', '1', '2017-07-22 10:04:13', '2017-07-22 10:04:17');
INSERT INTO `user_privilege` VALUES ('8', '4', 'Them moi', 'new', '1', '90', '1', '2017-07-22 10:04:43', '2017-07-22 10:04:47');

-- ----------------------------
-- Table structure for user_resource
-- ----------------------------
DROP TABLE IF EXISTS `user_resource`;
CREATE TABLE `user_resource` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(45) COLLATE utf8_hungarian_ci DEFAULT NULL,
  `controller` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `active` tinyint(4) DEFAULT NULL,
  `display` tinyint(4) DEFAULT NULL,
  `priority` tinyint(4) DEFAULT NULL,
  `fk_user_module` int(11) NOT NULL COMMENT 'Resource',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci;

-- ----------------------------
-- Records of user_resource
-- ----------------------------
INSERT INTO `user_resource` VALUES ('1', 'Module', 'module', '1', '1', '100', '1', '2017-07-22 10:03:18', '2017-07-22 10:03:20');
INSERT INTO `user_resource` VALUES ('2', 'Resource', 'resource', '1', '1', '90', '1', '2017-06-27 09:49:53', '2017-06-27 09:49:53');
INSERT INTO `user_resource` VALUES ('3', 'Quản trị người dùng', 'user', '1', '1', '100', '2', '2017-06-28 04:49:21', '2017-06-28 04:49:21');
INSERT INTO `user_resource` VALUES ('4', 'Privilege', 'privilege', '1', '1', '80', '1', '2017-07-22 10:03:08', '2017-07-22 10:03:10');

-- ----------------------------
-- Table structure for user_role
-- ----------------------------
DROP TABLE IF EXISTS `user_role`;
CREATE TABLE `user_role` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(256) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of user_role
-- ----------------------------
