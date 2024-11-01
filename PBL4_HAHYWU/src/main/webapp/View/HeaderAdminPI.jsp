<%@page import="model.bean.Account"%>
<%@page import="java.util.Base64"%>
<%@page import="model.bean.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <link rel="icon" type="image/png" href="img/favicon-32x32.png">
    <title>HAHYWU</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/purecss@3.0.0/build/pure-min.css" integrity="sha384-X38yfunGUhNzHpBaEBsWLO+A0HDYOQi8ufWDkZ0k9e0eXz/tH3II7uKZ9msv++Ls" crossorigin="anonymous">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/purecss@3.0.0/build/grids-responsive-min.css">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/View/style01.css">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/View/style02.css">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/View/style03.css">
    <script>
	    function show(id1) {
	        var x = document.getElementById(id1);
	        if (x.style.display === "none") {
	            x.style.display = "block";
	        } else {
	            x.style.display = "none";
	        }
	    }
	    function signout() {
	        location.href = "index.jsp";
	    }
    </script> 
</head>
<body>
	<main>
	<% Account user = (Account)request.getAttribute("admin"); %>
        <div class="pure-g nav" style="z-index: 999999;">
            <div class="pure-u-2-24"></div>
            <div class="pure-u-20-24">
                <div class="nav-child">
                    <div class="logo">
                        <img class="logo-img" src="<%=request.getContextPath() + "/img/logo.png"%>" alt="">
                        <p class="logo-text">HAHYWU</p>
                    </div>
                    <div class="button-head">
                        <a href=""><input id="" class="button-head-hover" type="button" value="" style="background-image: url(<%=request.getContextPath() + "/img/Profile.png"%>);"></a>
                        <a href="GrabServlet?Censoring=1&idacc=<%= user.getID_Account() %>"><input id="Home" type="button" value="" style="background-image: url(<%=request.getContextPath() + "/img/Home.png"%>);"></a>
                        <a href="GrabServlet?ManageUser=1&idacc=<%= user.getID_Account() %>"><input id="MaAc" class="" type="button" value="" style="background-image: url(<%=request.getContextPath() + "/img/manage_acc.png"%>);"></a>
                    </div>
                    <%
                    	if(user.getAvatar() != null){
                    		byte[] imageBytes = user.getAvatar();
    				    	String base64Encoded = Base64.getEncoder().encodeToString(imageBytes);
    				%>
    						<input type="button" name="" class="leftbut" style="background-image: url(data:image/png;base64,<%= base64Encoded %>); background-size: 45px;" onclick="show('click-choice')">
    				<%
                    	}
                    	else {
					%>
						<input type="button" name="" class="leftbut" style="background-image: url(img/defaultavatar.jpg); background-size: 45px;" onclick="show('click-choice')">
					<%
                    	}
					%> 
					<span id="click-choice" style="display: none;">
                    <div>
                        <button class="signout" onclick="signout()">Sign out</button>
                    </div>
	                </span>
                </div>
            </div>
            <div class="pure-u-2-24"></div>
        </div>
    </main>
    <footer>
    </footer>
</body>
</html>