<#assign className = table.className>
<#assign classNameLower = className?uncap_first>
package ${basepackage}.action;

import com.action.BaseAction;
import com.opensymphony.xwork2.ActionSupport;
import net.sf.json.JSONObject;
import org.eredlab.g4.ccl.json.JsonHelper;
import org.apache.struts2.ServletActionContext;
import org.eredlab.g4.bmf.util.SpringBeanLoader;
import org.eredlab.g4.ccl.datastructure.Dto;
import org.eredlab.g4.ccl.datastructure.impl.BaseDto;
import org.eredlab.g4.rif.util.SessionContainer;
import org.eredlab.g4.rif.util.WebUtils;
import ${basepackage}.service.${className}Service;

import javax.servlet.http.HttpServletRequest;
import java.util.List;


public class  ${className}Action extends BaseAction {

     ${className}Service  ${classNameLower}Service = (${className}Service) SpringBeanLoader.getSpringBean("${classNameLower}Service");

    private JSONObject resultJson;

    public JSONObject getResultJson() {
        return resultJson;
    }

    public void setResultJson(JSONObject resultJson) {
        this.resultJson = resultJson;
    }

    public String list() {
        HttpServletRequest request = ServletActionContext.getRequest();
       <#if table.paging>
        Dto dto = WebUtils.getPagePraramsAsDto(request);
        <#list table.searchColumns as column>
          <#if column.isDateTimeColumn>
           dto.put("${column.columnNameLowerCase}begin",getDateParameter("${column.columnNameLowerCase}begin",null));
           dto.put("${column.columnNameLowerCase}end",getDateParameter("${column.columnNameLowerCase}end",null));
          <#else>
          dto.put("${column.columnNameLowerCase}",request.getParameter("${column.columnNameLowerCase}"));
         </#if>
        </#list>
        List roleList = g4Reader.queryForPage("query${className}", dto);
        Integer pageCount = (Integer)g4Reader.queryForObject("count${className}", dto);

        JSONObject jsonObject = JsonHelper.encodeList2JSONArray(roleList,pageCount,null);
       <#else>
        Dto dto = new BaseDto();
        <#list table.searchColumns as column>
          <#if column.isDateTimeColumn>
           dto.put("${column.columnNameLowerCase}begin",getDateParameter("${column.columnNameLowerCase}begin",null));
           dto.put("${column.columnNameLowerCase}end",getDateParameter("${column.columnNameLowerCase}end",null));
          <#else>
          dto.put("${column.columnNameLowerCase}",request.getParameter("${column.columnNameLowerCase}"));
         </#if>
        </#list>
        List roleList = g4Reader.queryForList("query${className}", dto);

        JSONObject jsonObject = JsonHelper.encodeList2JSONArray(roleList,null,null);
       </#if>
        setResultJson(jsonObject);
        return SUCCESS;
    }

    public String find() {
        HttpServletRequest request = ServletActionContext.getRequest();

//        String ids = request.getParameter("ids");
//        String[] idarray = ids.split(",");

        Dto dto = new BaseDto();

        <#list table.pkColumns as column>
          dto.put("${column.columnNameLower}",request.getParameter("${column.columnNameLowerCase}"));
        </#list>

        Dto outDto = (BaseDto)g4Reader.queryForObject("get${className}ById", dto);

        JSONObject jsonObject = JsonHelper.encodeObject2JSONObject(outDto,null);
        setResultJson(jsonObject);
        return SUCCESS;
    }

    public String save() {
        HttpServletRequest request = ServletActionContext.getRequest();

        Dto dto = new BaseDto();
        <#list table.columns as column>
          <#if column.isDateTimeColumn>
             dto.put("${column.columnNameLower}",getDateParameter("${column.columnNameLowerCase}",null));
          <#else>
          dto.put("${column.columnNameLower}",request.getParameter("${column.columnNameLowerCase}"));
         </#if>
        </#list>

        ${classNameLower}Service.saveOrUpdate${className}(dto);
        JSONObject returnObject = new JSONObject();
        returnObject.element(SUCCESS, true);
        returnObject.element("msg", "操作成功");
        setResultJson(returnObject);


        return SUCCESS;
    }

    public String delete() {
        HttpServletRequest request = ServletActionContext.getRequest();

        String ids = request.getParameter("ids");
        String[] idarray = ids.split(",");

        Dto dto = new BaseDto();

        <#list table.pkColumns as column>
          dto.put("${column.columnNameLower}",request.getParameter("${column.columnNameLowerCase}"));
        </#list>

        ${classNameLower}Service.delete${className}(dto);

         JSONObject returnObject = new JSONObject();
        returnObject.element(SUCCESS, true);
        returnObject.element("msg", "删除对象成功");
        setResultJson(returnObject);
        return SUCCESS;
    }
}
