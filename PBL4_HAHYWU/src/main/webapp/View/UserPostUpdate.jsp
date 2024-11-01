<%@page import="java.text.SimpleDateFormat"%>
<%@page import="model.bean.Post"%>
<%@page import="java.util.Base64"%>
<%@page import="model.bean.Field"%>
<%@page import="java.util.ArrayList"%>
<%@ page import="java.util.Date" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page language="java" import="model.bean.User" %>
<% User user = (User)request.getAttribute("user"); %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/purecss@3.0.0/build/pure-min.css" integrity="sha384-X38yfunGUhNzHpBaEBsWLO+A0HDYOQi8ufWDkZ0k9e0eXz/tH3II7uKZ9msv++Ls" crossorigin="anonymous">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/View/style01.css">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/View/style02.css">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/View/style03.css">
    <jsp:include page="HeaderUser.jsp" />
    <script>
	    function caichido2(element)
	    {
	        element.style.height = '1px';
	        element.style.height = (25 + element.scrollHeight) + 'px';
	    }
        function activate() {
            var choosefile = document.getElementById("choosefile");
            choosefile.click();
        }
        function setImg() {
            var closebutton = document.getElementById("close-image-button");
            var fileInput = document.getElementById("choosefile");
            var div = document.getElementById("set-img");
            var widthdiv = div.offsetWidth;
            for (var i = 0; i < fileInput.files.length; i++) 
            {
            	var a = "myImage" + i;
                var image = document.createElement("img");
                image.setAttribute("id", a);
                image.style.width = "calc(" + widthdiv + "px / " + fileInput.files.length + ")";
                image.style.height = "100%";
                image.style.float = "left";
                image.src = URL.createObjectURL(fileInput.files[i]);
                div.appendChild(image);
            }
            closebutton.style.display = "block";
        }
        function removeImg() {            
            var images = document.querySelectorAll("#set-img img");
            var closebutton = document.getElementById("close-image-button");
            var fileInput = document.getElementById("choosefile");
            for (var j = 0; j < fileInput.length; j++)
            {
                fileInput.file[j].remove();
            }
            for (var i = 0; i < images.length; i++) {
                images[i].remove();
                closebutton.style.display = "none";
            }
        }
        function adjustscrollbar2(element) {
            element.scrollIntoView(false);
        }
        function clickfield()
        {
            var b = document.getElementById("clicknewfield");
            b.click();
        }
        function choosefield(id)
        {
            var name = document.getElementById("f" + id).innerHTML;
            var idf = "idfield" + id;
            if(document.getElementById("checkbox" + id).checked == true)
            {
                var subjectDiv = document.getElementById("subject");
                var newDiv = document.createElement("div");
                newDiv.className = "subject-content";
                newDiv.setAttribute("id", idf);
                newDiv.innerHTML = name;
                subjectDiv.appendChild(newDiv);
            }
            else
            {
                document.getElementById(idf).remove();
            }
        }

        function saveupdate() {
            var idpost = document.getElementById("idpost").value;
            var idacc = document.getElementById("acc").value;
            var title = document.getElementById("title").value;
            var datepost = document.getElementById("datepost").value;
            var content = document.getElementById("content-text").value;
            var hastag = document.getElementById("hastag").value;
            var fileInput = document.getElementById("choosefile");
            var numberimg = fileInput.files.length;
            var numberfields = document.getElementById("nbfield").value;
            var images = document.querySelectorAll("#set-img img").length;
            var form = new FormData();
            form.append("idupdate", idpost);
            form.append("idacc", idacc);
            form.append("title", title);
            form.append("datepost", datepost);
            form.append("content", content);
            form.append("hastag", hastag);
            form.append("numberimg", numberimg);
            form.append("numberfields", numberfields);
            if(images > 0 && fileInput.files.length == 0)
            {
                form.append("checkimg", 1); // img còn nguyên
            }
            else if(images > fileInput.files.length)
            {
                form.append("checkimg", 2); // có ảnh mới
            }
            else if(images = 0 && fileInput.files.length == 0)
            {
                form.append("checkimg", 3); // xóa img
            }
            else
            {
                form.append("checkimg", 0); // đổi ảnh
            }

            for(var i=1; i <= document.getElementById("nbfield").value; i++)
            {
                var idf = "idfield" + i;
                var ele = document.getElementById(idf);
                if(ele) 
                {
                    form.append(idf, ele.innerHTML);
                }
                
            }
            for (var i = 0; i < fileInput.files.length; i++) 
            {
                var idimg = "img" + i;
                var file = fileInput.files[i];
                form.append(idimg, file);
            }


            fetch("GrabServlet", {
                method: 'POST',
                body: form
            })
            .then(response => response.text())
                .then(data => {
                    console.log(data);
                    window.location.href = "GrabServlet?userpost=1&idacc=" + idacc;
            })
            .catch((error) => {
                console.error('Error:', error);
            });
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
<body>
<% Post p = (Post) request.getAttribute("post");
	ArrayList<Field> listFields = (ArrayList<Field>) request.getAttribute("listFields");
        
        %>
    
        <div class="view" style="heigth: 100%; top: 150px;">
            <div class="pure-u-6-24"></div>
            <div class="pure-u-12-24" style="position: relative;">
                <div class="post" style="width: 100%; top: 150px !important; margin: 10px 0px;">
                    <div class="post-row">
                    
                    <%
                        if(p.getAvatar_Author() != null){
                            byte[] imageBytes = p.getAvatar_Author();
                            String base64Encoded = Base64.getEncoder().encodeToString(imageBytes);
                    %>
                            <div class="avapic" style="width: 60px; height: 60px; background-image: url(data:image/png;base64,<%= base64Encoded %>);"></div>
                    <%
                        }
                        else {
                    %>
                        <div class="avapic" style="width: 60px; height: 60px; background-image: url(img/defaultavatar.jpg);"></div>
                    <%
                        }
                    %> 
                        
                        <input type="text" name="" class="user" value="<%= p.getName_Author() %>">
                        <input id="datepost" type="text" class="date" value="<%= p.getDate_ago() %>">
                        <div id="subject">
                        <% 
                            if(p.getlistFields().size() != 0)
                            {
                                for (int j=0; j < p.getlistFields().size(); j++)
                                { 
                        %>
                                    <div id="idfield<%= p.getlistFields().get(j).getID_Field() %>" class="subject-content">
                                    <%= p.getlistFields().get(j).getName_Field() %>
                                    </div>
                                <% }
                        } %> 
                        </div>
                    </div>
                    
                    <div class="post-row">
                        <div class="post-content">
                            <textarea id="title" class="enterable" style="height: 23px; min-height: 23px" placeholder="Title" onkeyup="caichido2(this), adjustscrollbar2(this)"><%= p.getTitle() %></textarea>
                            <textarea id="content-text" class="enterable" style="min-height: 50px; resize: vertical;" placeholder="What are you wondering?" onkeyup="caichido2(this), adjustscrollbar2(this)"><%= p.getContent() %></textarea>
                            <textarea id="hastag" class="enterable" style="min-height: 10px;" placeholder="#Hastag" onkeyup="caichido2(this), adjustscrollbar2(this)"><%= p.getHastag() %></textarea> 
                            
                            <div class="more-function" style="height: 25px;">
                                <input id="choosefile" type="file" accept="image/*" multiple max="4" onchange="setImg()">
                                <input type="text" name="numberimg" id="numberimg" value="0" hidden>
                                <input type="button" class="choose-more-button" onclick="activate();">
                                <input type="button" class="choose-more-button button-field" onclick="clickfield()">
                            </div>
                            <div class="more-function" id="set-img" style="margin-top: 0; margin-bottom: 20px;">
                                <!-- Loop image -->
                                <% 
                                byte[] imageBytes2 = null;
                                String imgPost = null;
                                
                                if (p.getlistImages() != null)
                                {
                                    for(int k=0; k < p.getlistImages().size(); k++)
                                    {
                                        imageBytes2 = p.getlistImages().get(k).getImage();
                                        imgPost = Base64.getEncoder().encodeToString(imageBytes2);
                                        int w = 100/ p.getlistImages().size();
                                        %>
                                            <img id="myImg<%= p.getlistImages().get(k).getID_Image() %>" style="width: <%=w %>%; height: 100%; float: left;" src="data:image/png;base64,<%= imgPost %>" alt="ảnh">
                                        <%
                                    }
                                    %>
                                    <input type="button" id="close-image-button" class="close-image" style="" onclick="removeImg()">
                                    <%
                                }
                                else {%>
                                	<input type="button" id="close-image-button" class="close-image" style="display: none;" onclick="removeImg()">
                                <%} %>
                                <!--  -->
                            </div>
                        </div>
                    </div>
                    <div class="post-row" style="display: flex; justify-content: center; align-items: center; margin-top: 20px;">
                        <input type="button" class="Button-or-bl" style="position: relative;float: left; margin-right: 15px;" onclick="saveupdate()" value="Update">
                        <input id="" type="reset" class="Button-or-bl" style="position: relative;float: left;" value="Reset" onclick="location.reload()">
                    </div>
                </div>
            </div>
        <div class="pure-u-6-24"></div>
        </div>

    <!-- FIELD -->
        <div class="modal fade" id="exampleModalToggle7" aria-hidden="true" aria-labelledby="exampleModalToggleLabel7" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="subject-choice post" style="margin-left: -70px;">
                    <div class="subject-content-set" id="set1" style="overflow: visible; height: 23px;"><p style="width: 100%;">Subject:</p></div>
                    <div class="subject-content-set" id="set2" style="width: 75%;float: right;">
                        <!-- loop -->
                        <% for(int i=0; i<listFields.size(); i++)
                            { boolean check = false;
                        %>
                                <div class="hold-subject-content">
                                <% if(p.getlistFields().size() != 0)
                                    {
                                        for (int j=0; j < p.getlistFields().size(); j++)
                                        { 
                                            if(p.getlistFields().get(j).getID_Field() == listFields.get(i).getID_Field())
                                            {
                                                check = true;
                                                break;
                                            }
                                        }
                                    } 
                                    if(check)
                                    {%>
                                        <input id="checkbox<%= listFields.get(i).getID_Field() %>" checked="true" type="checkbox" value="<%= listFields.get(i).getID_Field() %>" onclick="choosefield(this.value)">
                                    <%}
                                    else {%> 
                                        <input id="checkbox<%= listFields.get(i).getID_Field() %>" type="checkbox" value="<%= listFields.get(i).getID_Field() %>" onclick="choosefield(this.value)">
                                    <%}%>
                                    
                                    <label id="f<%= listFields.get(i).getID_Field() %>" for="checkbox<%= listFields.get(i).getID_Field() %>"><%= listFields.get(i).getName_Field() %></label>
                                </div>
                                <%} %>
                        <!--  -->
                    </div>
                    <div class="subject-content-set" style="margin: 20px 42% 0 43%; width: fit-content;">
                        <input id="fieldcancel" type="button" class="Button-or-bl" style="position: relative;" data-bs-dismiss="modal" value="Save">
                    </div>
                </div>
            </div>
        </div>
    </div>
    <input id="acc" type="text" value="<%= user.getID_Account() %>" hidden>
    <input id="nbfield" type="text" value="<%= listFields.size() %>" hidden>
    <input id="idpost" type="text" value="<%= p.getID_Post() %>" hidden>
    <input id="nbimg" type="text" value="<%= p.getlistImages().size() %>" hidden>
    <input id="clicknewfield" class="btn btn-primary" data-bs-target="#exampleModalToggle7" data-bs-toggle="modal" value="Open first modal" hidden>
</body>
</html>