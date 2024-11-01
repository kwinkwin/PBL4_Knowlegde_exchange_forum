<%@page import="java.util.Base64"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page language="java" import="model.bean.User" %>
<%@ page language="java" import="java.util.ArrayList" %>
<%@ page language="java" import="model.bean.Notification" %>
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
        function hide(id) {
        	var x = document.getElementById(id);
        	x.style.display = "none";
        }
        function signout() {
            location.href = "index.jsp";
        }
    </script>
</head>
<body class="scroll">
	<main>
	<% User user = (User)request.getAttribute("user"); %>
        <div class="pure-g nav" style="z-index: 99999;">
            <div class="pure-u-2-24"></div>
            <div class="pure-u-20-24">
                <div class="nav-child">
                    <div class="logo">
                        <img class="logo-img" src="img/logo.png" alt="">
                        <p class="logo-text">HAHYWU</p>
                    </div>
                    <div class="button-head">
                        <a><input id="" class="button-head-hover" type="button" value="" style="background-image: url(img/Profile.png);"></a>
                        <a href="GrabServlet?userhome=1&idacc=<%= user.getID_Account() %>"><input id="Home" type="button" value="" style="background-image: url(img/Home.png);"></a>
                    </div>
                    <div> 
                        <input type="button" name="" class="leftbut" style="background-image: url(img/Notification.png); right: 70px;" onclick="show('notification-box'), hide('click-choice')">
                    <%
                    	int count = (int)request.getAttribute("count");
                    	if(count != 0)
                    	{
                    %>		
                    		<span id="SLNoti" class="badge badge-light"><%=count%></span>
                    <%		
                    	}
                    %>
                    </div>
                    <%
                    	if(user.getAvatar() != null){
                    		byte[] imageBytes = user.getAvatar();
    				    	String base64Encoded = Base64.getEncoder().encodeToString(imageBytes);
    				%>
    						<input type="button" name="" class="leftbut" style="background-image: url(data:image/png;base64,<%= base64Encoded %>);  background-size: 45px;" onclick="show('click-choice'), hide('notification-box')">
    				<%
                    	}
                    	else {
					%>
						<input type="button" name="" class="leftbut" style="background-image: url(img/defaultavatar.jpg); background-size: 45px;" onclick="show('click-choice', 'notification-box')">
					<%
                    	}
					%> 
					<span id="click-choice" style="display: none;">
                    <div>
                        <button class="signout" onclick="signout()">Sign out</button>
                    </div>
	                </span>
	                <span id="notification-box" style="display: none;">
	                    <p class="notification-header">Notification</p>
	                    <%
	                    	ArrayList<Notification> notifications = (ArrayList<Notification>)request.getAttribute("notifications");
		                    for (int i = 0; i < notifications.size(); i++)
		            		{
		                    	int idpost = notifications.get(i).getID_Post();
		                    	int status = notifications.get(i).isStatus();
		                    	int idnoti = notifications.get(i).getID_Notification();
		                    	if(status == 0) {
		                    		if(notifications.get(i).getID_Commentator() == null) {
		                %>
		                				<!-- chua doc -->
					                    <div class="notification-content unseen" onclick="location.href='GrabServlet?showdetailpost=1&idpost=<%=idpost%>&status=<%=status%>&idnoti=<%=idnoti%>&idacc=<%= user.getID_Account()%>'">
					                        <div class="notification-ava" style="background-image: url(img/postfornoti.jpg);"></div>
					                        <p class="notification-text">Your post <b><%=notifications.get(i).getName_Post()%></b> <%=notifications.get(i).getMessage()%></p>
					                    	<p class="notification-text"><%= notifications.get(i).getDate_ago() %></p>
					                    </div>
		                <%	
		                    		}
		                    		else {
		                %>    			
		                    			<div class="notification-content unseen" onclick="location.href='GrabServlet?showdetailpost=1&idpost=<%=idpost%>&status=<%=status%>&idnoti=<%=idnoti%>&idacc=<%= user.getID_Account()%>'">
				                <%
			                    	if(notifications.get(i).getAvatar_Commentator() != null){
			                    		byte[] avacmtator = notifications.get(i).getAvatar_Commentator();
			    				    	String avatarcmt = Base64.getEncoder().encodeToString(avacmtator);
			    				%>
			    						<div class="notification-ava" style="background-image: url(data:image/png;base64,<%= avatarcmt %>);"></div>
			    				<%
			                    	}
			                    	else {
								%>
										<div class="notification-ava" style="background-image: url(img/defaultavatar.jpg);"></div>
								<%
			                    	}
								%> 
	                        				<p class="notification-text"><b><%=notifications.get(i).getName_Commentator()%></b> <%=notifications.get(i).getMessage()%> <b><%=notifications.get(i).getName_Post()%></b></p>
					                    	<p class="notification-text"><%= notifications.get(i).getDate_ago() %></p>
					                    </div>
		                <%    			
		                    		}
		                    	}
		                    	else {
		                    		if(notifications.get(i).getID_Commentator() == null) {
   		                %>
   		                				<!-- da doc -->
   					                    <div class="notification-content" onclick="location.href='GrabServlet?showdetailpost=1&idpost=<%=idpost%>&status=<%=status%>&idnoti=<%=idnoti%>&idacc=<%= user.getID_Account()%>'">
   					                        <div class="notification-ava" style="background-image: url(img/postfornoti.jpg);"></div>
   					                        <p class="notification-text">Your post <b><%=notifications.get(i).getName_Post()%></b> <%=notifications.get(i).getMessage()%></p>
   					                    	<p class="notification-text"><%= notifications.get(i).getDate_ago() %></p>
   					                    </div>
   		                <%	
   		                    		}
   		                    		else {
   		                %>    			
   		                    			<div class="notification-content" onclick="location.href='GrabServlet?showdetailpost=1&idpost=<%=idpost%>&status=<%=status%>&idnoti=<%=idnoti%>&idacc=<%= user.getID_Account()%>'">
   					            <%
			                    	if(notifications.get(i).getAvatar_Commentator() != null){
			                    		byte[] avacmtator = notifications.get(i).getAvatar_Commentator();
			    				    	String avatarcmt = Base64.getEncoder().encodeToString(avacmtator);
			    				%>
			    						<div class="notification-ava" style="background-image: url(data:image/png;base64,<%= avatarcmt %>);"></div>
			    				<%
			                    	}
			                    	else {
								%>
										<div class="notification-ava" style="background-image: url(img/defaultavatar.jpg);"></div>
								<%
			                    	}
								%> 
   	                        				<p class="notification-text"><b><%=notifications.get(i).getName_Commentator()%></b> <%=notifications.get(i).getMessage()%> <b><%=notifications.get(i).getName_Post()%></b></p>
   					                    	<p class="notification-text"><%= notifications.get(i).getDate_ago() %></p>
   					                    </div>
   		                <%    			
   		                    		}
	                    		}
		            		}
	                    %>
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