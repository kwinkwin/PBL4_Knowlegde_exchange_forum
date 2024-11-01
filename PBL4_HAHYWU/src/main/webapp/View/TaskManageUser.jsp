<%@page import="model.bean.User"%>
<%@page import="model.bean.Account"%>
<%@page import="model.bean.Field"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% Account user = (Account)request.getAttribute("admin"); %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/purecss@3.0.0/build/pure-min.css" integrity="sha384-X38yfunGUhNzHpBaEBsWLO+A0HDYOQi8ufWDkZ0k9e0eXz/tH3II7uKZ9msv++Ls" crossorigin="anonymous">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/purecss@3.0.0/build/grids-responsive-min.css">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/View/style01.css">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/View/style02.css">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/View/style03.css">
    <script>
        document.addEventListener("DOMContentLoaded", function() {
        	document.getElementById("mySelect").value = <%= request.getAttribute("lock") %>;
        	var s = document.getElementById("mysort");
            s.value = '<%= request.getAttribute("sort") %>';
        });
        function search()
        {
            var l = "GrabServlet?ManageUser=1&lock=" + document.getElementById("mySelect").value 
            		+ "&sort=" + document.getElementById("mysort").value
            		+ "&search=" + document.getElementById("txtsearch").value 
            		+ "&idacc=" + document.getElementById("acc").value;
            location = l;
        }
	</script>
	<style>
       .searchadmin, ::after, ::before {
           box-sizing: unset;
       }	        
       * {
	    line-height: normal !important;
	}
    </style>
</head>
<body>
    <main>
        <div class="pure-g taskbar" style="z-index: 99999">
            <div class="pure-u-2-24"></div>
            <div class="pure-u-10-24">
            </div>
            <div class="pure-u-10-24 taskbarright">
            	<select id="mysort" class="cbb" style="width: 30%; padding: 7px; margin: auto 10px; border-radius: 30px; border: 2px solid #1B335B; color: #1B335B;" onchange="search()">
                    <option value="ASC">A to Z</option>
                    <option value="DESC">Z to A</option>
                </select>
            
                <select id="mySelect" class="cbb" style="width: 30%; padding: 7px; margin: auto 10px; border-radius: 30px; border: 2px solid #1B335B; color: #1B335B;" onchange="search()">
                    <option value="2">All</option>
					<option value="0">Unlocked</option>
					<option value="1">Locked</option>
                </select>  
                
                <input id="txtsearch" class="searchadmin" type="text" placeholder="Search" name="search" value="<%= request.getAttribute("searchtxt") %>" style="z-index: 1;">
                <input class="searchadminimg" type="button" name="searchbut" value="" onclick="search()" style="z-index: 2;">
            </div>
            <div class="pure-u-2-24"></div>
            <div hidden>
            	<input id="acc" type="text" value="<%= user.getID_Account() %>">
            </div>
        </div>
    </main>
    <footer>
    </footer>
</body>
</html>