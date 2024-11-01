<%@page import="model.bean.Account"%>
<%@page import="model.bean.Field"%>
<%@page import="model.bean.Post"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Base64"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
    <style>
        * {
		    line-height: normal;
		}
		p {
			margin-bottom: 0px;
		}
		.post, ::after, ::before {
            box-sizing: unset;
        }		
        .searchresult {
			color: #1B335B;
			font-size: 20px;
			font-weight: 800;
			text-align: left;
		}
		.searchresult1 {
			color: #1B335B;
			font-size: 14px;
			text-align: left;
		}
		mark {
		    background-color: #FFCAB6;
		    color: #1B335B;
            margin: 0px;
            padding: 0px;
		}	        
    </style>
    <script>
    
        function censored(idp)
        {
            document.getElementById("idcensored").value = idp;
        }
        function sendsensor()
        {
            var idp = document.getElementById("idcensored").value;
            var form = new FormData();
            form.append("censoredidp", idp);
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
    	
        function uncensored(id) {
            document.getElementById("idp").value = id;
        }
        function txtReasons()
        {
            var r1 = document.getElementById('rs1').checked;
            var r2 = document.getElementById('rs2').checked;
            var r3 = document.getElementById('rs3').checked;
            var txt = document.getElementById('reasons');
            if(r1)
            {
                txt.value = "this content does not match the field";
                if(r2)
                {
                    txt.value = txt.value + ", this content is inappropriate";
                }
                if(r3)
                {
                    txt.value = txt.value + ", " + document.getElementById('rs3txt').value;
                }
            }
            else if(r2)
            {
                txt.value = "this content is inappropriate";
                if(r3)
                {
                    txt.value = txt.value + ", " + document.getElementById('rs3txt').value;
                }
            }
            else if(r3)
            {
                txt.value = document.getElementById('rs3txt').value;
            }
            var l = "GrabServlet?Censoring=1&IDPost=" + document.getElementById("idp").value + "&AllReasons=" 
            + txt.value + "&idacc=" + document.getElementById("acc").value + "&IDField=" + document.getElementById("idfield").value
            + "&sort=" + document.getElementById("idsort").value + "&search=" + document.getElementById("txtsearch").value;
            location = l;
        }
    </script>
</head>
<body class="viewadmin" style="background-color: #89A1C9;">
<%  Account acc = (Account) request.getAttribute("admin");
	ArrayList<Post> listpost = (ArrayList<Post>) request.getAttribute("listpost"); %>

        <div class="view" style="heigth: 100%; top: 150px;">
            <div class="pure-u-6-24"></div>
            <div class="pure-u-12-24">
            <% if(!request.getAttribute("searchtxt").equals(""))
           		{%>
				<p class="searchresult" style="top: 150px; position: relative;">Post search results</p>
				<p class="searchresult1" style="top: 150px; position: relative;"><b><%= listpost.size() %></b> results for <b><%= request.getAttribute("searchtxt") %></b></p>
                <hr class="straightline" style="top: 150px; position: relative; margin: 10px 0 0;">
            <%} %>
            
                <!-- Bỏ dô vòng for -->
                <%
                    for (int i=0; i < listpost.size(); i++)
                    {
                        ArrayList<String> lifield = new ArrayList<String>();
                        String fieldString = null;
                        if(listpost.get(i).getlistFields().size() != 0)
                        {
                            for(int f=0; f < listpost.get(i).getlistFields().size(); f++)
                            {
                                fieldString = listpost.get(i).getlistFields().get(f).getName_Field();
                                lifield.add(fieldString);
                            }
                        } 
                        byte[] imageBytes = null;
                        byte[] imageBytes2 = null;
                        String avaAuthor = null;
                        String imgPost = null;
                        ArrayList<String> listimg = new ArrayList<String>();
                        if (listpost.get(i).getAvatar_Author() != null){
                            imageBytes = listpost.get(i).getAvatar_Author();
                            avaAuthor = Base64.getEncoder().encodeToString(imageBytes);
                        }
                        if (listpost.get(i).getlistImages() != null){
                            for(int k=0; k < listpost.get(i).getlistImages().size(); k++)
                            {
                                imageBytes2 = listpost.get(i).getlistImages().get(k).getImage();
                                imgPost = Base64.getEncoder().encodeToString(imageBytes2);
                                listimg.add(imgPost);
                            }
                        }
                %>
                <div class="post" style="width: 100%; top: 150px !important; margin: 10px 0px;">
                    <div class="post-row">
                    <% if (listpost.get(i).getAvatar_Author() != null)
                        {%>
                        <div class="avapic" style="width: 60px; height: 60px; background-image: url(data:image/png;base64,<%= avaAuthor %>);"></div>
                    <% }
                        else{
                    %>
                            <div class="avapic" style="width: 60px; height: 60px; background-image: url(img/defaultavatar.jpg);"></div>
                    <%} %>
                        <input type="text" name="" class="user" value="<%= listpost.get(i).getName_Author() %>" readonly>
                        <input type="text" class="date" value="<%= listpost.get(i).getDate_ago() %>" readonly>
                        <div id="subject">
                        <% 
                            if(lifield.size() != 0)
                            {
                                for (int j=0; j < lifield.size(); j++)
                                { 
                        %>
                                    <div class="subject-content" style="font-size: 14px !important;">
                                    <%= lifield.get(j) %>
                                    </div>
                                <% }
                        } %> 
                        </div>
                    </div>
                    <div class="post-row">
                        <div class="post-content">
                            <% if(!listpost.get(i).getTitle().equals(""))
							{%>
								<p id="title" contenteditable style="white-space: pre-wrap; min-height: 1em;"><%= listpost.get(i).getTitle() %></p>
							<%}%>
                               <% if(!listpost.get(i).getContent().equals(""))
							{%>
								<p id="content-text" contenteditable style="white-space: pre-wrap; min-height: 1em;"><%= listpost.get(i).getContent() %></p>
							<%}%>
                            <% if(!listpost.get(i).getHastag().equals(""))
                           	{%>
                           		<p id="hastag" contenteditable style="white-space: pre-wrap; min-height: 1em;"><%= listpost.get(i).getHastag() %></p>
                           	<%} %>
                            <% if (listimg.size() != 0)
                                {
                            		double s = 95/listimg.size();
                                    if(listimg.size() >= 5)
                                    {
                                    	s = 95/5;
                                    }
                                    for(int k=0; k < listimg.size(); k++)
                                    {
                                        %>
                                            <img id="content-image" style="width: <%=s%>%;" src="data:image/png;base64,<%= listimg.get(k) %>" alt="ảnh" onclick="img_tag_handler()">
                                        <%
                                    }
                            } %>
                        </div>
                    </div>
                    <div class="post-row">
                        <div class="post-content">
                            <a>
                            	<input type="button" name="" class="btCensor" data-bs-target="#censoredcheck" data-bs-toggle="modal"  value="Censored" onclick="censored('<%= listpost.get(i).getID_Post() %>')">
                            </a>
                            <input type="button" name="" class="btUncensor" value="Uncensored" data-bs-target="#exampleModalToggle1" data-bs-toggle="modal" onclick="uncensored(<%= listpost.get(i).getID_Post() %>)">
                        </div>
                    </div>
                </div>
                <% } %>
                <!--  -->
            </div>
            <div class="pure-u-6-24"></div>
        </div>
        
        <!-- Reason -->
        <div class="modal" id="exampleModalToggle1" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="reasonform">
                    <input class="btn-close" data-bs-dismiss="modal" id="Button-close" type="button" value="" style="background-image: url(img/Close2.png); position: relative; top: 21px; right: -465px;">
                    <div class="reason">
                        <p class="p-30">- REASON -</p>
                        <div class="rs">
                            <div class="rstxt">
                                <input id="rs1" type="checkbox" class="checkbox">
                                <label for="rs1" class="p-16">this content does not match the field</label>
                            </div>
                            <div class="rstxt">
                                <input id="rs2" type="checkbox" class="checkbox">
                                <label for="rs2" class="p-16">this content is inappropriate</label>
                            </div>
                            <div class="rstxt">
                                <input id="rs3" type="checkbox" class="checkbox" onchange="document.getElementById('otherrs').hidden = !this.checked;">
                                <label for="rs3" class="p-16">Other</label>
                            </div>
                            <div id="otherrs" class="rstxt" hidden style="padding: 0px 13px !important;">
                                <input id="rs3txt" type="text" class="otherreason" placeholder="Other" style="border: none; padding: 1px;" required>
                            </div>
                        </div>
                        <div class="bt">
                            <a id="saveReason" href="" onclick="txtReasons()"><input type="submit" class="Button-or-bl" value="Save"></a>
                            <input type="reset" class="Button-or-bl" value="Reset">
                        </div>
                        <div hidden>
                            <input id="reasons" type="text" value="">
                            <input id="idsort" type="text" value="<%= request.getAttribute("sort") %>">
                            <input id="txtsearch" type="text" value="<%= request.getAttribute("searchtxt") %>">
                            <input id="idfield" type="text" value="<%= request.getAttribute("ID_Field") %>">
                            <input id="acc" type="text" value="<%= acc.getID_Account() %>">
                            <input id="idp" type="text" value="">
                        </div>
                    </div>
                </div>
            </div>
            </div>
        </div>
    	
    	<div class="modal" id="censoredcheck" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="reasonform" style="padding-bottom: 10px;">
                    <div class="reason">
                        <p style="font-size: 20px; font-weight: bold; color: #1B335B; margin: 10px 0px;">Are you sure to censor this post?</p>
                        <div class="bt">
	                        <input type="button" class="Button-or-bl" value="Yes" onclick="sendsensor()">
	                        <input type="button" data-bs-dismiss="modal" class="Button-or-bl" value="No">
	                    </div>
                    </div>
                </div>
            </div>
            </div>
        </div>
        
        <div hidden>
            <input id="idcensored" type="text" value="">
        </div>
        <jsp:include page="zoomImage.jsp"></jsp:include>
</body>
</html>