<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page language="java" import="model.bean.User" %>
<% User main = (User)request.getAttribute("user"); %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User PI</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/View/style01.css">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/View/style02.css">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/View/style03.css">
    <% if(main.getRole_Account() == 0) { %>
    	<jsp:include page="HeaderAdmin.jsp" />
    <%} 
    else {%>
   		<jsp:include page="HeaderUser.jsp" />
   	<%} %>
   	<jsp:include page="VisitProfileTopPI.jsp" />
   	<Script language="JavaScript">
    	
    </Script>
</head>
<body class="bgbody scroll" style="background-color: white;">
<% User user = (User)request.getAttribute("acc"); %>
    <form action="GrabServlet?idacc=<%= user.getID_Account() %>" method="post">
        <div class="container-fluid mt-3">
            <div class="row">
                <div class="col-sm-1"></div>
                <div class="col-sm-10 child">
                    <div class="headform">
                        <p class="p-30">- PERSONAL INFORMATION -</p>
                        <div class="lineform"></div>
                    </div>
                    <div class="bodyform">
                        <div class="info-h1">
                            <div class="info">
                                <p class="p-12">Name</p>
                                <input class="infotext" type="text" name="name" value="<%= user.getDisplay_Name() %>" readonly>
                            </div>
                            <div class="info" style="margin: 0px 5%;">
                                <p class="p-12">Birthday</p>
                                <input class="infotext" type="date" name="birthday" value="<%= user.getBirthday() %>" readonly>
                            </div>
                            <div class="info">
                                <p class="p-12">Gender</p>
                                <select class="infotext" name="gender" disabled>
                                <% if(user.getGender() == 0) {
                               	%>
                               		<option id="male" value="0" selected>Male</option>
                                    <option id="female" value="1">Female</option>
                                    <option id="other" value="2">Other</option>
                                <% }
                                   else if(user.getGender() == 1) {
                                %>
                                	<option id="male" value="0">Male</option>
                                    <option id="female" value="1" selected>Female</option>
                                    <option id="other" value="2">Other</option>
                                <% }
                                   else {
                                %>
                                	<option id="male" value="0">Male</option>
                                    <option id="female" value="1">Female</option>
                                    <option id="other" value="2" selected>Other</option>
                                <% }	
                                %>
                               
                                </select>
                            </div>
                        </div>
                        <div class="info-h1">
                            <div class="info">
                                <p class="p-12">Career</p>
                          <%
                          	if(user.getCareer() == null) {
                          %>		
                          		<input class="infotext" type="text" name="career" value="" readonly>
                          <%		
                          	}
                          	else {
                          %>		
                          		<input class="infotext" type="text" name="career" value="<%= user.getCareer() %>" readonly>
                          <%		
                          	}
                          %>
                            </div>
                            <div class="info" style="margin: 0px 5%;">
                                <p class="p-12">Mail</p>
                                <input class="infotext" type="text" name="email" value="<%= user.getEmail_Address() %>" readonly>
                            </div>
                            <div class="info">
                                <p class="p-12">Phone</p>
                          <%
                          	if(user.getPhone_Number() == null) {
                          %>		
                          		<input class="infotext" type="text" name="number" value="" readonly>
                          <%		
                          	}
                          	else {
                          %>		
                          		<input class="infotext" type="text" name="number" value="<%= user.getPhone_Number() %>" readonly>
                          <%		
                          	}
                          %>
                            </div>
                        </div>
                        <div class="info-h1">
                            <div class="info">
                                <p class="p-12">Address</p>
                          <%
                          	if(user.getAddress() == null) {
                          %>		
                          		<input class="infotext" type="text" name="address" value="" readonly>
                          <%		
                          	}
                          	else {
                          %>		
                          		<input class="infotext" type="text" name="address" value="<%= user.getAddress() %>" readonly>
                          <%		
                          	}
                          %>
                            </div>
                            <div class="info-h2" style="margin-left: 5%;">
                                <p class="p-12">Bio</p>
                          <%
                          	if(user.getBio() == null) {
                          %>		
                          		<input class="infotext" type="text" name="bio" value="" readonly>
                          <%		
                          	}
                          	else {
                          %>		
                          		<input class="infotext" type="text" name="bio" value="<%= user.getBio() %>" readonly>
                          <%		
                          	}
                          %>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-sm-1"></div>
            </div>
        </div>
    </form>
</body>
</html>