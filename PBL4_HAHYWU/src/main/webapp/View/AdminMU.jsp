<%@page import="model.bean.Account"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Base64"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page language="java" import="model.bean.User" %>
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
   	<jsp:include page="HeaderAdminMU.jsp" />
   	<jsp:include page="TaskManageUser.jsp" />
    <style>
        .p-detail {
            position: absolute !important; 
            left: 115px !important;
            white-space: pre-wrap; 
            min-height: 1em;
            color: rgba(27, 51, 91, 0.66);
            font-size: 14px !important;
            background-color: transparent;
            pointer-events: none;
            margin: 0px;
        }
        .p-status {
            white-space: pre-wrap; 
            min-height: 1em; 
            bottom: 0px; 
            right: 30px; 
            position: absolute; 
            margin: 0px;
            color: #F1916D;
        }
    </style>
    <script>
        function lock(status, id)
        {
            document.getElementById("status").value = status;
            document.getElementById("idacc").value = id;
        }
        function sendlock()
        {
            var status = document.getElementById("status").value;
            var idacc = document.getElementById("idacc").value;
            var form = new FormData();
            form.append("ManageUser", 1);
            form.append("status", status);
            form.append("idacc", idacc);
            fetch("GrabServlet", {
                method: 'POST',
                body: form
            })
            .then(response => response.text())
            .then(data => {
                console.log(data);
                window.location.reload();
            })
            .catch((error) => {
                console.error('Error:', error);
            });
        }
    </script>
</head>
<body class="viewuser" style="background-color: #89A1C9;">
<% ArrayList<User> listacc = (ArrayList<User>) request.getAttribute("listUser"); 
	Account user = (Account)request.getAttribute("admin");
%>
    <div class="view" style="heigth: 100%; top: 150px;">
        <div class="pure-u-6-24"></div>
        <div class="pure-u-12-24" style="position: relative; top: 150px;"> 
        	<% if(!request.getAttribute("searchtxt").equals(""))
           		{%>
				<p class="searchresult" style="margin: 0;">Post search results</p>
				<p class="searchresult1" style="margin: 0;"><b><%= listacc.size() %></b> results for <b><%= request.getAttribute("searchtxt") %></b></p>
                <hr class="straightline" style="margin: 10px 0 0;">
            <%} %>
            
            <%
            for(int a=0; a < listacc.size(); a++)
            {%>
            <div class="post" style="width: 100%; margin: 10px 0px;">
                <div class="post-row">
                    <% if (listacc.get(a).getAvatar() != null)
                        {
                        byte[] imageBytes = listacc.get(a).getAvatar();
                        String base64Encoded = Base64.getEncoder().encodeToString(imageBytes);
                        %>
                            <div>
                                <a href="GrabServlet?visitprofile=1&idacc=<%= listacc.get(a).getID_Account() %>&idmain=<%=user.getID_Account()%>"><input type="button" name="" class="avapic" style="width: 60px; height: 60px; background-image: url(data:image/png;base64,<%= base64Encoded %>);"> </a>
                            </div>
                        <% }
                            else{
                        %>
                            <div>
                                <a href="GrabServlet?visitprofile=1&idacc=<%= listacc.get(a).getID_Account() %>&idmain=<%=user.getID_Account()%>"><input type="button" name="" class="avapic" style="width: 60px; height: 60px; background-image: url(img/defaultavatar.jpg);"> </a>
                            </div>
                        <% } %>
                    <div style="float: left;">
                        <a href="GrabServlet?visitprofile=1&idacc=<%= listacc.get(a).getID_Account() %>&idmain=<%=user.getID_Account()%>"><input type="button" class="user" style="white-space: pre-wrap; min-height: 1em;" value="<%= listacc.get(a).getDisplay_Name() %>"></a>
                        <% if(listacc.get(a).getTotalPost() != 0){ %>
                            <p class="p-detail" contenteditable style="bottom: 18px !important;"><%= listacc.get(a).getTotalPost() %> post</p>
                        <%} %>
                        <% if(listacc.get(a).getReported_Quantity() != 0){ %>
                        <p class="p-detail" contenteditable style="bottom: 0px !important; color: #F1916D;"><%= listacc.get(a).getReported_Quantity() %> reported</p>
                        <%} %>
                    </div>
                    <% if(listacc.get(a).getStatus() == 1){ %>
                        <p class="p-status" contenteditable>Locked: <%= listacc.get(a).getLocked_Ago() %></p>
                    <%}%>
                </div>
                <% if(listacc.get(a).getStatus() == 1){ %>
                    <input type="button" name="" class="btCensor" value="Unlock" data-bs-target="#unlockcheck" data-bs-toggle="modal" style="position: absolute; top: 20px; right: 30px;" onclick="lock(0, '<%= listacc.get(a).getID_Account() %>')">
                <%}%>  
                <% if(listacc.get(a).getStatus() == 0){ %>
                    <input type="button" name="" class="btUncensor" value="Lock" data-bs-target="#lockcheck" data-bs-toggle="modal" style="position: absolute; top: 20px; right: 30px;" onclick="lock(1, '<%= listacc.get(a).getID_Account() %>')">
                <%}%>   
            </div>
            <%}%>
        </div> 
        </div>
        <div class="pure-u-6-24"></div>
    </div>
        
        <div class="modal" id="lockcheck" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="reasonform" style="padding-bottom: 10px;">
                    <div class="reason">
                        <p style="font-size: 20px; font-weight: bold; color: #1B335B; margin: 10px 0px;">Are you sure to lock this account?</p>
                        <div class="bt">
	                        <input type="button" class="Button-or-bl" value="Yes" onclick="sendlock()">
	                        <input type="button" data-bs-dismiss="modal" class="Button-or-bl" value="No">
	                    </div>
                    </div>
                </div>
            </div>
            </div>
        </div>
        
        <div class="modal" id="unlockcheck" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="reasonform" style="padding-bottom: 10px;">
                    <div class="reason">
                        <p style="font-size: 20px; font-weight: bold; color: #1B335B; margin: 10px 0px;">Are you sure to unlock this account?</p>
                        <div class="bt">
	                        <input type="button" class="Button-or-bl" value="Yes" onclick="sendlock()">
	                        <input type="button" data-bs-dismiss="modal" class="Button-or-bl" value="No">
	                    </div>
                    </div>
                </div>
            </div>
            </div>
        </div>
        
        <div hidden>
            <input id="status" type="text" value="">
            <input id="idacc" type="text" value="">
        </div>
</body>
</html>