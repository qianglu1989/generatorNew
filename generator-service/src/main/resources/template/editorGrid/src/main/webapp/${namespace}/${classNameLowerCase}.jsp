<%@ page language="java" contentType="text/html; charset=utf-8"%>
<#assign className = table.className>
<#assign classNameLower = className?lower_case>
<%@ include file="/common/include/taglib.jsp"%>
<G4Studio:html title="${table.tableAlias}lieb" >
<G4Studio:import src="/${namespace}/${classNameLower}.js"/>
<G4Studio:body>
</G4Studio:body>
</G4Studio:html>