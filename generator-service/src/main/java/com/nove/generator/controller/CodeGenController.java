package com.nove.generator.controller;

import java.sql.SQLException;
import java.util.LinkedHashSet;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

import cn.org.rapid_framework.generator.GeneratorFacade;
import cn.org.rapid_framework.generator.provider.db.table.TableFactory;
import cn.org.rapid_framework.generator.provider.db.table.model.Column;
import cn.org.rapid_framework.generator.provider.db.table.model.Table;

/**
 * 数据库操作
 * 
 * @author QIANG
 *
 */
@RestController
public class CodeGenController {
	private static Logger logger = LoggerFactory.getLogger(CodeGenController.class);

	/**
	 * 数据库表展现
	 * 
	 * @return
	 */
	@RequestMapping("/dbTree")
	public String dbTree() {
		List<Table> tables = TableFactory.getInstance().getAllTables();
		JSONArray jsonArray = new JSONArray();
		for (Table table : tables) {
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("tableName", table.getSqlName());
			jsonArray.add(jsonObject);
		}
		return jsonArray.toJSONString();
	}

	/**
	 * 展现一张表的列
	 * 
	 * @return
	 * @throws SQLException
	 */
	@RequestMapping("/dbColumn")
	public String dbColumn(@RequestParam String tableName) {
		if (StringUtils.isEmpty(tableName))
			return null;
		Table table = TableFactory.getInstance().getTable(tableName);
		LinkedHashSet<Column> cloumns = table.getColumns();
		JSONArray jsonArray = new JSONArray();
		for (Column columnWeb : cloumns) {
			JSONObject object = new JSONObject();
			object.put("name", columnWeb.getSqlName());
			object.put("remark", columnWeb.getRemarks());
			object.put("type", columnWeb.getSimpleJavaType());
			object.put("size", columnWeb.getSize());
			object.put("pk", columnWeb.isPk());
			object.put("dbType", columnWeb.getSqlTypeName());
			jsonArray.add(object);
		}
		return jsonArray.toJSONString();
	}

	/**
	 * 生成数据
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/generator")
	public String generator(@RequestParam List<String> tables, HttpServletRequest request) throws Exception {

		GeneratorFacade g = new GeneratorFacade();

		g.deleteOutRootDir();// 删除生成器的输出目录
		PathMatchingResourcePatternResolver resourceLoader = new PathMatchingResourcePatternResolver();
		Resource resource = resourceLoader.getResource("classpath:/template/oms_mybatis/macro.include");
		String templateRootDir = resource.getFile().getAbsolutePath();
		String[] path = templateRootDir.split("macro.include");
		g.generateByTables(tables, path[0]);
		return "SUCCESS";
	}

}
