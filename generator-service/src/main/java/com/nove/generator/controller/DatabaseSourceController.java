package com.nove.generator.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.nove.generator.commons.JdbcUtil;
import com.nove.generator.po.DatabasePo;
import com.nove.generator.utils.CacheUtil;

@RestController
public class DatabaseSourceController {

	private static Logger log = LoggerFactory.getLogger(DatabaseSourceController.class);

	@RequestMapping("/getAllSource")
	public String getAllSource() {

		return CacheUtil.geyAllSource();
	}

	@RequestMapping("/saveSource")
	public String saveSource(@RequestBody DatabasePo databasePo) {

		CacheUtil.addSource(databasePo);
		return "SUCCESS";
	}

	@RequestMapping("/delSource")
	public String delSource(@RequestParam String sourceName) {
		CacheUtil.delSource(sourceName);
		return "SUCCESS";
	}

	/**
	 * 测试连接数据源
	 * 
	 * @return
	 */
	@RequestMapping("/testConnect")
	public boolean testConnect(@RequestParam String sourceName) {

		return JdbcUtil.testConnection(CacheUtil.getSource(sourceName));
	}

}
