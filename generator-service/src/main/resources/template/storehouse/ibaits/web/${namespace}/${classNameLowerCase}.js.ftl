<#assign className = table.className>
<#assign classNameLower = className?lower_case>
Ext.onReady(function() {
     <#list table.columns as column>
       <#if column.needStore>
        var ${column.columnNameLowerCase}Store = new Ext.data.Store({
           baseParams:{code:'${column.selectCode}'},
           proxy:new Ext.data.HttpProxy({url:_contextPath_ + '/codeSelect.action',async:false}),
           reader: new Ext.data.JsonReader({}, [
             {name: "code"},
             {name: "codedesc"}
           ]),
           remoteStore:false
           });
         ${column.columnNameLowerCase}Store.load();
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
             var sm = new xg.CheckboxSelectionModel();
            <#break>
            <#case "RowNumberer">
            var rowNumberer = new xg.RowNumberer();
            <#break>
        </#switch>
    </#list>

    var grid = new Ext.ux.FunctionGrid({
        title:"${table.tableAlias}列表",
        searchColumn:3,
        dataId:"${table.pkColumns[0].columnNameLowerCase}",
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
	        {header:'${column.columnAlias}',sortable:true,dataIndex:'${column.columnNameLowerCase}'
            <#if column.needStore>
            ,renderer : function(value) {
                var returnValue;
                ${column.columnNameLowerCase}Store.each(function(record) {
                    if (record.get('code') != value) {
                    } else {
                        returnValue = record.get('codedesc');
                        return false;
                    }
                });
                return returnValue;
            }
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
        initEditAction:"${namespace}/${className}_find",
        saveAction:"${namespace}/${className}_save",
        deleteAction:"${namespace}/${className}_delete",
        searchSet:[
            <#list table.searchColumns as column>
             <#--<#if column.isDateTimeColumn>-->
                <#--${extjs.genSearchFieldForDate(column)}<#if column_has_next>,</#if>-->
             <#--<#else>-->
                ${extjs.genSearchField(column)}<#if column_has_next>,</#if>
             <#--</#if>-->
            </#list>
            ],
        formSet:[
            <#list table.pkColumns as column>
               <#if !column.formField>{xtype:'hidden',fieldLabel:'${column.columnAlias}',name:'${column.columnNameLowerCase}'},</#if>
           </#list>
                {
                layout:'column',
                items:[
                    {
                        columnWidth:.5,
                        layout: 'form',
                        items: [
                            <#list table.formColumns as column>
                               <#if column_index%2==0>
                               ${extjs.genFormField(column)}<#if column_has_next&&(column_index!=(table.formColumns?size-2))>,</#if>
                              </#if>
                           </#list>
                        ]
                    },
                    {
                        columnWidth:.5,
                        layout: 'form',
                        items: [
                            <#list table.formColumns as column>
                               <#if column_index%2==1>
                               ${extjs.genFormField(column)}<#if column_has_next&&(column_index!=(table.formColumns?size-2))>,</#if>
                            </#if>
                           </#list>
                        ]
                    }
                ]
            }
        ]
    });

    new Ext.Viewport({
            layout:'border',
            items:[grid.panels]
        });
 });