CREATE TABLE `user` (
`id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
`username` varchar(255) NOT NULL COMMENT '用户名',
`password` varchar(255) NOT NULL COMMENT '密码',
`nickname` varchar(255) NOT NULL COMMENT '昵称',
`avatar_url` varchar(255) NOT NULL COMMENT '头像',
`tel` varchar(255) DEFAULT NULL COMMENT '电话',
`email` varchar(255) DEFAULT NULL COMMENT '邮箱',
`status` varchar(255) NOT NULL COMMENT '状态',
`balance` int(11) NOT NULL COMMENT '余额',
`create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='普通用户';

CREATE TABLE `shop` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `username` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户名',
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '密码',
  `nickname` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '昵称',
  `avatar_url` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '头像',
  `tel` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '电话',
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '邮箱',
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '状态',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '名称',
  `fans_count` int(11) NOT NULL COMMENT '粉丝数量',
  `aptitude_imgs` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '资质',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='店铺';

CREATE TABLE `product_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '名称',
  `remark` text COLLATE utf8mb4_unicode_ci COMMENT '备注',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='商品分类';

CREATE TABLE `product_collect` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `product_id` int(11) NOT NULL COMMENT '商品',
  `user_id` int(11) NOT NULL COMMENT '用户',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='商品收藏';

CREATE TABLE `product_browsing_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `product_id` int(11) NOT NULL COMMENT '商品',
  `user_id` int(11) NOT NULL COMMENT '用户',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='商品浏览历史';

CREATE TABLE `product` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '名称',
  `main_img` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '封面图',
  `img_list` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '详细图片',
  `product_type_id` int(11) NOT NULL COMMENT '分类',
  `price` float NOT NULL COMMENT '价格',
  `stock` int(11) NOT NULL COMMENT '库存',
  `sales_volume` int(11) NOT NULL COMMENT '销量',
  `intro` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '简介',
  `shop_id` int(11) NOT NULL COMMENT '商家',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='商品信息';

CREATE TABLE `shipping_address` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '姓名',
  `tel` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '电话',
  `address` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '地址',
  `user_id` int(11) NOT NULL COMMENT '用户',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='收货地址';

CREATE TABLE `product_order` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `product_id` int(11) NOT NULL COMMENT '商品',
  `shop_id` int(11) NOT NULL COMMENT '店铺',
  `total_money` int(11) NOT NULL COMMENT '总金额',
  `quantity` int(11) NOT NULL COMMENT '数量',
  `user_id` int(11) NOT NULL COMMENT '用户',
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '状态',
  `consignee_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '收货人姓名',
  `consignee_tel` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '收货人电话',
  `consignee_address` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '收货人地址',
  `tracking_number` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '物流单号',
  `remark` text COLLATE utf8mb4_unicode_ci COMMENT '备注',
  `order_evaluate_id` int(11) DEFAULT NULL COMMENT '评价Id',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='商品订单';

CREATE TABLE `product_order_evaluate` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `user_id` int(11) NOT NULL COMMENT '用户',
  `product_id` int(11) NOT NULL COMMENT '商品',
  `product_order_id` int(11) NOT NULL COMMENT '订单',
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '内容',
  `rate` int(11) NOT NULL COMMENT '评分',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='订单评价';

CREATE TABLE `shop_collect` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `shop_id` int(11) NOT NULL COMMENT '店铺',
  `user_id` int(11) NOT NULL COMMENT '用户',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='店铺收藏';

CREATE TABLE `advertising` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `position` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '位置',
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标题',
  `link` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '链接',
  `main_img` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '封面图',
  `sort` int(11) NOT NULL COMMENT '排序',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='广告位';

CREATE TABLE `slideshow` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标题',
  `main_img` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '封面图',
  `link` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '链接',
  `sort` int(11) NOT NULL COMMENT '排序',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='轮播图';

DROP TABLE IF EXISTS `shopping_cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shopping_cart` (
                                 `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
                                 `product_id` int NOT NULL COMMENT '商品',
                                 `user_id` int NOT NULL COMMENT '用户',
                                 `quantity` int NOT NULL COMMENT '数量',
                                 `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                 PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='购物车';
/*!40101 SET character_set_client = @saved_cs_client */;

