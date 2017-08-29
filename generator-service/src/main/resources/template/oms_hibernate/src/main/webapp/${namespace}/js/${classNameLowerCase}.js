<#assign className = table.className>
<#assign classNameLower = className?lower_case>
<#assign colpanCount=0>
Ext.namespace("${basepackage}");
Ext.onReady(function() {
    /**
     * 创建表格
     * @param config
     */
    ${basepackage}.getGrid=function(config){
        <#list table.columns as column>
        <#if column.needStore>
        <#if column.eacode>
        <#if "myitemselector"==column.xType>
            var ${column.columnNameLower}Store = getDictArrayStore('${column.selectCode.fieldvalue}');
        ${column.columnNameLower}Store.load();
        <#else>
        var ${column.columnNameLower}Store = getDictStore('${column.selectCode.fieldvalue}');
        ${column.columnNameLower}Store.load();
        </#if>
        <#else>
        var ${column.columnNameLower}Store = new Ext.data.Store({
            baseParams:{tableName:'${column.selectCode.tableName}',field:'${column.selectCode.field}',code:'${column.selectCode.code}',codedesc:'${column.selectCode.codedesc}',fieldvalue:'${column.selectCode.fieldvalue}'},
            proxy:new Ext.data.HttpProxy({url:_contextPath_ + '/common/codeSelect.action'}),
            reader: new Ext.data.JsonReader({}, [
                {name: "code"},
                {name: "codedesc"}
            ]),
            remoteSort:false
        });
        ${column.columnNameLower}Store.load();
        </#if>
        </#if>
        </#list>

        <#list table.gridPlugins as column>
        <#switch column>
        <#case "RowExpander">
            var expander = new Ext.ux.grid.RowExpander({
                tpl : new Ext.Template(
                    '<p><b>Company:</b> {company}</p><br>',
                    '<p><b>Summary:</b> {desc}</p>'
                )
            });
        <#break>
        <#case "Checkbox">
            var sm = new Ext.grid.CheckboxSelectionModel();
        <#break>
        <#case "RowNumberer">
            var rowNumberer = new Ext.grid.RowNumberer();
        <#break>
        </#switch>
            </#list>

                var grid = new Ext.ux.FunctionGrid({
                    title:"${table.tableAlias}列表",
                    searchColumn:3,
                <#if table.pkCount gt 1>
                dataId:[<#list table.pkColumns as column>"${column.columnNameLower}"<#if column_has_next>,</#if></#list>],
            <#else>
                dataId:"${table.pkColumn.columnNameLower}",
            </#if>
                   columns:[
                <#list table.gridPlugins as column>
                <#switch column>
                <#case "RowNumberer">
                rowNumberer,
                <#break>
                <#case "RowExpander">
                expander,
                <#break>
                <#case "Checkbox">
                sm,
                <#break>
                </#switch>
                    </#list>
                        <#list table.gridColumns as column>
                        {header:'${column.columnAlias}',sortable:true,dataIndex:'${column.columnNameLower}'
                        <#if column.needStore>
                            ,renderer:function(value){return headerRenderer(value,${column.columnNameLower}Store)}
                    </#if>
                    }<#if column_has_next>,</#if>
                </#list>
                ],
                <#if table.columnLock>
                    lock:true,
                </#if>
                <#if table.stripeRows>
                    stripeRows:true,
                </#if>
                <#if table.stripeRows>
                    columnLines:true,
                </#if>
                    listAction:"${namespace}/${className}_list",
                <#if !table.paging>
                    paging:false,
                </#if>
                <#if !table.canedit>
                    edit:false,
                </#if>
                <#if (table.gridPlugins?size>0)>
                    pluginSize:${table.gridPlugins?size},
                <#list table.gridPlugins as column>
                    <#switch column>
                    <#case "RowExpander">
                    plugins:expander,
                    <#break>
                    <#case "Checkbox">
                    sm:sm,
                    <#break>
                    </#switch>
                        </#list>
                            </#if>
                            addTitle:"增加${table.tableAlias}",
                                editTitle:"编辑${table.tableAlias}",
                                viewTitle:"查看${table.tableAlias}",
                                deleteTitle:"删除${table.tableAlias}",
                                initEditAction:"${namespace}/${className}_find",
                                saveAction:"${namespace}/${className}_save",
                                deleteAction:"${namespace}/${className}_delete",
                        <#if (table.searchColumns?size>0)>
                            searchSet:[
                            <#list table.searchColumns as column>
                                ${extjs.genSearchField(column)}<#if column_has_next>,</#if>
                        </#list>
                        ],
                        </#if>
                            formSet:[
                            <#list table.pkColumns as column>
                            <#if !column.formField>{xtype:'hidden',fieldLabel:'${column.columnAlias}',name:'${column.columnNameLower}'},</#if>
                        </#list>
                            {
                                layout:'${table.layout}',
                            <#switch table.layout>
                            <#case "column">
                            items:[
                                {
                                    columnWidth:1/${table.colspan},
                                    layout: 'form',
                                    items: [
                                    <#list table.formColumns as column>
                            <#if column_index%table.colspan==0>
                                ${extjs.genFormField(column)}<#if column_has_next&&(column_index!=(table.formColumns?size-2))>,</#if>
                            </#if>
                            </#list>
                            ]
                            }
                        <#if (table.colspan>1)>
                        , {
                            columnWidth:1/${table.colspan},
                                layout: 'form',
                                items: [
                            <#list table.formColumns as column>
                            <#if column_index%table.colspan==1>
                                ${extjs.genFormField(column)}<#if column_has_next&&(column_index!=(table.formColumns?size-2))>,</#if>
                        </#if>
                        </#list>
                        ]
                        }
                        </#if>
                        <#if (table.colspan>2)>
                        ,{
                            columnWidth:1/${table.colspan},
                                layout: 'form',
                                items: [
                            <#list table.formColumns as column>
                            <#if column_index%table.colspan==2>
                                ${extjs.genFormField(column)}<#if column_has_next&&(column_index!=(table.formColumns?size-2))>,</#if>
                        </#if>
                        </#list>
                        ]
                        }
                        </#if>
                        ]
                        <#break>
                        <#case "table">
                        layoutConfig: {
                            columns: ${table.colspan}
                                },
                            defaults : {
                                layout : 'form',
                                    width:(window.screen.width-250)/${table.colspan}*0.95
                            },
                            items:[
                            <#list table.formColumns as column>
                            <#--colpanCount%table.colspan一行中列可用列数 -->

                            <#if (table.colspan-colpanCount%table.colspan<column.colspan||(colpanCount+column.colspan)%table.colspan!=0&&(colpanCount+column.colspan)%table.colspan<=colpanCount%table.colspan)>
                            {
                                colspan:${table.colspan-colpanCount%table.colspan},
                                width:(window.screen.width-250)/${table.colspan}*0.95,
                                    html:"<br/>"
                            <#assign colpanCount=colpanCount+table.colspan-colpanCount%table.colspan>
                            },
                        </#if>
                        <#assign colpanCount=colpanCount+column.colspan>
                            {
                            <#if  column.colspan==2>
                            colspan:${column.colspan},
                            width:(window.screen.width-250)/${table.colspan}*1.9,
                                items:[ ${extjs.genFormField(column)}]
                            <#elseif  column.colspan==3>
                            colspan:${column.colspan},
                            width:(window.screen.width-250)/${table.colspan}*2.85,
                                items:[ ${extjs.genFormField(column)}]
                            <#elseif  column.colspan==3>
                            colspan:${column.colspan},
                            width:(window.screen.width-250)/${table.colspan}*3.8,
                                items:[ ${extjs.genFormField(column)}]
                            <#else>
                            colspan:${column.colspan},
                            width:(window.screen.width-250)/${table.colspan}*0.95,
                                items:[${extjs.genFormField(column)}]
                            </#if>
                        }
                        <#if column_has_next&&(column_index!=(table.formColumns?size-1))>,</#if>
                        </#list>
                        ]
                        <#break>
                        </#switch>

                            }
                        ]
                        });
         return grid;
    }



     flowUtils.isUseFlow('${namespace}/${className}_findByProcessId',${basepackage}.getGrid());
 });