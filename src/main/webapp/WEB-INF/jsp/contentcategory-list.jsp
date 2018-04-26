<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:include page="/common/head.jsp"></jsp:include>
<link rel="stylesheet" href="/lib/zTree/v3/css/zTreeStyle/zTreeStyle.css" type="text/css">
<title>商城内容管理</title>
</head>
<body>
<nav class="breadcrumb"><i class="Hui-iconfont">&#xe67f;</i> 首页 <span class="c-gray en">&gt;</span> 商城内容管理 <span class="c-gray en">&gt;</span> 分类管理 <a class="btn btn-success radius r" style="line-height:1.6em;margin-top:3px" href="javascript:location.replace(location.href);" title="刷新" ><i class="Hui-iconfont">&#xe68f;</i></a></nav>
<table class="table">
	<tr>
		<td width="200" class="va-t"><ul id="treeDemo" class="ztree"></ul></td>
		<td class="va-t">
			<form action="" method="post" class="form form-horizontal" id="form-contentcategory">
				<div class="row cl">
					<label class="form-label col-xs-4 col-sm-2">
						<span class="c-red">*</span>
						当前选择分类：</label>
					<div class="formControls col-xs-6 col-sm-6">
						<input type="hidden" id="cid" name="cid" value="">
						<input type="text" class="input-text" value="" placeholder="请从树菜单选择分类" id="showname" name="product-category-name" disabled="disabled">
					</div>
				</div>
				<div class="row cl">
					<label class="form-label col-xs-4 col-sm-2">
						<span class="c-red">*</span>
						分类名称：</label>
					<div class="formControls col-xs-6 col-sm-6">
						<input type="text" class="input-text" value="" placeholder="" id="name" name="name">
					</div>
				</div>
				<div class="row cl">
					<div class="col-9 col-offset-2">
						<input class="btn btn-primary radius" type="button" id="submitAndsave" value="添加子分类">
						<input class="btn btn-primary radius" type="button" id="submitDelete" value="删除当前分类">
						<input class="btn btn-primary radius" type="button" id="submitUpdate" value="修改当前分类">
					</div>
				</div>
			</form>
		</td>
	</tr>
</table>
<jsp:include page="/common/footer.jsp"></jsp:include>
<!--请在下方写此页面业务相关的脚本-->
<script type="text/javascript" src="/lib/zTree/v3/js/jquery.ztree.all-3.5.min.js"></script> 
<script type="text/javascript">
var setting = {
	view: {
		dblClickExpand: false,
		showLine: false,
		selectedMulti: false
	},
	data: {
		simpleData: {
			enable:true,
			idKey: "id",
			pIdKey : "parentid",
			rootPId: ""
		}
	},
	callback: {
		beforeClick: function(treeId, treeNode) {
			var zTree = $.fn.zTree.getZTreeObj("tree");
			if (treeNode.isParent) {
				$("#cid").attr("value",  treeNode.id);
				$("#showname").attr("value",  treeNode.name);
				//zTree.expandNode(treeNode);
				return false;
			} else {
				//demoIframe.attr("src",treeNode.file + ".html");
				$("#cid").attr("value",  treeNode.id);
				$("#showname").attr("value",  treeNode.name);
				return true;
			}
		}
	}
};

/* var zNodes =[
	{ id:1, pId:0, name:"一级分类", open:true},
	{ id:11, pId:1, name:"二级分类"},
	{ id:111, pId:11, name:"三级分类"},
	{ id:112, pId:11, name:"三级分类"},
	{ id:113, pId:11, name:"三级分类"},
	{ id:114, pId:11, name:"三级分类"},
	{ id:115, pId:11, name:"三级分类"},
	{ id:12, pId:1, name:"二级分类 1-2"},
	{ id:121, pId:12, name:"三级分类 1-2-1"},
	{ id:122, pId:12, name:"三级分类 1-2-2"},
]; */
		
var code;
		
function showCode(str) {
	if (!code) code = $("#code");
	code.empty();
	code.append("<li>"+str+"</li>");
}
		
$(document).ready(function(){
	var zNodes;
	$.ajax({
		url : "/restful/page/contentcategory",
		type : "GET",
		dataType : "json",
		async : false,
		success : function(data) {
			zNodes = data;
		}
	});
	var t = $("#treeDemo");
	t = $.fn.zTree.init(t, setting, zNodes);
	demoIframe = $("#testIframe");
	//demoIframe.on("load", loadReady);
	var zTree = $.fn.zTree.getZTreeObj("tree");
	//zTree.selectNode(zTree.getNodeByParam("id",'6'));
});


//添加子分类
$("#submitAndsave").click(function() {
	//同学练习补充表单验证
	$.ajax({
        url: "/restful/page/contentcategory",//要请求的服务器url 
        //这是一个对象，表示请求的参数，两个参数：method=ajax&val=xxx
        //data:{method:"ajaxTest",val:value}
        data: {
            name: $("#name").val(),
            parentid: $("#cid").val(),
        },
        async: true,   //是否为异步请求
        cache: false,  //是否缓存结果
        type: "post", //请求方式为posts
        dataType: "json",   //服务器返回的数据是什么类型 
        success: function(data){
			   layer.msg('添加成功!',{icon:1,time:3000});
		   },
		   error: function(){
			   layer.msg('添加失败!',{icon:2,time:3000});
		   }
      });
});

//删除选中分类
$("#submitDelete").click(function() {
    var showname = $("#showname").val();
    if(showname==''){
    	layer.msg('请选择要删除分类!',{icon:2,time:3000});
    	return;
    }
	layer.confirm('删除'+showname+',该分类下子分类全删除,确认要删除吗？',function(){
		$.ajax({
			   type: "post",
			   url: "/restful/page/contentcategory/",
			   data :{
				   	_method:'DELETE',
		            name: $("#name").val(),
		            id: $("#cid").val(),
		        },
			   success: function(_data){
				   layer.msg('删除成功!',{icon:1,time:3000});
			   },
			   error: function(){
				   layer.msg('删除失败!',{icon:2,time:3000});
			   }
			});
	});
});

//修改选中分类
$("#submitUpdate").click(function() {
    var showname = $("#showname").val();
    if(showname==''){
    	layer.msg('请选择要删除分类!',{icon:2,time:3000});
    	return;
    }
	layer.confirm('确认要修改该分类吗？',function(){
		$.ajax({
			   type: "post",
			   url: "/restful/page/contentcategory/",
			   data :{
				   	_method:'PUT',
		            name: $("#name").val(),
		            id: $("#cid").val(),
		        },
			   success: function(_data){
				   layer.msg('删除成功!',{icon:1,time:3000});
			   },
			   error: function(){
				   layer.msg('删除失败!',{icon:2,time:3000});
			   }
			});
	});
});
</script>
</body>
</html>