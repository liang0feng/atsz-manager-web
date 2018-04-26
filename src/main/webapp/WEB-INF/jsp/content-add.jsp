<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:include page="/common/head.jsp"/>
<link href="/lib/webuploader/0.1.5/webuploader.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet"
	href="/lib/zTree/v3/css/zTreeStyle/zTreeStyle.css" type="text/css">
</head>
<body>
<body class="pos-r">
	<div class="pos-a"
		style="width: 200px; left: 0; top: 0; bottom: 0; height: 100%; border-right: 1px solid #e5e5e5; background-color: #f5f5f5; overflow: auto;">
		<ul id="treeDemo" class="ztree"></ul>
	</div>
	<div style="margin-left: 200px;">
		<nav class="breadcrumb">
			<i class="Hui-iconfont">&#xe67f;</i> 首页 <span class="c-gray en">&gt;</span>
			内容管理 <span class="c-gray en">&gt;</span> 新增内容 <a
				class="btn btn-success radius r"
				style="line-height: 1.6em; margin-top: 3px"
				href="javascript:location.replace(location.href);" title="刷新"><i
				class="Hui-iconfont">&#xe68f;</i></a>
		</nav>
		<div class="page-container">
			<form  id="form-article-add" action="/restful/page/content" method="post" class="form form-horizontal" enctype="multipart/form-data">
				<div class="row cl">
				<label class="form-label col-xs-4 col-sm-2">内容分类：</label>
					<div class="formControls col-xs-8 col-sm-9">
						<input  type="hidden" class="input-text" value="" id="categoryid" name="categoryid">
						<input  type="text" class="input-text" value="请从分类树选择分类" id="name" disabled="disabled">
					</div>
				</div>
				<div class="row cl">
					<label class="form-label col-xs-4 col-sm-2"><span class="c-red">*</span>内容标题：</label>
					<div class="formControls col-xs-8 col-sm-9">
						<input type="text" class="input-text" value="" placeholder="填入商品名称" id="title" name="title">
					</div>
				</div>
				<div class="row cl">
					<label class="form-label col-xs-4 col-sm-2">子标题：</label>
					<div class="formControls col-xs-8 col-sm-9">
						<input type="text" name="subtitle" id="subtitle" placeholder="填入子标题" value="" class="input-text">
					</div>
				</div>
				<div class="row cl">
					<label class="form-label col-xs-4 col-sm-2">标题描述：</label>
					<div class="formControls col-xs-8 col-sm-9">
						<input type="text" name="titledesc" id="titledesc" placeholder="填入标题描述" value="" class="input-text">
					</div>
				</div>
				<div class="row cl">
					<label class="form-label col-xs-4 col-sm-2"><span class="c-red">*</span>超链接地址：</label>
					<div class="formControls col-xs-8 col-sm-9">
						<input type="text" name="url" id="url" placeholder="填入超链接地址" value="" class="input-text">
					</div>
				</div>
				<div class="row cl">
					<label class="form-label col-xs-4 col-sm-2">图片地址：</label>
					<div class="formControls col-xs-8 col-sm-9">
						<div id="uploadimg">   
							<div id="fileList" class="uploader-list"></div>   
							<div id="imgPicker">选择图片</div>  
						</div>
					</div>
					<input type="hidden" class="input-text" value="" id="pic" name="pic">
						
				</div>
				<div class="row cl">
					<label class="form-label col-xs-4 col-sm-2">内容：</label>
					<div class="formControls col-xs-8 col-sm-9">
						<input type="text" class="input-text" value="" placeholder="填入内容" id="content" name="content">
					</div>
				</div>
				<div class="row cl">
					<div class="col-xs-8 col-sm-9 col-xs-offset-4 col-sm-offset-2">
						<button onClick="article_save_submit();" class="btn btn-primary radius" type="button"><i class="Hui-iconfont">&#xe632;</i> 保存并提交 </button>
						<input type="reset" class="btn btn-default radius" value="&nbsp;&nbsp;重置&nbsp;&nbsp;"/>
					</div>
				</div>
			</form>
		</div>
	</div>

<jsp:include page="/common/footer.jsp"/>

<!--请在下方写此页面业务相关的脚本-->
<script type="text/javascript" src="/lib/My97DatePicker/4.8/WdatePicker.js"></script>
<script type="text/javascript"
		src="/lib/zTree/v3/js/jquery.ztree.all-3.5.min.js"></script>
<script type="text/javascript" src="/lib/jquery.validation/1.14.0/jquery.validate.js"></script> 
<script type="text/javascript" src="/lib/jquery.validation/1.14.0/validate-methods.js"></script> 
<script type="text/javascript" src="/lib/jquery.validation/1.14.0/messages_zh.js"></script>
<script type="text/javascript" src="/lib/webuploader/0.1.5/webuploader.min.js"></script> 
<script type="text/javascript" src="/lib/ueditor/1.4.3/ueditor.config.js"></script>
<script type="text/javascript" src="/lib/ueditor/1.4.3/ueditor.all.min.js"> </script>
<script type="text/javascript" src="/lib/ueditor/1.4.3/lang/zh-cn/zh-cn.js"></script>

