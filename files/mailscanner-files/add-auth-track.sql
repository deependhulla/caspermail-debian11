CREATE TABLE IF NOT EXISTS mailscanner.`maillog_auth` (
  `mail_id` varchar(200) NOT NULL,
  `auth_type` varchar(50) NOT NULL,
  `clientauth` varchar(250) NOT NULL,
  UNIQUE KEY `mail_id` (`mail_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
COMMIT;

