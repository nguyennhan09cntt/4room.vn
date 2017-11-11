jQuery(document).ready(function() {
	$('.item iframe').on('load', function(){			
	    //your code (will be called once iframe is done loading)
	    
	    this.style.height =
    this.contentWindow.document.body.offsetHeight + 'px';

	});			 
})