<script type="text/javascript">
var setting = {
		//定义树显示方式
		view : {
			dblClickExpand : false,
			showLine : false,
			selectedMulti : false
		},
		//定义数据参数
		data : {
			simpleData : {
				enable : true,
				idKey : "id",
				pIdKey : "parentid",
				rootPId : ""
			}
		},
		callback : {
			beforeClick : function(treeId, treeNode) {
				var zTree = $.fn.zTree.getZTreeObj("tree");
				//判断是否有子类目,没子类目不展开
				if (treeNode.isParent) {
					return false;
				} else {
					//demoIframe.attr("src","kasg.jsp");
					$("#categoryid").attr("value",  treeNode.id);
					$("#name").attr("value",  treeNode.name);
				
					
					return true;
				}
			}

		}
	};

	//初始化商品分类菜单树
	$(document).ready(function() {
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
		//demoIframe = $("#testIframe");
		//sdemoIframe.on("load", loadReady);
		var zTree = $.fn.zTree.getZTreeObj("tree");
		//zTree.selectNode(zTree.getNodeByParam("id", '2'));
	});
	
	//上传文件
	var uploader = WebUploader.create({   
	    auto: true, // 选完文件后，是否自动上传   
	    swf: '/lib/webuploader/0.1.5/Uploader.swf', // swf文件路径   
	    server: '/restful/file/upload', // 文件接收服务端   
	    pick: '#imgPicker', // 选择文件的按钮。可选   
	    fileNumLimit: 1, //限制只能上传一张图片
	    // 只允许选择图片文件。   
	    accept: {   
	        title: 'Images',   
	        extensions: 'gif,jpg,jpeg,bmp,png',   
	        mimeTypes: 'image/*'
	    }  
	});
	
	//监听fileQueued事件，即当有文件添加进来的时候，通过uploader.makeThumb来创建图片预览图。
	uploader.on( 'fileQueued', function( file ) {   
	    var $list = $("#fileList"), //获取文件列表 
	    $li = $(
	        '<div id="' + file.id + '" class="file-item thumbnail">' +   
	        '<img>' +   
	        '<div class="info">' + file.name + '</div>' +   
	        '</div>'
	    ),   
	    $img = $li.find('img');
	    $list.append( $li ); // $list为容器jQuery实例    
	    // 创建缩略图   
	    uploader.makeThumb( file, function( error, src ) {   
	        if ( error ) {   
	            $img.replaceWith('<span>不能预览</span>');   
	            return;   
	        }      
	        $img.attr( 'src', src );//设置预览图
	    }, 100, 100 ); //100x100为缩略图尺寸  
	});
	
	// 文件上传过程中创建进度条实时显示。
	uploader.on( 'uploadProgress', function( file, percentage ) {   
	    var $li = $( '#'+file.id ),   
	    $percent = $li.find('.progress span');      
	    //避免重复创建   
	    if ( !$percent.length ) {   
	        $percent = $('<p class="progress"><span></span></p>').appendTo( $li ).find('span');   
	    }
	    $percent.css( 'width', percentage * 100 + '%' );  
	});
	
	
	// 文件上传成功，给item添加成功class, 用样式标记上传成功。  
	uploader.on( 'uploadSuccess', function( file, res ) {
	    $( '#'+file.id ).addClass('upload-state-done');  
	});
	 //获取的值 
    var image = $('#pic').val();
    //接收上传文件的对象信息
    uploader.on('uploadAccept', function(file,response) {
    	if(response){
    		if(!image){
    			image= response.url;
    		}else{
        		image= image+","+response.url;
    		}
    	}
    	$("#pic").attr("value",image);
    });
	// 文件上传失败，显示上传出错。 
	uploader.on( 'uploadError', function( file ) {   
	    var $li = $( '#'+file.id ),   
	    $error = $li.find('div.error');      
	    // 避免重复创建   
	    if ( !$error.length ) {   
	        $error = $('<div class="error"></div>').appendTo( $li );   
	    }     
	    layer.msg('上传失败!',{icon:2,time:3000});
	});
	
	// 完成上传，成功或者失败，先删除进度条。
	uploader.on( 'uploadComplete', function( file ) {   
	 $( '#'+file.id ).find('.progress').remove();  
	});
	//限制只能上传一张图片
	uploader.on('error', function(handler) {
	    if (handler == "Q_EXCEED_NUM_LIMIT") {
	    	layer.msg('只能上传单张图片!',{icon:2,time:3000});
	    }
	});
	
//添加提交商品
function article_save_submit(){
	var categoryid = $("#categoryid").val();
	if (categoryid=="") {
		layer.msg('请选择内容分类!',{icon:2,time:3000});
		return;
	}
	//提交到后台的RESTful
	$.ajax({
	   type: "POST",
	   url: "/restful/page/content",
	   data: $("#form-article-add").serialize(),
	   success: function(msg){
		   layer.msg('新增内容成功!',{icon:1,time:1000});
	   },
	   error: function(){
		   layer.msg('新增内容失败!',{icon:2,time:1000});
	   }
	});
}

</script>
</body>
</html>