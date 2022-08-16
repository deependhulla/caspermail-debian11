
CREATE TABLE `imageviewdata` (
  `uid` bigint(20) NOT NULL,
  `msg_id` varchar(255) NOT NULL DEFAULT '',
  `mail_id` varchar(150) NOT NULL DEFAULT '',
  `maildatetime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `viewdatetime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `mobile` tinyint(4) NOT NULL,
  `jsondeviceinfo` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


ALTER TABLE `imageviewdata`
  ADD PRIMARY KEY (`uid`),
  ADD KEY `mail_id` (`mail_id`),
  ADD KEY `msg_id` (`msg_id`) USING BTREE;


ALTER TABLE `imageviewdata`
  MODIFY `uid` bigint(20) NOT NULL AUTO_INCREMENT;
COMMIT;


