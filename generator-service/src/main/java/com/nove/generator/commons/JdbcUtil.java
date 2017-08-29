package com.nove.generator.commons;

import java.sql.DriverManager;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.nove.generator.po.DatabasePo;

public class JdbcUtil {
	private static Logger log = LoggerFactory.getLogger(JdbcUtil.class);

	public static boolean testConnection(DatabasePo databasePo) {
		boolean isconnect = true;
		try {
			Class.forName(databasePo.getDriver());
			DriverManager.getConnection(databasePo.getUrl(), databasePo.getUsername(), databasePo.getPassword());
		} catch (Exception e) {
			log.error("测试连接失败,原因:{}", e);
			isconnect = false;

		}
		return isconnect;
	}
}
