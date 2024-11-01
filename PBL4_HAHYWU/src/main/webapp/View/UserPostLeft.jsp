<%@page import="java.text.SimpleDateFormat"%>
<%@page import="model.bean.NumberCensor"%>
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
    <script>
    	document.addEventListener("DOMContentLoaded", function() {
        	document.getElementById("mySelectCensor").value = <%= request.getAttribute("ID_Censor") %>;
        	document.getElementById("mySelectField").value = <%= request.getAttribute("ID_Field") %>;
        	var s = document.getElementById("mysort");
            s.value = '<%= request.getAttribute("sort") %>';
        });
    
        function btsearch()
        {
            var censor = document.getElementById("mySelectCensor").value;
            var field = document.getElementById("mySelectField").value;
            var l = "GrabServlet?userpost=1&IDField=" + field + "&censor=" + censor + "&idacc=" + document.getElementById("acc").value 
            		+ "&search=" + document.getElementById("txtsearch").value + "&sort=" + document.getElementById("mysort").value;
            location = l;
        }
        
        function textAreaAdjust1(element) {
            // Set a minimum height if desired
            const minHeight = 33; // Adjust this value as needed
            // Resize function that adjusts the height based on the scrollHeight
            const resizeTextArea = () => {
                element.style.height = '1px'; // Temporarily shrink the element to auto height to get the correct scrollHeight
                const newHeight = Math.max(element.scrollHeight, minHeight);
                element.style.height = newHeight + 'px';
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
        function activate1() {
            var choosefile = document.getElementById("choosefile");
            choosefile.click();
        }
        function setImg1() {
            var closebutton = document.getElementById("close-image-button");
            var fileInput = document.getElementById("choosefile");
            var div = document.getElementById("set-img");
            var widthdiv = div.offsetWidth;
            for (var i = 0; i < fileInput.files.length; i++) {
                var image = document.createElement("img");
                image.setAttribute("id", "myImage");
                image.style.width = "calc(" + widthdiv + "px / " + fileInput.files.length + ")";
                image.style.height = "100%";
                image.style.float = "left";
                image.src = URL.createObjectURL(fileInput.files[i]);
                div.appendChild(image);
            }
            closebutton.style.display = "block";
        }
        function removeImg1() {
            var images = document.querySelectorAll("#set-img img");
            var closebutton = document.getElementById("close-image-button");
            for (var i = 0; i < images.length; i++) {
                images[i].remove();
                closebutton.style.display = "none";
            }
        }
        function adjustscrollbar1(element) {
            element.scrollIntoView(false);
        }
        function createnewpost() {
            var b = document.getElementById("clicknewpost");
            b.click();
        }
        function clickfield()
        {
            var c = document.getElementById("newcancel");
            c.click();
            var b = document.getElementById("clicknewfield");
            b.click();
        }
        function clickfieldcancel()
        {
            var b = document.getElementById("clicknewpost");
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

        function savenewpost() {
            var idacc = document.getElementById("acc").value;
            var title = document.getElementById("title").value;
            var datepost = document.getElementById("datepost").value;
            var content = document.getElementById("content-text").value;
            var hastag = document.getElementById("hastag").value;
            var fileInput = document.getElementById("choosefile");
            var numberimg = fileInput.files.length;
            var numberfields = document.getElementById("nbfield").value;
            var form = new FormData();
            form.append("newpost", 1);
            form.append("idacc", idacc);
            form.append("title", title);
            form.append("datepost", datepost);
            form.append("content", content);
            form.append("hastag", hastag);
            form.append("numberimg", numberimg);
            form.append("numberfields", numberfields);
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
                window.location.reload();
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
    
<%
     	ArrayList<Post> listpost = (ArrayList<Post>) request.getAttribute("listpost");
		int censoring=0, censored=0, uncensored=0;
		for (int i=0; i < listpost.size(); i++)
		{
			if(listpost.get(i).getCensor() == 0)
			{
				censoring = censoring + 1;
			}
			if(listpost.get(i).getCensor() == 1)
			{
				censored = censored + 1;
			}
			if(listpost.get(i).getCensor() == 2)
			{
				uncensored = uncensored + 1;
			}
		}
%>

        <section class="pure-g section4" style="padding: 10px 0 93px; position: absolute;">
            <div class="pure-u-2-24"></div>
            <div class="pure-u-6-24">
                <div class="newpost headform">
                    <p style="margin: 24px 0 0 0;">- NEW POST -</p>
                    <hr class="straightline">
                    <div class="pure-g undernewpost">
                        <div class="pure-u-2-24"></div>
                        <div class="pure-u-3-24">
                        <%
                    	if(user.getAvatar() != null){
                    		byte[] imageBytes = user.getAvatar();
    				    	String base64Encoded = Base64.getEncoder().encodeToString(imageBytes);
    				%>
    						<input type="button" name="" class="avapic" style="background-image: url(data:image/png;base64,<%= base64Encoded %>);margin-top: 18px;">
    				<%
                    	}
                    	else {
					%>
						<input type="button" name="" class="avapic" style="background-image: url(img/defaultavatar.jpg);margin-top: 18px;">
					<%
                    	}
					%> 
                        </div>
                        <div class="pure-u-17-24" id="create-new-post">
                            <input class="topost" type="text" name="newpost" value="" placeholder="What are you wondering?" style="margin-top: 18px;" onfocus="createnewpost()">    
                        </div>
                        <div class="pure-u-2-24"></div>
                    </div>
                </div>
                <div class="userdetail">
                    <div class="pure-g" style="position: relative;">
                        <div class="pure-u-2-24"></div>
                        <div class="pure-u-10-24" style="position: relative; text-align: left;">
                            <select id="mysort" class="cbb" style="margin: 0px 10px 0px 0px; width: 85%; padding: 7px; border-radius: 30px; border: 2px solid #1B335B; color: #1B335B;" onchange="btsearch()">
			                    <option value="DESC">Newest</option>
			                    <option value="ASC">Oldest</option>
			                </select>
		                </div>
                        <div class="pure-u-10-24" style="position: relative; text-align: left;">
                            <input id="txtsearch" class="topost" type="text" name="searchpost" style="height: 37px;  width: 90%;" placeholder="Search" value="<%= request.getAttribute("searchtxt") %>">
                            <input class="searchpostbut" type="button" name="searchpostbut" onclick="btsearch()" style="height: 39px;">
                        </div>
                        <div class="pure-u-2-24"></div>
                    </div>
                    <div class="pure-g" style="position: relative;">
                        <div class="pure-u-2-24"></div>
                        <div class="pure-u-10-24" style="position: relative; text-align: left;">
                            <select id="mySelectCensor" class="cbb" style="margin: 10px 0px 0px 0px; width: 85%; padding: 7px; border-radius: 30px; border: 2px solid #1B335B; color: #1B335B;" onchange="btsearch()">
                                <option value="5">All Censor</option>
                                <option value="0">Censoring</option>
                                <option value="1">Censored</option>
                                <option value="2">Uncensored</option>
                                <option value="4">Deleted</option>
                            </select>
                        </div>
                        <div class="pure-u-10-24" style="position: relative; text-align: left;">
                            <select id="mySelectField" class="cbb" style="margin: 10px 0px 0px 0px; width: 87%; padding: 7px; border-radius: 30px; border: 2px solid #1B335B; color: #1B335B;" onchange="btsearch()">
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
                                <p class="first-column">Total: <input type="text" id="total" value="<%= nbCensor.getTotal() %>" class="second-column" readonly></p>
                                <hr class="straightline" style="margin: 0;">
                                <p class="first-column">Censoring: <input type="text" id="censoring" value="<%= nbCensor.getCensoring() %>" class="second-column" readonly></p>
                                <hr class="straightline" style="margin: 0;">
                                <p class="first-column">Censored: <input type="text" id="censored" value="<%= nbCensor.getCensored() %>" class="second-column" readonly></p>
                                <hr class="straightline" style="margin: 0;">
                                <p class="first-column">Uncensored: <input type="text" id="uncensored" value="<%= nbCensor.getUncensored() %>" class="second-column" readonly></p>
                                <hr class="straightline" style="margin: 0;">
                            </div>
                        </div>
                        
                        <div class="pure-u-2-24"">
                        <input id="acc" type="text" value="<%= user.getID_Account() %>" hidden>
                        </div>
                    </div>
                </div>
            </div>
            <div class="pure-u-16-24"></div>
        </section>
    
    <!-- NEW POST -->
            <div class="modal fade" id="exampleModalToggle6" aria-hidden="true" aria-labelledby="exampleModalToggleLabel6" tabindex="-1"  style="z-index: 999999;">
                <div class="modal-dialog modal-dialog-centered" style="z-index: 999999;">
                    <div class="modal-content">
                        <div class="post" style="align-items: center; width: 700px; margin-left: -100px; z-index: 99999;">
                            <input class="btn-close" data-bs-dismiss="modal"  id="Button-close" type="button" value="" style="position: absolute; background-image: url(img/Close.png);">
                            <div class="post-head">-NEW POST-</div>
                            <div class="post-row">
                            
                            <%
                                if(user.getAvatar() != null){
                                    byte[] imageBytes = user.getAvatar();
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
                                
                                <input type="text" name="" class="user" value="<%= user.getDisplay_Name() %>">
                                <%	Date now = new Date();
								    SimpleDateFormat dateFormat = new SimpleDateFormat("MM-dd-yyyy");
								    String formattedDate = dateFormat.format(now);
								%>
								<input id="datepost" type="text" class="date" value="<%= formattedDate %>" readonly>
                                <div id="subject"></div>
                            </div>
                            
                            <div class="post-row">
                                <div class="post-content">
                                    <textarea id="title" class="enterable" style="height: 23px; min-height: 23px" placeholder="Title" oninput="textAreaAdjust1(this), adjustscrollbar1(this)" onkeyup="textAreaAdjust1(this), adjustscrollbar1(this)"></textarea>
                                    <textarea id="content-text" class="enterable" style="min-height: 50px;" placeholder="What are you wondering?" oninput="textAreaAdjust1(this), adjustscrollbar1(this)" onkeyup="textAreaAdjust1(this), adjustscrollbar1(this)"></textarea>
                                    <textarea id="hastag" class="enterable" style="min-height: 10px;" placeholder="#Hastag" oninput="textAreaAdjust1(this), adjustscrollbar1(this)" onkeyup="textAreaAdjust1(this), adjustscrollbar1(this)"></textarea> 
                                    <div class="more-function" style="height: 25px;">
                                        <input id="choosefile" type="file" accept="image/*" multiple max="4" onchange="setImg1()">
                                        <input type="text" name="numberimg" id="numberimg" value="0" hidden>
                                        <input type="button" class="choose-more-button" onclick="activate1();">
                                        <input type="button" class="choose-more-button button-field" onclick="clickfield()">
                                    </div>
                                    <div class="more-function" id="set-img" style="margin-top: 0; margin-bottom: 20px;" onload="checkHeightChange()">
                                        <input type="button" id="close-image-button" class="close-image" style="display: none;" onclick="removeImg1()">
                                    </div>
                                </div>
                            </div>
                            <div class="post-row" style="display: flex; justify-content: center; align-items: center; margin-top: 20px;">
                                <input type="button" class="Button-or-bl" style="position: relative;float: left; margin-right: 15px;" onclick="savenewpost()" value="Post">
                                <input id="newcancel" type="button" class="Button-or-bl" style="position: relative;float: left;" data-bs-dismiss="modal" value="Cancel">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- FIELD -->
              <div class="modal fade" id="exampleModalToggle7" aria-hidden="true" aria-labelledby="exampleModalToggleLabel7" tabindex="-1">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content">
                        <div class="subject-choice post" style="margin-left: -70px;">
                            <div class="subject-content-set" id="set1" style="overflow: visible; height: 23px;"><p style="width: 100%;">Field:</p></div>
                            <div class="subject-content-set" id="set2" style="width: 75%;float: right;">
                                <!-- loop -->
                                <% for(int i=0; i<listFields.size(); i++)
                                    {
                                %>
                                        <div class="hold-subject-content">
                                            <input id="checkbox<%= listFields.get(i).getID_Field() %>" type="checkbox" value="<%= listFields.get(i).getID_Field() %>" onclick="choosefield(this.value)">
                                            <label id="f<%= listFields.get(i).getID_Field() %>" for="checkbox<%= listFields.get(i).getID_Field() %>"><%= listFields.get(i).getName_Field() %></label>
                                        </div>
                                     <%} %>
                                <!--  -->
                            </div>
                            <div class="subject-content-set" style="margin: 20px 42% 0 43%; width: fit-content;">
                                <input id="fieldcancel" type="button" class="Button-or-bl" style="position: relative;" data-bs-dismiss="modal" value="Save" onclick="clickfieldcancel()">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <input id="nbfield" type="text" value="<%= listFields.size() %>" hidden>
            <input id="clicknewpost" class="btn btn-primary" data-bs-target="#exampleModalToggle6" data-bs-toggle="modal" value="Open first modal" hidden>
            <input id="clicknewfield" class="btn btn-primary" data-bs-target="#exampleModalToggle7" data-bs-toggle="modal" value="Open first modal" hidden>
</body>
</html>