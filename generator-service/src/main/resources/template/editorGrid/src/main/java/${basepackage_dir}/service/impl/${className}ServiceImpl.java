<#include "/java_copyright.include">
<#assign className = table.className>   
<#assign classNameLower = className?uncap_first>
<#if table.pkCount gt 1>
<#assign classType = "${className}Id">
<#else>
<#assign classType = table.pkColumn.simpleJavaType>
</#if>
package ${basepackage}.service.impl;

import com.common.base.EntityDao;
import com.common.utils.CountOrder;
import ${basepackage}.dao.${className}Dao;
import ${basepackage}.po.${className};
<#if table.pkCount gt 1>
import ${basepackage}.po.${className}Id;
</#if>
import ${basepackage}.service.${className}Service;
import ${basepackage}.vo.${className}Query;
import org.springframework.stereotype.Service;
import com.common.base.BaseServiceImpl;

import java.util.List;

@Service("${classNameLower}Service")
public class ${className}ServiceImpl extends BaseServiceImpl<${className},${classType}> implements ${className}Service{

	private ${className}Dao ${classNameLower}Dao;
	/**增加setXXXX()方法,spring就可以通过autowire自动设置对象属性,请注意大小写*/
	public void set${className}Dao(${className}Dao dao) {
		this.${classNameLower}Dao = dao;
	}
	public EntityDao getEntityDao() {
		return this.${classNameLower}Dao;
	}

    public List<${className}> search${className}(${className}Query ${classNameLower},CountOrder countOrder){
        return ${classNameLower}Dao.search${className}(${classNameLower},countOrder);
    }

    public Long count${className}(${className}Query ${classNameLower}){
        return ${classNameLower}Dao.count${className}(${classNameLower});
    }

}
