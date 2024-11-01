<%@page import="model.bean.NumberCensor"%>
<%@page import="model.bean.Post"%>
<%@page import="java.util.Base64"%>
<%@page import="model.bean.Field"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page language="java" import="model.bean.User" %>
<% User user = (User)request.getAttribute("acc"); %>
<% User main = (User)request.getAttribute("user"); %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/purecss@3.0.0/build/pure-min.css" integrity="sha384-X38yfunGUhNzHpBaEBsWLO+A0HDYOQi8ufWDkZ0k9e0eXz/tH3II7uKZ9msv++Ls" crossorigin="anonymous">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/View/style01.css">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/View/style02.css">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/View/style03.css">
    <script>
    	document.addEventListener("DOMContentLoaded", function() {
        	document.getElementById("mySelectField").value = <%= request.getAttribute("ID_Field") %>;
        	var s = document.getElementById("mysort");
            s.value = '<%= request.getAttribute("sort") %>';
        });
    
        function btsearch()
        {
            var field = document.getElementById("mySelectField").value;
            var l = "GrabServlet?visituserpost=1&IDField=" + field + "&censor=1&idacc=" + document.getElementById("acc").value 
            		+ "&idmain=" + document.getElementById("main").value
            		+ "&search=" + document.getElementById("txtsearch").value + "&sort=" + document.getElementById("mysort").value;;
            location = l;
        }
    </script>
    <style>
        * {
		    line-height: normal;
		}
        .topost {
            box-sizing: unset;
        }
        .cbb {
            box-sizing: unset;
        }
    </style>
</head>
<body class="scroll">
<%
     	ArrayList<Post> listpost = (ArrayList<Post>) request.getAttribute("listpost");
		int censoring=0, censored=0, uncensored=0;
		for (int i=0; i < listpost.size(); i++)
		{
			if(listpost.get(i).getCensor() == 1)
			{
				censored = censored + 1;
			}
		}
%>
    <form name="UserMoreInfo" action="">
        <section class="pure-g section4" style="padding: 10px 0 93px; position: absolute;">
            <div class="pure-u-2-24"></div>
            <div class="pure-u-6-24">
                <div class="userdetail">
                    <div class="pure-g" style="position: relative;">
                        <div class="pure-u-2-24"></div>
                        <div class="pure-u-20-24" style="position: relative;text-align: left;">
                            <input id="txtsearch" class="topost" type="text" name="searchpost" style="height: 37px;  width: 95%;" placeholder="Search" value="<%= request.getAttribute("searchtxt") %>">
                            <input class="searchpostbut" type="button" name="searchpostbut" onclick="btsearch()" style="height: 39px;">
                        </div>
                        <div class="pure-u-2-24"></div>
                    </div>
                    <div class="pure-g" style="position: relative;">
                        <div class="pure-u-2-24"></div>
                        <div class="pure-u-10-24" style="position: relative; text-align: left;">
                            <select id="mysort" class="cbb" style="margin: 10px 0px 0px 0px; width: 85%; padding: 7px; border-radius: 30px; border: 2px solid #1B335B; color: #1B335B;" onchange="btsearch()">
			                    <option value="DESC">Newest</option>
			                    <option value="ASC">Oldest</option>
			                </select>
		                </div>
                        <div class="pure-u-10-24">
                            <select id="mySelectField" class="cbb" style="margin: 10px 0px 0px 0px; width: 85%; padding: 7px; border-radius: 30px; border: 2px solid #1B335B; color: #1B335B;" onchange="btsearch()">
                                <option value="0">All Fields</option>
                                <!-- loop -->
                                <% ArrayList<Field> listFields = (ArrayList<Field>) request.getAttribute("listFields");
                                    for(int i=0; i<listFields.size(); i++)
                                    {
                                %>
                                    <option value="<%= listFields.get(i).getID_Field() %>"><%= listFields.get(i).getName_Field() %></option>
                                     <%} %>
                                <!--  -->
                            </select>  
                        </div>
                        <div class="pure-u-2-24"></div>
                    </div>
                    <hr class="straightline">
                    <div class="pure-g">
                        <div class="pure-u-2-24"></div>
                        <div class="pure-u-20-24" style="position: relative; ">
                            <div style="color: rgba(27, 51, 91, 0.66); font-size: 16px;">
                            <% NumberCensor nbCensor = (NumberCensor) request.getAttribute("nbCensor"); %>
                                <p class="first-column">Total: <input type="text" id="total" value="<%=  nbCensor.getCensored() %>" class="second-column" readonly></p>
                                <hr class="straightline" style="margin: 0;">
                            </div>
                        </div>
                        
                        <div class="pure-u-2-24"">
                        <input id="acc" type="text" value="<%= user.getID_Account() %>" hidden>
                        <input id="main" type="text" value="<%= main.getID_Account() %>" hidden>
                        </div>
                    </div>
                </div>
            </div>
            <div class="pure-u-16-24"></div>
        </section>
    </form>
</body>
</html>