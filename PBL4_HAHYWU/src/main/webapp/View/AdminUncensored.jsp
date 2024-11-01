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
</head>
<body class="viewadmin" style="background-color: #89A1C9;">
<%  ArrayList<Post> listpost = (ArrayList<Post>) request.getAttribute("listpost"); %>
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
								for(int f=0; f<listpost.get(i).getlistFields().size(); f++)
								{
									fieldString = listpost.get(i).getlistFields().get(f).getName_Field();
									lifield.add(fieldString);
								}
							} 
							byte[] imageBytes = null;
							byte[] imageBytes2 = null;
							String avaAuthor = null;
							String imgPost = null;
							ArrayList<String> lipost = new ArrayList<String>();
							if (listpost.get(i).getAvatar_Author() != null){
								imageBytes = listpost.get(i).getAvatar_Author();
								avaAuthor = Base64.getEncoder().encodeToString(imageBytes);
							}
							if (listpost.get(i).getlistImages() != null){
								for(int k=0; k < listpost.get(i).getlistImages().size(); k++)
								{
									imageBytes2 = listpost.get(i).getlistImages().get(k).getImage();
									imgPost = Base64.getEncoder().encodeToString(imageBytes2);
									lipost.add(imgPost);
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
		                            	<div class="subject-content">
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
                                <% if (lipost.size() != 0)
                                {
                            		double s = 95/lipost.size();
                                    if(lipost.size() >= 5)
                                    {
                                    	s = 95/5;
                                    }
                                    for(int k=0; k < lipost.size(); k++)
                                    {
                                        %>
                                            <img id="content-image" style="width: <%=s%>%;" src="data:image/png;base64,<%= lipost.get(k) %>" alt="ảnh" onclick="img_tag_handler()">
                                        <%
                                    }
                            	} %>
                            </div>
                        </div>
                    </div>
                    <% } %>
                    <!--  -->
                </div>
                <div class="pure-u-6-24"></div>
            </div>
    <jsp:include page="zoomImage.jsp"></jsp:include>
</body>
</html>