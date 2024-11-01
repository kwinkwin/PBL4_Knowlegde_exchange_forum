<%@page import="java.util.Base64"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page language="java" import="model.bean.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/purecss@3.0.0/build/pure-min.css" integrity="sha384-X38yfunGUhNzHpBaEBsWLO+A0HDYOQi8ufWDkZ0k9e0eXz/tH3II7uKZ9msv++Ls" crossorigin="anonymous">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/purecss@3.0.0/build/grids-responsive-min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/View/style01.css">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/View/style02.css">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/View/style03.css">
    <script>
    function reportUser(idacc) {
    	document.getElementById("reportid").value = idacc;
    }
    function sendreport()
    {
        var idacc = document.getElementById("reportid").value;
        var xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function() {
            if (this.readyState == 4 && this.status == 200) {
                if(this.responseText == "Report successfully!") {
                    var a = document.getElementById("alertsuccessful-noti"); 
                    var change = document.createElement("button");
                    change.dataset.bsToggle = "modal"; // gán giá trị cho data-bs-toggle
                    change.dataset.bsTarget = "#exampleModalToggle"; // gán giá trị cho data-bs-target
                    change.hidden = true;
                    a.appendChild(change);  // thêm phần tử vào trang web
                    change.click();
                }
            }
        };
        xmlhttp.open("GET", "GrabServlet?reportuser=1&idacc="+idacc, true);
        xmlhttp.send();
    }
    </script>
</head>
<body <% User user = (User)request.getAttribute("acc");%>>
<!--     <form name="UserTop" action=""> -->
	<% User main = (User)request.getAttribute("user"); %>
        <div class="pure-g" style="z-index: 999;">
            <div class="pure-u-2-24" style="background-color: white; height: 340px;"></div>
            <div class="pure-u-20-24 topcenter" style="left: 0%;">
                <div class="top">
                    <div class="ava">
                    <%
                    	if(user.getAvatar() != null){
                    		byte[] imageBytes = user.getAvatar();
    				    	String base64Encoded = Base64.getEncoder().encodeToString(imageBytes);
    				    	%>
	   						<img src="data:image/png;base64,<%= base64Encoded %>" alt="ava">
	   						<%}
                    	else {
                    	%>
							<img src="img/defaultavatar.jpg" alt="ava">
							<%}%> 
	                </div>
	                    <input type="text" class="topcontent" value="<%= user.getDisplay_Name() %>" readonly>
	                    <input type="button" class="more exclamation" title="Report this user" onclick="reportUser('<%= user.getID_Account() %>')" data-bs-target="#reportcheck" data-bs-toggle="modal">
	            </div>
	                <hr class="straightline" style="background-color: #89A1C9; height: 5px; border-radius: 90px;">
	                <div class="menu-top">
	                    <a href="GrabServlet?visitprofile=1&idacc=<%= user.getID_Account() %>&idmain=<%= main.getID_Account() %>">
	                    	<input class="menu-top-button" type="button" value="Information">
	                    </a>
	                    <a href=""><input class="menu-top-button" type="button" value="Post" style="background-color: #89A1C9;"></a>
	               	</div>            
            </div>
            <div class="pure-u-2-24" style="background-color: white; height: 340px;"></div>
        </div>
<!--     </form> -->
		<div id="alertsuccessful-noti"></div>
		<div class="modal" id="exampleModalToggle" aria-hidden="true" aria-labelledby="exampleModalToggleLabel" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="alert-report">
                   <img src="img/successfully.png" alt="error">
                   <p>REPORT SUCCESSFULLY</p>
                </div>
            </div>
            </div>
        </div>
        
        <div class="modal" id="reportcheck" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="reasonform" style="padding-bottom: 10px;">
                    <div class="reason">
                        <p style="font-size: 20px; font-weight: bold; color: #1B335B; margin: 10px 0px;">Are you sure to report this user?</p>
                        <div class="bt">
	                        <input type="button" class="Button-or-bl" value="Yes" onclick="sendreport()">
	                        <input type="button" data-bs-dismiss="modal" class="Button-or-bl" value="No">
	                    </div>
                    </div>
                </div>
            </div>
            </div>
        </div>
        <div hidden>
            <input id="reportid" type="text" value="">
        </div>
</body>
</html>
