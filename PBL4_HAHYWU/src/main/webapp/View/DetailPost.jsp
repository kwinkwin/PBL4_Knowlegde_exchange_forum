<%@page import="model.bean.Comment"%>
<%@page import="model.bean.Field"%>
<%@page import="model.bean.Post"%>
<%@page import="model.bean.User"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Base64"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>HAHYWU</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/purecss@3.0.0/build/pure-min.css" integrity="sha384-X38yfunGUhNzHpBaEBsWLO+A0HDYOQi8ufWDkZ0k9e0eXz/tH3II7uKZ9msv++Ls" crossorigin="anonymous">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/purecss@3.0.0/build/grids-responsive-min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/View/style01.css">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/View/style02.css">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/View/style03.css">
    <jsp:include page="HeaderUser.jsp" />
    <script>
	    function textAreaAdjust(element) {
	        var but1 = document.getElementById("but1");
	        var but2 = document.getElementById("but2");
	        // Set a minimum height if desired
	        const minHeight = 33; // Adjust this value as needed
	        // Resize function that adjusts the height based on the scrollHeight
	        const resizeTextArea = () => {
	            element.style.height = '1px'; // Temporarily shrink the element to auto height to get the correct scrollHeight
	            const newHeight = Math.max(element.scrollHeight, minHeight);
	            element.style.height = newHeight + 'px';
	            if(newHeight != 33) {
	                but1.style.top = (newHeight-20) + 'px';
	                but2.style.top = (newHeight-20) + 'px';
	            }
	            else {
	                but1.style.top = '11px';
	                but2.style.top = '11px';
	            }
	        };
	        // Event listener for textarea input
	        element.addEventListener('input', resizeTextArea);
	        // Event listener for keydown to specifically handle Enter and Backspace keys (optional)
	        element.addEventListener('keyup', function(event) {
	        if (event.key === 'Enter' || event.key === 'Backspace') {
	            // We will wait until the key action has taken effect before resizing
	            // setTimeout will run after the key action has taken effect
	            setTimeout(resizeTextArea, 0);
	        }
	        });
	        // Initial resizing in case we need to adjust from the default height on page load
	        resizeTextArea();
	    }
	    function adjustscrollbar(element) {
	        element.scrollIntoView(false);
	    }
	    function activate() {
	        var choosefile = document.getElementById("choose-comment-image");
	        choosefile.click();
	    }
	    function openComment() {
	    	var a = document.getElementById("comment-box");
	    	if(a.style.display === "none") {
	    		a.style.display = "block";
	            a.style.border = "1px solid #1B335B";
	    	} else {
	    		a.style.display = "none";
	            a.style.border = "none";
	    	}
	    }
	    function setImg() {
	        var closebutton = document.getElementById("close-comment-image");
	        var fileInput = document.getElementById("choose-comment-image");
	        var div = document.getElementById("comment-type-image");
	        var widthdiv = div.offsetWidth;
	
	        var images = document.querySelectorAll("#comment-type-image img");
	        for (var i = 0; i < images.length; i++) {
	            images[i].remove();
	        }
	
	        for (var i = 0; i < fileInput.files.length; i++) {
	            var image = document.createElement("img");
	            if(fileInput.files.length > 1) {
	                image.style.width = "calc(" + widthdiv + "px / " + fileInput.files.length + ")";
	                image.style.height = "100%";
	            } else {
	                image.style.height = "100%";
	            }
	            image.style.float = "left";
	            image.src = URL.createObjectURL(fileInput.files[i]);
	            div.appendChild(image);
	        }
	        div.style.display = "block";
	        closebutton.style.display = "block";
	    }
	    function removeImg() {
	        var images = document.querySelectorAll("#comment-type-image img");
	        var closebutton = document.getElementById("close-comment-image");
	        var div = document.getElementById("comment-type-image");
	        for (var i = 0; i < images.length; i++) {
	            images[i].remove();
	            closebutton.style.display = "none";
	        }
	        div.style.display = "none";
	    }
	    function sendComment(idpost, idauthor, idcommentator, cmttype, choosecmtimg) {
        	var cmtcontent = document.getElementById(cmttype).value;
            var fileInput = document.getElementById(choosecmtimg);
            var form = new FormData();
            form.append("sendcomment", 1);
            form.append("idpost", idpost);
            form.append("idauthor", idauthor);
            form.append("idcommentator", idcommentator);
            form.append("cmttype", cmtcontent);
            if (fileInput.files && fileInput.files[0]) {
            	var file = fileInput.files[0];
                form.append("cmtimg", file);
            }
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
	    function deleteComment(idpost, idcmt) {
            var form = new FormData();
            form.append("deletecomment", 1);
            form.append("idpost", idpost);
            form.append("idcmt", idcmt);
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
    <form action="" method="post">
        <div class="view" style="overflow: hidden; top: 80px; position: relative; z-index: 999">
			<div class="pure-u-6-24"></div>
			<div class="pure-u-12-24" style="position: relative">
				<%
					User user = (User)request.getAttribute("user");
					Post listpost = (Post) request.getAttribute("post");
					ArrayList<String> lifield = new ArrayList<String>();
					String fieldString = null;
					if(listpost.getlistFields().size() != 0)
					{
						for(int f=0; f<listpost.getlistFields().size(); f++)
						{
							fieldString = listpost.getlistFields().get(f).getName_Field();
							lifield.add(fieldString);
						}
					} 
					byte[] imageBytes = null;
					byte[] imageBytes2 = null;
					String avaAuthor = null;
					String imgPost = null;
					ArrayList<String> lipost = new ArrayList<String>();
					if (listpost.getAvatar_Author() != null){
						imageBytes = listpost.getAvatar_Author();
						avaAuthor = Base64.getEncoder().encodeToString(imageBytes);
					}
					if (listpost.getlistImages() != null){
						for(int k=0; k < listpost.getlistImages().size(); k++)
						{
							imageBytes2 = listpost.getlistImages().get(k).getImage();
							imgPost = Base64.getEncoder().encodeToString(imageBytes2);
							lipost.add(imgPost);
						}
					}
					ArrayList<Comment> commentlist = new ArrayList<Comment>();
					commentlist = listpost.getListComment();
					if(listpost.getCensor() == 1)
					{
				%>		
						<div style="width: 100%; background-color: white; border-radius: 30px; box-shadow: 4px 4px 10px grey; margin: 10px 0;">
						<!-- POST -->
						<!-- <div class="post" style="width: 100%; top: 150px !important; margin: 10px 0px; z-index: 9999;"> -->
						<div class="post" style="margin: 10px 0px; z-index: 9999; width: 100%">
							<div class="post-row">
							<% if (listpost.getAvatar_Author() != null)
								{%>
								<div>
                                	<a href="GrabServlet?visitprofile=1&idacc=<%= listpost.getID_Author() %>&idmain=<%=user.getID_Account()%>"><input type="button" name="" class="avapic" style="width: 60px; height: 60px; background-image: url(data:image/png;base64,<%= avaAuthor %>);"> </a>
                                </div>
							<% }
								else{
							%>
									<div>
	                                	<a href="GrabServlet?visitprofile=1&idacc=<%= listpost.getID_Author() %>&idmain=<%=user.getID_Account()%>"><input type="button" name="" class="avapic" style="width: 60px; height: 60px; background-image: url(img/defaultavatar.jpg);"> </a>
	                                </div>
							<%} %>
								<a href="GrabServlet?visitprofile=1&idacc=<%= listpost.getID_Author() %>&idmain=<%=user.getID_Account()%>"><input type="button" name="" class="user" value="<%= listpost.getName_Author() %>"></a>
								<input type="text" class="date" value="<%= listpost.getDate_ago() %>" readonly>
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
									<textarea name="" id="title" cols="0" rows="1" placeholder="Title"><%= listpost.getTitle() %></textarea>
									<p id="content-text" contenteditable style="white-space: pre-wrap; min-height: 1em;"><%= listpost.getContent() %></p>
									<% if(!listpost.getHastag().equals(""))
									{%>
									<textarea name="" id="hastag" cols="0" rows="1" placeholder="hastag"><%= listpost.getHastag() %></textarea>
									<%} %>
									<% if (lipost.size() != 0)
										{
											for(int k=0; k < lipost.size(); k++)
											{
												%>
													<img id="content-image" style="width: 100%;" src="data:image/png;base64,<%= lipost.get(k) %>" alt="ảnh">
												<%
											}
									} %>
								</div>
							</div>
							<% 	int cmts = listpost.getComment_Quantity();
								if(cmts == 0) { %> 
								<div class="post-row">
									<input type="button" class="bottom-text" style="position: static; float: right;" value="" onclick="openComment()">
								</div>
							<%  }
								else { %> 
								<div class="post-row">
									<input type="button" class="bottom-text" style="position: static; float: right;" value="<%=cmts%> comments" onclick="openComment()">
								</div>
							<%	} %>
						</div>
	
						<!-- COMMENT -->
				        <span class="comment" style="z-index: 999; display: none; margin-top: -35px" id="comment-box">
				            <span class="show-comment scroll">
		            	<% 
							if(commentlist.size() != 0)
							{
								for (int j=0; j < commentlist.size(); j++)
								{ 
									if(commentlist.get(j).getAvatar_Commentator() != null)
									{
										byte[] avacommentator = commentlist.get(j).getAvatar_Commentator();
			    				    	String avacmtor = Base64.getEncoder().encodeToString(avacommentator);
			    				    	if(commentlist.get(j).getImage() != null)
			    				    	{
			    				    		byte[] imagecmt = commentlist.get(j).getImage();
				    				    	String cmtimage = Base64.getEncoder().encodeToString(imagecmt);
				    	%>				
											<div class="one-comment">  <!-- Loop -->
							                    <div style="width: 5%; float: left;">
									                <a href="GrabServlet?visitprofile=1&idacc=<%= commentlist.get(j).getID_Commentator() %>&idmain=<%=user.getID_Account()%>"><input type="button" name="" class="avapic" style="background-image: url(data:image/png;base64,<%=avacmtor%>);margin-top: 5px; width: 33px; height: 33px;"> </a>
									            </div>
							                    <div style="width: 85%; position: relative;">
							                        <div class="commentinfor">
							                            <a href="GrabServlet?visitprofile=1&idacc=<%= commentlist.get(j).getID_Commentator() %>&idmain=<%=user.getID_Account()%>"><%= commentlist.get(j).getName_Commentator() %></a>
							                            <input type="text" value="<%= commentlist.get(j).getDate_ago() %>" readonly>
							                        </div>
							                        <p id="content-text" contenteditable style="white-space: pre-wrap; min-height: 1em; margin-bottom: 5px"><%= commentlist.get(j).getComment_Content() %></p>
							                        <span style="width: 100%; height: 100px; display: block; margin-bottom: 5px">
							                            <img src="data:image/png;base64,<%=cmtimage%>" alt="" style="height: 100%;">
							                        </span>
							                        <!-- DELETE COMMENT -->
							                        <input id="press-delete" type="button" class="press-delete" value="Delete" onclick="deleteComment('<%=listpost.getID_Post()%>','<%=commentlist.get(j).getID_Comment()%>')">  
							                    </div>
							                </div>
						<%			    	
			    				    	}
			    				    	else {
			    		%>				
											<div class="one-comment">  <!-- Loop -->
							                    <div style="width: 5%; float: left;">
									                <a href="GrabServlet?visitprofile=1&idacc=<%= commentlist.get(j).getID_Commentator() %>&idmain=<%=user.getID_Account()%>"><input type="button" name="" class="avapic" style="background-image: url(data:image/png;base64,<%=avacmtor%>);margin-top: 5px; width: 33px; height: 33px;"> </a>
									            </div>
							                    <div style="width: 85%; position: relative;">
							                        <div class="commentinfor">
							                            <a href="GrabServlet?visitprofile=1&idacc=<%= commentlist.get(j).getID_Commentator() %>&idmain=<%=user.getID_Account()%>"><%= commentlist.get(j).getName_Commentator() %></a>
							                            <input type="text" value="<%= commentlist.get(j).getDate_ago() %>" readonly>
							                        </div>
							                        <p id="content-text" contenteditable style="white-space: pre-wrap; min-height: 1em; margin-bottom: 5px"><%= commentlist.get(j).getComment_Content() %></p>
							                        <!-- DELETE COMMENT -->
							                        <input id="press-delete" type="button" class="press-delete" value="Delete" onclick="deleteComment('<%=listpost.getID_Post()%>','<%=commentlist.get(j).getID_Comment()%>')">
							                    </div>
							                </div>
						<%	
			    				    	}
									}
									else {
										if(commentlist.get(j).getImage() != null)
			    				    	{
			    				    		byte[] imagecmt = commentlist.get(j).getImage();
				    				    	String cmtimage = Base64.getEncoder().encodeToString(imagecmt);
				    	%>				
											<div class="one-comment">  <!-- Loop -->
							                    <div style="width: 5%; float: left;">
									                <a href="GrabServlet?visitprofile=1&idacc=<%= commentlist.get(j).getID_Commentator() %>&idmain=<%=user.getID_Account()%>"><input type="button" name="" class="avapic" style="background-image: url(defaultavatar.jpg);margin-top: 5px; width: 33px; height: 33px;"></a>
									            </div>
							                    <div style="width: 85%; position: relative;">
							                        <div class="commentinfor">
							                            <a href="GrabServlet?visitprofile=1&idacc=<%= commentlist.get(j).getID_Commentator() %>&idmain=<%=user.getID_Account()%>"><%= commentlist.get(j).getName_Commentator() %></a>
							                            <input type="text" value="<%= commentlist.get(j).getDate_ago() %>" readonly>
							                        </div>
							                        <p id="content-text" contenteditable style="white-space: pre-wrap; min-height: 1em; margin-bottom: 5px"><%= commentlist.get(j).getComment_Content() %></p>
							                        <span style="width: 100%; height: 100px; display: block; margin-bottom: 5px">
							                            <img src="data:image/png;base64,<%=cmtimage%>" alt="" style="height: 100%;">
							                        </span>
							                        <!-- DELETE COMMENT -->
							                        <input id="press-delete" type="button" class="press-delete" value="Delete" onclick="deleteComment('<%=listpost.getID_Post()%>','<%=commentlist.get(j).getID_Comment()%>')">  
							                    </div>
							                </div>
						<%			    	
			    				    	}
			    				    	else {
			    		%>				
											<div class="one-comment">  <!-- Loop -->
							                    <div style="width: 5%; float: left;">
									                <a href="GrabServlet?visitprofile=1&idacc=<%= commentlist.get(j).getID_Commentator() %>&idmain=<%=user.getID_Account()%>"><input type="button" name="" class="avapic" style="background-image: url(defaultavatar.jpg);margin-top: 5px; width: 33px; height: 33px;"></a>
									            </div>
							                    <div style="width: 85%; position: relative;">
							                        <div class="commentinfor">
							                            <a href="GrabServlet?visitprofile=1&idacc=<%= commentlist.get(j).getID_Commentator() %>&idmain=<%=user.getID_Account()%>"><%= commentlist.get(j).getName_Commentator() %></a>
							                            <input type="text" value="<%= commentlist.get(j).getDate_ago() %>" readonly>
							                        </div>
							                        <p id="content-text" contenteditable style="white-space: pre-wrap; min-height: 1em; margin-bottom: 5px"><%= commentlist.get(j).getComment_Content() %></p>
							                        <!-- DELETE COMMENT -->
							                        <input id="press-delete" type="button" class="press-delete" value="Delete" onclick="deleteComment('<%=listpost.getID_Post()%>','<%=commentlist.get(j).getID_Comment()%>')">
							                    </div>
							                </div>
						<%	
			    				    	}
									}
								}
							}
						%>
				                
				            </span>
				        </span>
	
						<!-- CREATE COMMENT -->
				        <span class="create-comment" style="z-index: 99; position: relative; display: flex;"> <!--display: none/flex-->
			            <% 	if(user.getAvatar() != null){
	                		byte[] ava = user.getAvatar();
					    	String base64Encoded = Base64.getEncoder().encodeToString(ava);
						%>
	                        <div style="width: 5%; float: left;">
	                        	<input type="button" name="" class="avapic" style="margin-top: 5px; width: 33px; height: 33px; background-image: url(data:image/png;base64,<%= base64Encoded %>);">
	                    	</div>
	                    <% 	}
							else {
						%>
	                        <div style="width: 5%; float: left;">
	                        	<input type="button" name="" class="avapic" style="background-image: url(img/defaultavatar.jpg); margin-top: 5px; width: 33px; height: 33px;">
	                    	</div>
	                          <%	} %>
				            <div style="width: 85%; position: relative;">
				                <textarea name="" value="" class="comment-type" id="comment-type" style="margin-top: 5px;" oninput="textAreaAdjust(this)"></textarea>
				                <input type="button" id="butSend" class="choose-more-button choose-image" style="background-image: url(img/send.jpg); right: 15px;" onclick="sendComment('<%=listpost.getID_Post()%>', '<%=listpost.getID_Author()%>', '<%=user.getID_Account()%>', 'comment-type', 'choose-comment-image')"> <!--Su kien onclick-->
				                <input type="button" id="butImage" class="choose-more-button choose-image" style="right: 45px;" onclick="activate();">
				                <input id="choose-comment-image" type="file"  accept="image/*" style="width: 100%; display: none;" onchange="setImg()">
				                <span style="width: 100%; height: 100px; display: none;" id="comment-type-image">
				                    <input type="button" id="close-comment-image" class="close-image" style="display: none; position: static; float: right; margin-right: 20px;" onclick="removeImg()">
				                </span>  
				            </div>    
				        </span>
	                </div>
				<%		
					}
					else {
				%>		
						<!-- POST -->
						<!-- <div class="post" style="width: 100%; top: 150px !important; margin: 10px 0px; z-index: 9999;"> -->
						<div class="post" style="margin: 10px 0px; z-index: 9999; width: 100%">
							<div class="post-row">
							<% if (listpost.getAvatar_Author() != null)
								{%>
								<div>
                                	<a href="GrabServlet?visitprofile=1&idacc=<%= listpost.getID_Author() %>&idmain=<%=user.getID_Account()%>"><input type="button" name="" class="avapic" style="width: 60px; height: 60px; background-image: url(data:image/png;base64,<%= avaAuthor %>);"> </a>
                                </div>
							<% }
								else{
							%>
								<div>
                                	<a href="GrabServlet?visitprofile=1&idacc=<%= listpost.getID_Author() %>&idmain=<%=user.getID_Account()%>"><input type="button" name="" class="avapic" style="width: 60px; height: 60px; background-image: url(img/defaultavatar.jpg);"> </a>
                                </div>
							<%} %>
								<a href="GrabServlet?visitprofile=1&idacc=<%= listpost.getID_Author() %>&idmain=<%=user.getID_Account()%>"><input type="button" name="" class="user" value="<%= listpost.getName_Author() %>"></a>
								<input type="text" class="date" value="<%= listpost.getDate_ago() %>" readonly>
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
									<textarea name="" id="title" cols="0" rows="1" placeholder="Title"><%= listpost.getTitle() %></textarea>
									<p id="content-text" contenteditable style="white-space: pre-wrap; min-height: 1em;"><%= listpost.getContent() %></p>
									<% if(!listpost.getHastag().equals(""))
									{%>
									<textarea name="" id="hastag" cols="0" rows="1" placeholder="hastag"><%= listpost.getHastag() %></textarea>
									<%} %>
									<% if (lipost.size() != 0)
										{
											for(int k=0; k < lipost.size(); k++)
											{
												%>
													<img id="content-image" style="width: 100%;" src="data:image/png;base64,<%= lipost.get(k) %>" alt="ảnh">
												<%
											}
									} %>
								</div>
							</div>
							</div>
				<%		
					}
				%>
				
            
            <div class="pure-u-6-24"></div>
        </div>
    </form>
    <jsp:include page="zoomImage.jsp"></jsp:include>
</body>
</html>