$(function(){

	$('#nominate-form').submit(function(e){
		e.preventDefault();
		var $form = $(this);
		var submitData = {};
		$('.office-group').each(function(index,element){
			var $element = $(element);
			var id = $element.find('.office-id').val();
			var name = $element.find('.office-data').val();
			submitData[id] = name;
		});
		
		$.ajax({
			method: $form.attr('method'),
			url: $form.attr('action'),
			data: submitData
		}).done(function(){
			
		});
	});

});
