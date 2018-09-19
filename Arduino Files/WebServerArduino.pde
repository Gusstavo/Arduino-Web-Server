<html>
	<head>
		<title>Minha primeira página d web!</title>

		<script type="text/javascript">

		// var pressed = document.getElementById('pressed');
		
		function keyPressed(evt){
			evt = evt || window.event;
			var key = evt.keyCode || evt.which;
			return String.fromCharCode(key); 
		}

		document.onkeypress = function(evt) {
			var str = keyPressed(evt);
			pressed.innerHTML += str;
		};
		</script>
		<h2 id='pressed'>Teclas pressionadas: </h2>

	</head>
</html>
