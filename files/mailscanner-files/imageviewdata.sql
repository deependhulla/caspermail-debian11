
CREATE TABLE IF NOT EXISTS mailscanner.`imageviewdata` (
  `uid` bigint(20) NOT NULL AUTO_INCREMENT,
  `msg_id` varchar(255) NOT NULL DEFAULT '',
  `mail_id` varchar(150) NOT NULL DEFAULT '',
  `maildatetime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `viewdatetime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `mobile` tinyint(4) NOT NULL,
  `jsondeviceinfo` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`uid`),
  KEY `mail_id` (`mail_id`),
  KEY `msg_id` (`msg_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
COMMIT;
