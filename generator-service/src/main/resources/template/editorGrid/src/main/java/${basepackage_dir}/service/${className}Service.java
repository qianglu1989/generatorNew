<#include "/java_copyright.include">
<#assign className = table.className>
<#assign classNameLower = className?uncap_first>
<#if table.pkCount gt 1>
<#assign classType = "${className}Id">
<#else>
<#assign classType = table.pkColumn.simpleJavaType>
</#if>
package ${basepackage}.service;

import com.common.base.BaseService;
import com.common.utils.CountOrder;
import ${basepackage}.po.${className};
<#if table.pkCount gt 1>
import ${basepackage}.po.${className}Id;
</#if>
import ${basepackage}.vo.${className}Query;

import java.util.List;

public interface ${className}Service extends BaseService<${className},${classType}>{

    List<${className}> search${className}(${className}Query ${classNameLower},CountOrder countOrder);

    Long count${className}(${className}Query ${classNameLower});

}