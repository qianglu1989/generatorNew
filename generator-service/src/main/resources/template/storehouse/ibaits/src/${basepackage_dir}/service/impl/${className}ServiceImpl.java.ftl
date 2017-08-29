<#include "/java_copyright.include">
<#assign className = table.className>
<#assign classNameLower = className?uncap_first>
package ${basepackage}.service.impl;

import ${basepackage}.service.${className}Service;
import org.eredlab.g4.bmf.base.BaseServiceImpl;
import org.eredlab.g4.ccl.datastructure.Dto;
import org.eredlab.g4.ccl.id.util.IDHelper;


public class ${className}ServiceImpl extends BaseServiceImpl implements ${className}Service {

       public void saveOrUpdate${className}(Dto pDto){

           if(pDto.get("${table.compositeIdColumns[0].columnNameLower}")!=null)
             g4Dao.update("save${className}", pDto);
           else {
            <#list table.compositeIdColumns as column>
              pDto.put("${column.columnNameLower}",IDHelper.uuid());
            </#list>
           g4Dao.insert("save${className}", pDto);
        }
        }

       public void delete${className}(Dto pDto){
           g4Dao.delete("delete${className}", pDto);
        }

//       public  Dto update${className}(Dto pDto){
//              g4Dao.update("update${className}", pDto);
//        }

}