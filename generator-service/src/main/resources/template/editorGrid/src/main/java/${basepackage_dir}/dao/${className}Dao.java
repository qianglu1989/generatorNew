<#include "/java_copyright.include">
<#assign className = table.className>   
<#assign classNameLower = className?uncap_first>
<#if table.pkCount gt 1>
<#assign classType = "${className}Id">
<#else>
<#assign classType = table.pkColumn.simpleJavaType>
</#if>
package ${basepackage}.dao;

import com.common.base.BaseHibernateDao;
import com.common.utils.CountOrder;
import ${basepackage}.po.${className};
<#if table.pkCount gt 1>
import ${basepackage}.po.${className}Id;
</#if>
import ${basepackage}.vo.${className}Query;
import org.hibernate.Criteria;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.hibernate.transform.Transformers;
import org.springframework.orm.hibernate3.HibernateCallback;
import org.springframework.stereotype.Repository;

import java.util.List;

import static org.g4studio.core.util.G4Utils.isNotEmpty;

@Repository
public class ${className}Dao extends BaseHibernateDao<${className},${classType}>{

	public Class getEntityClass() {
		return ${className}.class;
	}
	
	public List search${className}(final ${className}Query ${classNameLower},final CountOrder countOrder){
        return getHibernateTemplate().executeFind(new HibernateCallback() {
            public Object doInHibernate(Session session) throws HibernateException {
                Criteria criteria = session.createCriteria(getEntityClass());
                <@generateWhere/>
                <#if table.pkCount gt 1>
                 criteria.setProjection(Projections.projectionList()
                 <#list table.columns as column>
                      <#if column.pk>
                        .add(Projections.property("id.${column.columnNameLower}"),"${column.columnNameLower}")
                      <#else>
                        .add(Projections.property("${column.columnNameLower}"),"${column.columnNameLower}")
                      </#if>
                 </#list>
                        ).setResultTransformer(Transformers.aliasToBean(${className}Query.class));
                </#if>
                if(isNotEmpty(countOrder)) {
                   criteria.setFirstResult(countOrder.getStart());
                   criteria.setMaxResults(countOrder.getLimit());
                if(isNotEmpty(countOrder.getOrderby())) {
                   if("desc".equalsIgnoreCase(countOrder.getDir()))
                   criteria.addOrder(Order.desc(countOrder.getOrderby()));
                    else
                   criteria.addOrder(Order.asc(countOrder.getOrderby()));
                }
               }
               return criteria.list();
            }
        });
    }

	public Long count${className}(final ${className}Query ${classNameLower}){
        return (Long)getHibernateTemplate().executeFind(new HibernateCallback() {
            public Object doInHibernate(Session session) throws HibernateException {
                Criteria criteria = session.createCriteria(getEntityClass());
                <@generateWhere/>
                criteria.setProjection(Projections.rowCount());
                return criteria.list();
            }
        }).iterator().next();
    }

	<#list table.columns as column>
	<#if column.unique && !column.pk>
	public ${className} getBy${column.columnName}(${column.javaType} v) {
		return (${className}) findByProperty("${column.columnNameLower}",v);
	}	
	</#if>
	</#list>

<#macro generateWhere>
    <#list table.searchColumns as column>
    <#if table.pkCount gt 1>
    <#if column.pk>
    <#assign hqlColumnName = "id.${column.columnNameLower}"/>
    <#else>
    <#assign hqlColumnName = "${column.columnNameLower}"/>
    </#if>
    <#else>
     <#assign hqlColumnName = "${column.columnNameLower}"/>
    </#if>
    <#if column.isDateTimeColumn>
        if(isNotEmpty(${classNameLower}.get${column.columnName}Begin())) {
            criteria.add(Restrictions.ge("${hqlColumnName}", ${classNameLower}.get${column.columnName}Begin()));
        }
        if(isNotEmpty(${classNameLower}.get${column.columnName}End())) {
            criteria.add(Restrictions.le("${hqlColumnName}", ${classNameLower}.get${column.columnName}End()));
        }
        <#else>
        if(isNotEmpty(${classNameLower}.get${column.columnName}())) {
           <#if column.xType=="textfield">
              criteria.add(Restrictions.like("${hqlColumnName}", "%"+${classNameLower}.get${column.columnName}()+"%"));
           <#else>
            criteria.add(Restrictions.eq("${hqlColumnName}", ${classNameLower}.get${column.columnName}()));
           </#if>
        }
    </#if>
    </#list>
</#macro>
}