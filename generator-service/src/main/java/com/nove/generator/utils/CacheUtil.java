package com.nove.generator.utils;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import com.alibaba.fastjson.JSONArray;
import com.nove.generator.po.DatabasePo;

public class CacheUtil {

	private static Map<String, DatabasePo> cacheMap = new ConcurrentHashMap<>();

	public static void addSource(DatabasePo databasePo) {
		cacheMap.put(databasePo.getSourceName(), databasePo);
	}

	public static DatabasePo getSource(String sourceName) {
		return cacheMap.get(sourceName);
	}

	public static void delSource(String sourceName) {
		cacheMap.remove(sourceName);
	}

	public static String geyAllSource() {
		JSONArray jsonArray = new JSONArray();
		jsonArray.addAll(cacheMap.values());
		return jsonArray.toJSONString();

	}

}
