<#include "/java_copyright.include">
<#assign className = table.className>
<#assign classNameLower = className?uncap_first>
package ${basepackage}.service;

import org.eredlab.g4.bmf.base.BaseService;
import org.eredlab.g4.ccl.datastructure.Dto;


public interface ${className}Service extends BaseService {

	void saveOrUpdate${className}(Dto pDto);

	void delete${className}(Dto pDto);
}
