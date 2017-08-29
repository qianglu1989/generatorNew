<#include "/macro.include"/>
<#assign className = table.className>
<#assign classNameLower = className?uncap_first>
<?xml version="1.0" encoding="GBK"?>
<!DOCTYPE sqlMap PUBLIC "-//ibatis.apache.org//DTD SQL Map 2.0//EN" "http://ibatis.apache.org/dtd/sql-map-2.dtd">

<!--<#macro namespace>${className}.</#macro>-->

<!-- 不使用namespace是由于sql搜索定位会比较方便 -->
<sqlMap>
    <typeAlias alias="dto" type="org.eredlab.g4.ccl.datastructure.impl.BaseDto"/>

    <insert id="save${className}" parameterClass="dto">
        <![CDATA[
        INSERT INTO ${table.sqlName} (
    <#list table.columns as column>
    ${column.sqlName} <#if column_has_next>,</#if>
    </#list>
        ) VALUES (
    <#list table.columns as column>
        #${column.columnNameLower}# <#if column_has_next>,</#if>
    </#list>
        )
        ]]>
    </insert>

    <update id="update${className}" parameterClass="dto">
        <![CDATA[
        UPDATE ${table.sqlName} SET
    <#list table.notPkColumns as column>
    ${column.sqlName} = #${column.columnNameLower}# <#if column_has_next>,</#if>
    </#list>
        WHERE
    <#list table.compositeIdColumns as column>
    ${column.sqlName} = #${column.columnNameLower}# <#if column_has_next> AND </#if>
    </#list>
        ]]>
    </update>

    <delete id="delete${className}" parameterClass="map">
        <![CDATA[
        DELETE FROM ${table.sqlName} WHERE
    <#list table.compositeIdColumns as column>
    ${column.sqlName} = #${column.columnNameLower}# <#if column_has_next> AND </#if>
    </#list>
        ]]>
    </delete>

    <!-- 用于select查询公用抽取的列 -->
    <sql id="${className}columns">
        <![CDATA[
    <#list table.columns as column>${column.sqlName} as ${column.columnNameLower}<#if column_has_next>,</#if></#list>
        ]]>
    </sql>

    <select id="get${className}ById" parameterClass="map" resultClass="dto">
        SELECT
        <include refid="${className}columns"/>
        <![CDATA[
        FROM ${table.sqlName}
        WHERE
    <#list table.compositeIdColumns as column>
    ${column.sqlName} = #${column.columnNameLower}# <#if column_has_next> AND </#if>
    </#list>
        ]]>
    </select>

    <sql id="${className}where">
        <dynamic prepend="WHERE">
        <#list table.columns as column>
            <#if column.isDateTimeColumn>
                <isNotEmpty prepend="AND" property="${column.columnNameLowerCase}begin">
                ${column.sqlName} >= #${column.columnNameLowerCase}begin#
                </isNotEmpty>
                <isNotEmpty prepend="AND" property="${column.columnNameLowerCase}end">
                ${column.sqlName} &lt;= #${column.columnNameLowerCase}end#
                </isNotEmpty>
                <#elseif column.isNumberColumn>
                    <isNotEmpty prepend="AND" property="${column.columnNameLowerCase}">
                    ${column.sqlName} = #${column.columnNameLowerCase}#
                    </isNotEmpty>
                <#else>
                    <isNotEmpty prepend="AND" property="${column.columnNameLowerCase}">
                    ${column.sqlName} like '%$${column.columnNameLowerCase}$%'
                    </isNotEmpty>
            </#if>
        </#list>
        </dynamic>
    </sql>

    <select id="count${className}" resultClass="java.lang.Integer">
        SELECT count(*) FROM ${table.sqlName}
        <include refid="${className}where"/>
    </select>

    <select id="query${className}" parameterClass="map" resultClass="dto">
        SELECT
        <include refid="${className}columns"/>
        FROM ${table.sqlName}
        <include refid="${className}where"/>
        <isNotEmpty property="sortColumns">
            ORDER BY $sortColumns$
        </isNotEmpty>
    </select>

</sqlMap>

