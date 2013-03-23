<!DOCTYPE html>
<html>
	<head>
		<title>{{title}}</title>
		<meta name="description" content="{{description}}">
		<link rel="icon" type="image/png" href="/favicon.png">
		<link href='http://fonts.googleapis.com/css?family=Merriweather+Sans' rel='stylesheet' type='text/css'>
		<style>
			* {
			    font-family: "Merriweather Sans", sans-serif;
			    color: #222;
			    margin: 0;
			    padding: 0;
			}
			body {
			    
			}
			a {
			    text-decoration : none;
			    color: #448;
			}
			a:hover {
			    color: #66A;
			}
			.container {
			    width: 960px;
			    margin: auto;
			    background-color: #F6F6EF;
			}
			.content {
			    padding: 5px 10px;
			}
			.demo-headline {
    			padding : 8px 15px 8px 15px;
    			background-color: #1abc9c;
    		}
			p {
			    font-size : large;
			    margin-bottom : 10px;
			    font-family : "Merriweather Sans", sans-serif;
			}
			.listing {
			    margin-bottom : 5px;
			    margin-left: 30px;
			    padding : 0 5px 0 3px;
			    position : relative;
			    border-left: solid 3px #1abc9c;
			}
			h1 {
			    font-size: large;
			    display: inline;
			}
			h2 {
			    margin-top : 10px;
			    display: inline;
			}
			h3 { font-size : 20px; }
			h4 { margin-top : 25px; }
			.date {
			    font-size : small;
			    margin-left: 15px
			}
			.post_date {
			    margin-left : 20px;
			    font-size : small;
			}
			.author {
			    margin-left : 20px;
			    font-size : medium;
			}
			.undertitle {
			    margin-top : -10px;
                font-family: "Flat-UI-Icons-16";
			}
			.span5 {
			    width: 400px;
			}
			.post {
			    border-left: solid 3px #1abc9c;
			    padding-left: 5px;
			    margin-left: 5px;
			}
			.row {
			    margin-bottom : 0;
			}
			.auth_area {
			    float: right;
			}
			.btn {
			    border: 2px solid #A1D1D1;
			    padding: 0 15px 3px 15px;
			    margin: 0 auto 0 5px;
			    font: bold;
			    cursor: pointer;
			    background-color: #C1F1F1;
			}
			input {
			    margin-bottom: 15px;
			    margin-left: 5px;
			    border: 2px solid #777;
			    padding: 5px;
			}
			.error {
			    color: red;
			}
			.submit {
			    margin-left: 20px;
			}
			.submit a, .auth_area a {
			    color: #226;
			}
		</style>
	</head>
	<body>
	<div class="container">
		<div class="demo-headline">
		    <a href="/"><h1 class="demo-logo">{{h1Title}}</h1></a>
		    <span class="submit"><a href="/submit">Submit!</a></span>
		    <span class="auth_area">{{!auth_html}}</span>
		</div>
		<div class="content">
    		%include
        </div>
	</div>
	<a href="https://github.com/ConceptPending/hn4hn4x"><img style="position: absolute; top: 0; right: 0; border: 0;" src="https://s3.amazonaws.com/github/ribbons/forkme_right_orange_ff7600.png" alt="Fork me on GitHub"></a>
	</body>
</html>
