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
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/View/style01.css">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/View/style02.css">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/View/style03.css">
    <jsp:include page="HeaderAdminPost.jsp" />
    <style>
       .searchadmin, ::after, ::before {
           box-sizing: unset;
       }	        
       * {
	    line-height: normal !important;
	}
    </style>
    <script>
		 // Khi mở popup, lưu trạng thái
	    function openPopup() {
	        // Code để mở popup
	        sessionStorage.setItem('popupStateCensoring', 'open');
	    }
	    // Khi đóng popup, cập nhật trạng thái
	    function closePopup() {
	        // Code để đóng popup
	        sessionStorage.setItem('popupStateCensoring', 'closed');
	    }
	    // Khi trang được load hoặc reload, kiểm tra trạng thái từ session storage
	    window.onload = function() {
	        var popupState = sessionStorage.getItem('popupStateCensoring');
	        if (popupState === 'open') {
	        	var a = document.getElementById("clickField");
	        	a.click();
	        }
	        var s = document.getElementById("mysort");
            s.value = '<%= request.getAttribute("sort") %>';
	    }

        document.addEventListener("DOMContentLoaded", function() {
        	document.getElementById("mySelect").value = '<%= request.getAttribute("ID_Field") %>';
        });
        function selectchoice() {
            var l = "GrabServlet?Censoring=1&IDField=" + document.getElementById("mySelect").value + "&search=" + document.getElementById("txtsearch").value
            		+ "&idacc=" + document.getElementById("acc").value  + "&sort=" + document.getElementById("mysort").value;
            location = l;
        }
        function add() 
        {
        	var n = document.getElementById("namefield").value;
            var form = new FormData();
            form.append("addField", n);
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
        function deletefield(idf) 
        {
            var form = new FormData();
            form.append("deleteField", idf);
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
<body>
    <main>
        <div class="pure-g taskbar">
            <div class="pure-u-2-24"></div>
            <div class="pure-u-10-24 taskbarleft">
                <a href=""><input id="Censoring" class="taskbarchoice" type="button" value="Censoring" onclick=""></a>
                <a href="GrabServlet?Censored=1&idacc=<%= user.getID_Account() %>"><input class="taskbarbutton" type="button" value="Censored"></a>
                <a href="GrabServlet?Uncensored=1&idacc=<%= user.getID_Account() %>"><input class="taskbarbutton" type="button" value="Uncensored"></a>
            </div>
            <div class="pure-u-10-24 taskbarright">
                <input class="taskbarfield" type="button" name="" id="clickField" value="Edit Field"  data-bs-toggle="modal" data-bs-target="#exampleModalToggle" onclick="openPopup()">
                <select id="mySelect" class="cbb" style="width: 30%; padding: 7px; margin: auto 0px 10px;" onchange="selectchoice()">
                    <option value="0">All</option>
                    <!-- loop -->
                    <% ArrayList<Field> listFields = (ArrayList<Field>) request.getAttribute("listFields");
                    	for(int i=0; i<listFields.size(); i++)
                    	{
                    %>
                    	<option value="<%= listFields.get(i).getID_Field() %>"><%= listFields.get(i).getName_Field() %></option>
             			<%} %>
                    <!--  -->
                </select> 
                <select id="mysort" class="cbb" style="width: 30%; padding: 7px; margin: auto 10px; border-radius: 30px; border: 2px solid #1B335B; color: #1B335B;" onchange="selectchoice()">
                    <option value="DESC">Newest</option>
                    <option value="ASC">Oldest</option>
                </select>
                <input id="txtsearch" class="searchadmin" type="text" placeholder="Search" name="search" value="<%= request.getAttribute("searchtxt") %>" style="z-index: 1;">
                <input class="searchadminimg" type="button" name="searchbut" value="" onclick="selectchoice()" style="z-index: 2;">
            </div>
            <div class="pure-u-2-24"></div>
        </div>

            <!-- Manage Field -->
        <div class="modal fade" id="exampleModalToggle" aria-hidden="true" aria-labelledby="exampleModalToggleLabel" tabindex="-1" data-bs-backdrop="static" style="z-index: 999999;">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content" style="background-color: white !important;">
                    <input class="btn-close" data-bs-dismiss="modal"  id="Button-close" type="button" value="" style="position: absolute;" onclick="closePopup()">
                    <div class="view">
                        <div class="pure-u-2-24"></div>
                        <div class="pure-u-20-24">
                            <table style="width: 100%;
                                                    border-collapse: collapse;
                                                    margin: 100px 0px 10px;
                                                    border-radius: 90px;">
                                <caption style="top: 40px; left: 44%; position: absolute;">
                                    <p style="color: var(--darkblue); font-size: 30px; font-weight: 800; margin: 0px auto;">Field</p>
                                </caption>
                                <tr>
                                    <td class="field-admin" style="width: 30%; font-weight: bolder; ">STT</td>
                                    <td class="field-admin" style="width: 50%; font-weight: bolder;">Name Field</td>
                                    <td class="field-admin" style="width: 20%; font-weight: bolder;">Action</td>
                                </tr>
                                <!-- Bỏ dô vòng for -->
                                <% 	ArrayList<Field> listFields1 = (ArrayList<Field>) request.getAttribute("listFields");
                            		for(int i=0; i<listFields.size(); i++)
                            	{ %>
                                <tr>
                                    <td class="field-admin" style="width: 30%; font-weight: bolder;">
                                        <p class="noidung" style="white-space: pre-wrap; min-height: 1em;"><%= i + 1 %></p>
                                    </td>
                                    <td class="field-admin" style="width: 50%; font-weight: bolder;">
                                        <p class="noidung" style="white-space: pre-wrap; min-height: 1em;"><%= listFields1.get(i).getName_Field() %></p>
                                    </td>
                                    <td class="field-admin" style="width: 20%; font-weight: bolder;">
                                        <a><input type="button" value="Delete" onclick="deletefield('<%= listFields1.get(i).getID_Field() %>')"></a>
                                    </td>
                                </tr>
                                <%} %>
                                <!--  -->
                                <tr>
                                    <td colspan="2" class="field-admin" style="font-weight: bolder;">
                                        <input id="namefield" name="namefield" maxlength="20" type="text" placeholder="New field" style="border: none; width: 100%; padding: 5px 0px;">
                                    </td>
                                    <td class="field-admin" style="width: 20%; font-weight: bolder;">
                                        <a href=""><input type="button" value="Add" onclick="add()"></a>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="pure-u-2-24"></div>
                        <div hidden>
                            <input id="acc" type="text" value="<%= user.getID_Account() %>">
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </main>
    <jsp:include page="AdminCensoring.jsp" />
    <footer>
    </footer>
</body>
</html>