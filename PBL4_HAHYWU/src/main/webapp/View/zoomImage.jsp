<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Zoom image</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/purecss@3.0.0/build/pure-min.css" integrity="sha384-X38yfunGUhNzHpBaEBsWLO+A0HDYOQi8ufWDkZ0k9e0eXz/tH3II7uKZ9msv++Ls" crossorigin="anonymous">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/View/style01.css">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/View/style02.css">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/View/style03.css">
    <script>
        function img_tag_handler() {
            // Get all the <img> tags in the HTML document
            const img_tags = document.getElementsByTagName('img');
            var disp = document.getElementById('disp')
            var press = document.getElementById('press')

            // Loop through each <img> tag and add a click event listener
            for (let i = 0; i < img_tags.length; i++) {
                img_tags[i].addEventListener('click', function() {
                // Do something when the image is clicked
                    var source = this.src;
                    disp.style.backgroundImage = 'url(' + source + ')';
                    if(this.naturalHeight < 700) {
                        disp.style.backgroundSize = "auto";
                    }
                    else {
                        disp.style.backgroundSize = "contain";
                    }
                    press.click();
                });
            }
        }
        document.addEventListener('DOMContentLoaded', img_tag_handler);
    </script>
    <style>
        #disp {
            width: 700px;
            height: 700px;
            margin-top: -10px;
            background-position: center;
            background-repeat: no-repeat;
        }
    </style>
</head>
<body>
    <img src="../img/avata1.jpg" width="25%" alt="" onclick="img_tag_handler()">
    <img src="../img/filter.png" alt="" onclick="img_tag_handler()">
    <button id="press" data-bs-toggle="modal" data-bs-target="#exampleModalToggle8" style="display: none;"></button>

    <div class="modal fade" id="exampleModalToggle8" aria-hidden="true" aria-labelledby="exampleModalToggleLabel8" tabindex="-1" style="z-index: 99999999;">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content" style="display: flex; justify-content: center; align-items: center;">
            	<div id="disp">
                </div>
            </div>
        </div>
    </div>
</body>
</html>