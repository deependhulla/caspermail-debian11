use mailscanner;
DROP TABLE `mailscanner`.`mtalog`;
DROP TABLE `mailscanner`.`mtalog_ids`;

CREATE TABLE `mtalog` (
  `mtalog_id` bigint(20) UNSIGNED NOT NULL,
  `relay_date` date NOT NULL,
  `relay_time` time DEFAULT NULL,
  `host` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status_code` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `msg_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `to_address` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `relay_to` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dsn` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status_text` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `delay` time DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE `mtalog_ids` (
  `uid` bigint(20) NOT NULL,
  `smtpd_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `smtp_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


ALTER TABLE `mtalog`
  ADD PRIMARY KEY (`mtalog_id`),
  ADD UNIQUE KEY `mtalog_uniq` (`relay_time`,`host`(10),`status_code`(10),`msg_id`,`to_address`(20),`relay_to`) USING BTREE,
  ADD KEY `mtalog_timestamp` (`relay_time`),
  ADD KEY `mtalog_type` (`status_code`(10)),
  ADD KEY `msg_id` (`msg_id`),
  ADD KEY `realydate` (`relay_date`),
  ADD KEY `dsn` (`dsn`),
  ADD KEY `to_address` (`to_address`);

  
  ALTER TABLE `mtalog_ids`
    ADD PRIMARY KEY (`uid`),
    ADD UNIQUE KEY `mtalog_ids_idx` (`smtpd_id`,`smtp_id`),
    ADD KEY `smtpd_id` (`smtpd_id`);
   

ALTER TABLE `mtalog`
  MODIFY `mtalog_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;


ALTER TABLE `mtalog_ids`
  MODIFY `uid` bigint(20) NOT NULL AUTO_INCREMENT;


