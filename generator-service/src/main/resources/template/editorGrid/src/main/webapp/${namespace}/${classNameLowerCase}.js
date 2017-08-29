<#assign className = table.className>
<#assign classNameLower = className?lower_case>
<#assign colpanCount=0>
<#assign stratColumn=0>
<#assign pkView=true> 
Ext.onReady(function() {
     <#list table.columns as column>
       <#if column.needStore>
        <#if column.eacode>
        <#if "myitemselector"==column.xType>
        var ${column.columnNameLower}Store = getDictArrayStore('${column.columnNameLower}');
        ${column.columnNameLower}Store.load();
        <#else>
        var ${column.columnNameLower}Store = getDictStore('${column.columnNameLower}');
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
            var sm = new Ext.ux.grid.RowExpander({
                tpl : new Ext.Template(
                    '<p><b>Company:</b> {company}</p><br>',
                    '<p><b>Summary:</b> {desc}</p>'
                )
                <#assign stratColumn=1>
            });
            <#break>
            <#case "Checkbox">
             var sm = new Ext.grid.CheckboxSelectionModel();
             <#assign stratColumn=1>
            <#break>
            <#case "RowNumberer">
            var sm = new Ext.grid.RowNumberer();
             <#assign stratColumn=1>
            <#break>
        </#switch>
    </#list>

    var grid = new Ext.ux.FunctionEditorGrid({
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
                sm,
                <#break>
                <#case "RowExpander">
                 sm,
                <#break>
                <#case "Checkbox">
                 sm,
                <#break>
            </#switch>
        </#list>
         <#list table.gridColumns as column>
           <#if column.gridField>
            <#if column.pk>
             <#assign pkView=false> 
            </#if>
	        {header:'${column.columnAlias}',sortable:true,
	        dataIndex:'${column.columnNameLower}',
	        editor:${extjs.genFormField(column)}
          <#if column.simpleJavaType=="Date">
            ,renderer:function (v){
             return dateFormatRenderer(v)  
             }
          </#if>
            <#if column.needStore>
            ,renderer:function(value){return headerRenderer(value,${column.columnNameLower}Store)}
            </#if>
             }<#if column_has_next>,</#if>
           </#if>
	    </#list>
	    <#if pkView>
	       <#list table.columns as column>
    	   <#if column.pk>
             ,{
               header:'${column.columnAlias}',
               dataIndex:'${column.columnNameLower}',
               hidden:true
              }
           </#if>
           </#list>
         </#if>
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
        saveAction:"${namespace}/${className}_save",
        deleteAction:"${namespace}/${className}_delete",
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
        <#if (table.searchColumns?size>0)>
        searchSet:[
            <#list table.searchColumns as column>
                ${extjs.genSearchField(column)}<#if column_has_next>,</#if>
            </#list>
            ]
        </#if>
        ,addRow:function (){
            var MyRecord=Ext.data.Record.create([
              <#list table.columns as column>
              { 
                name : '${column.columnNameLower}',
                type : '${column.simpleJavaType}'
              }
              <#if column_has_next>,</#if>
              </#list>
              ]);
              var row = new MyRecord({});
              var count=this.getStore().getCount();
              this.getStore().insert(count, row);
              this.startEditing(count, ${stratColumn});
              sm.selectRow(count, false);
              sm.selectRow(count+1, true);


        }
    });

    new Ext.Viewport({
            layout:'border',
            items:[grid.panels]
        });
 });