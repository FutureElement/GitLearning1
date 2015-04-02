<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/views/Common/include/refOutResource.jsp"%>
<head>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
    <!-- 国产浏览器默认不使用兼容模式浏览网页 -->
    <meta name="renderer" content="webkit">
    <!-- IE兼容模式下默认使用最新版本的渲染模式 -->
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>中国华能运维平台</title>
    <link rel="shortcut icon" href="${rootPath}/images/common/favicon.ico" type="image/x-icon" />
    <!-- 首页必需 start-->
    <link rel="stylesheet" href="${rootPath}/appframe/layout/skin/horizontalMenu/css/reset.css" />
    <link rel="stylesheet" href="${rootPath}/appframe/layout/skin/horizontalMenu/css/base.css" />
    <link rel="stylesheet" href="${rootPath}/appframe/layout/skin/horizontalMenu/css/theme.css" title="theme" />
    <script type="text/javascript" src="${rootPath}/appframe/layout/skin/horizontalMenu/js/menu.js"></script>
    <script src="${rootPath}/js/thirdparty/qui/extends/fullscreen.js" type="text/javascript"></script>
	<!-- 首页必需 end -->
</head>

<body id="emsystemmainbody" scroll="no" style="overflow-x:hidden;overflow-y:hidden" onload="startUpdate();" onunload="stopUpdate();">
    <div class="background_showLeft">
    	<div class="background_showRight">
		    <div id="top_all">
			    <!-- 页头开始 -->
			    <div id="full_top">
			    <div id="header" class="header">
			    	<div class="header_left">
				    	<div class="header_right">
					    	<ul class="action-bar" style="padding-Top: 3px;padding-bottom: 0;">
					    		<li style="color:white;padding-left: 6px;"><spring:message code="main.welcome" arguments="${userName}"/></li>
					    	</ul>
					        <ul class="action-bar" style="padding-Top: 1px;padding-bottom: 3px;">
					            <li id="myMessages"><a href="javascript:void(0);" onclick="showMessages()"><i class="icon msgIcon" style="text-indent: 0px;"></i><spring:message code="main.message" arguments="0"/></a></li>
					        	<li><a href="javascript:void(0);" onclick="modifyPassword()"><i class="icon icon-6" style="text-indent: 0px;"></i><spring:message code="main.modifyPassword"/></a></li>
					            <li><a href="javascript:void(0);" onclick="exitHandler()"><i class="icon icon-7" style="text-indent: 0px;"></i><spring:message code="main.exit"/></a></li>
					        </ul>
				        </div>
			        </div>
			    </div>
			    <!-- 页头结束 -->
			    <div class="menu menu-bar" id="menu_menu-bar">
			        <ul class="main-menu" id="menu_lv1">
			        	<li><a>无权限</a></li>
			        </ul>
			        <ul class="sub-menu" id="menu_lv2">
			        	<li><a>无权限</a><ul></ul></li>
			        </ul>
			    </div>
			    </div>
			    <div class="main" style="min-height: 35px;" id="navigationMenu">
			    	<!-- 导航条 -->
			        <div class="navigation block clearfix">
			            <p class="breadcrumb clearfix" id="menu_nav">
			                <i class="icon icon-9" style="text-indent: 0px;"></i>
			               	<a href="javascript:void(0);">无权限</a><i>»</i>
			                <a href="index.view">无权限</a>
			            </p>
			            <ul class="action-bar" style="margin-right: 15px;">
			                <li id="fullscreenLI"><span style="cursor: pointer;" id="fullscreen" onclick="fullscreen()">【开启全屏】</span>
			           </ul>
			        </div> 
			        <!-- 导航条结束 -->
			    </div>
		    </div>
		    <!-- 内容开始 -->
		    <div class="main" id="contentMain" style="min-height: 300px;padding-top: 2px;">
		    	<div style="padding: 5px 0px 0px 5px;background-color: #fff">
					<iframe frameborder="0" id="mainContentIframe" name="frmright" src="#"></iframe>
				</div>
			</div>
			<!-- 内容结束 -->
			<!-- 页脚开始 -->
			<div id="bot_all">
			    <div id="footer" class="footer" style="height:18px;text-align: center;BACKGROUND-COLOR: #0077c7;color:#fff;padding-top: 3px;">
			       	<spring:message code="main.CopyRight"/> 
			    </div>
		    </div>
		    <!-- 页脚结束 -->
	    </div>
	</div>

	<script type="text/javascript" defer="defer">
		var menu_lv1 = "menu_lv1";
		var menu_lv2 = "menu_lv2";
		var menu_nav = "menu_nav";
        //var enableFullScreen = screenfull.enabled;
        var enableFullScreen = false;
		var allMenus;
		var isFullscreen;
		function fullscreen(){
			if(enableFullScreen) {
				screenfull.toggle();
			}else{
				$("#full_top").toggle();
				$("#bot_all").toggle();
			}
			setTimeout(changeButtonName);
		}
		function changeButtonName(){
            if (enableFullScreen) {
				isFullscreen = screenfull.isFullscreen;
			}else{
				isFullscreen = ($("#full_top")[0].style.display=="none");
				setContentSize(isFullscreen);
			}
			var element = $("#fullscreen")[0];
			if(isFullscreen){
				element.innerHTML = "【退出全屏】";
			}else{
				element.innerHTML = "【开启全屏】";
			}
		}
		function initMenu() {
			setContentSize();
			$(window).resize(function(){
				setContentSize();
			});
			$.post("${rootPath}/app/getMenuListByUserId.json", {}, function(result) {
				if (result && result.length) {
					allMenus = result;
					initLevelOneMenu();
				}
			}, "json");
		}
		function initLevelOneMenu() {
			$("#" + menu_lv1).empty();
			var li = '<li><a onclick="#onclick#">#name#</a></li>';
			for (var i = 0; i < allMenus.length; i++) {
				$("#" + menu_lv1).append(
						li.replace("#name#", allMenus[i].name).replace("#onclick#",
								"setTimeout(function(){initLevelTwoMenu(" + i + ")})"));
			}
			setTimeout(function(){initLevelTwoMenu(0)});
		}

		function initLevelTwoMenu(arg) {
			$("#" + menu_lv2).empty();
			for (var i = 0; i < allMenus.length; i++) {
				$($("#" + menu_lv1).children("li")[i]).removeClass("this");
			}
			$($("#" + menu_lv1).children("li")[arg]).addClass("this");
			var menu2 = allMenus[arg];
			if (menu2 && menu2.children && menu2.children.length) {
				var li = '<li requesturl="#requesturl#" parentIndex="#parentIndex#"><a onclick="#onclick#">#name#</a></li>';
				for (var i = 0; i < menu2.children.length; i++) {
					$("#" + menu_lv2).append(
							li.replace("#name#", menu2.children[i].name).replace("#onclick#",
									"setTimeout(function(){clickLevelTwoMenu(" + i + ")})").replace("#requesturl#",
									menu2.children[i].url).replace("#parentIndex#", arg));
					/* if(menu2.children[i].children)
					{
						<ul></ul>
						initLevelThreeMenu(i);
					} */
				}
			}
			setTimeout(function(){clickLevelTwoMenu(0)});
		}
		function clickLevelTwoMenu(arg) {
			var lv2Nodes = $("#" + menu_lv2).children("li");
			if (lv2Nodes && lv2Nodes.length) {
				for (var i = 0; i < lv2Nodes.length; i++) {
					$(lv2Nodes[i]).removeClass("this");
				}
				$(lv2Nodes[arg]).addClass("this");
			}
			initNavMenu(arg);
			$("#mainContentIframe").attr("src", '${rootPath}' + $(lv2Nodes[arg]).attr("requesturl"));
		}
		function initNavMenu(arg) {
			var lv2Nodes = $("#" + menu_lv2).children("li");
			var parentIndex = $(lv2Nodes[arg]).attr("parentIndex");
			$("#" + menu_nav).empty();
			$("#" + menu_nav).append('<i class="icon icon-9" style="text-indent: 0px;"></i>');
			$("#" + menu_nav).append(
					'<a onclick="setTimeout(function(){initLevelTwoMenu(' + parentIndex + ')})">' + allMenus[parentIndex].name
							+ '</a><i>»</i>');
			$("#" + menu_nav).append(
					'<a onclick="setTimeout(function(){clickLevelTwoMenu(' + arg + ')})">'
							+ allMenus[parentIndex].children[arg].name + '</a>');
		}
		function initLevelThreeMenu(arg) {
			//预留生成三级菜单方法
			//<li><a href="javascript:void(0);">三级菜单项</a></li>
		}
		
		function setContentSize(arg){
            var contentHeight;
			if(arg){
				contentHeight = $(window).height()-$("#navigationMenu").height()-10;
                //$("#mainContentIframe").height($(window).height()-$("#navigationMenu").height()-15);
			}
			else contentHeight = $(window).height()-$("#top_all").height()-$("#bot_all").height()-2;
			//var contentWidth = $(window).width()-42;
            var contentWidth = 1280;
            if(window.screen.width<=1280){
                contentWidth = contentWidth - 50;
            }
			//var contentHeight = $(window).height()-$("#header").height()-$("#menu_menu-bar").height()-$("#navigationMenu").height()-$("#footer").height()-20;
			$("#mainContentIframe").height(contentHeight-5);
			$("#mainContentIframe").width(contentWidth-10);
			$("#header").width(contentWidth);
			$("#menu_menu-bar").width(contentWidth);
			$("#navigationMenu").width(contentWidth);
			$("#footer").width(contentWidth);
			$("#contentMain").width(contentWidth);
            if($.browser.msie){
                $("#fullscreenLI")[0].style.paddingTop="2px";
            }
			else $("#fullscreenLI")[0].style.paddingTop="0";
		}
		//exit退出
		function exitHandler(){
			top.Dialog.confirm("确定要退出系统吗？",function(){
				$.post("${rootPath}/app/logout.json",
					  function(feedBack){
						  if(feedBack.status=="200"){
						      top.Dialog.alert(feedBack.message);
							  window.location="${rootPath}/appframe/login/login.jsp";  
						  }
						  else{
						  	 top.Dialog.alert(feedBack.message);
						  }
						  
					  },"json");
			});
		}
		/*
		*  添加导航
		*  param 导航标题
		*  param 回调函数
		*  param 回调方法参数 Object...
		*/
		function appendNav(title,callback){
			if(callback && typeof(callback)=="function"){
				$("#" + menu_nav).append('<i>»</i><a>'+ title + '</a>');
				var args=[];
				if(arguments.length>2){
					for(var i=2;i<arguments.length;i++){
						args[i-2]=arguments[i];
					}
				}
				var thisElement = $("#" + menu_nav).children().last();
				thisElement.click(
					function(){
						thisElement.nextAll().remove();
						callback.apply(window.frames['frmright'],args);
					}
				);
			}else{
				$("#" + menu_nav).append('<i>»</i><span>'+ title + '</span>');
			}
		}
		
		/*
		*  添加第一个导航
		*  param 导航标题
		*  param 回调函数
		*  param 回调方法参数 Object...
		*/
		function appendFirstNav(title,callback){
			//var thisElement = $("#" + menu_nav).children()[3];
			//$(thisElement).nextAll().remove();
			resetNav();
			appendNav.apply(this,arguments);
		}
		
		/*
		* 重置导航
		* param 需要清除的级数,传入number
		* 如向前清除1级 ，传入1,导航清除最后一级
		* 如清除全部，则不传入参数，导航还原成原始的二级导航
		*/
		function resetNav(level){
			var index = 3;
			var thisElement = $("#" + menu_nav).children();
			if(level){
				index = thisElement.length-1-2*index;
				if(index<3)
					index=3;
			}
			$(thisElement[index]).nextAll().remove();
		}
		initMenu();
		
		//修改密码
		function modifyPassword(){
			var title =  '<spring:message code="main.modifyPasswordDiag.title"  arguments="${userName}"/>';
			$.quiTools.open({
				URL : "${rootPath}/app/modifyPassword.view",
				Title : title, Width : 400, Height : 220
			});
		}
		
		function showMessages(){
			var diag = new top.Dialog();
			diag.Title = "消息";
			diag.URL = "${rootPath}/app/showMessages.view";
			diag.Width = 940;
			diag.Height = 465;
			diag.ShowButtonRow = true;
			diag.ShowOkButton = false;
			diag.show();
		}
		
		var begin;
		function startUpdate(){
			changeMessagesText();
			begin = setInterval("changeMessagesText()",30000);//1000毫秒=1秒,30s
		}
		
		function stopUpdate() {
			if (begin) {
				clearInterval(begin);
			}
		}
		
		function changeMessagesText(){
			$.post("${rootPath}/app/getTipsSize.json", null, function(tipsCount){
				if(tipsCount>=0){
					var text = '<a href="javascript:void(0);" onclick="showMessages()"><i class="icon msgIcon" style="text-indent: 0px;"></i><spring:message code="main.message" arguments="'+tipsCount+'"/></a>';
					$("#myMessages").html(text);
				}
			}, "json");
		}
	</script>
</body>
</html>