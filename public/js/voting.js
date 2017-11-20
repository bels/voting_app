$(function(){

	$('#nominate-form').submit(function(e){
		e.preventDefault();
		var $form = $(this);
		var submitData = {};
		$('.office-group').each(function(index,element){
			var $element = $(element);
			var id = $element.find('.office-id').val();
			var name = $element.find('.office-data').val();
			submitData['nominations'][index] = {office: id, name: name};
		});
		submitData['voter_email'] = $('#voter-email').val();
		$.ajax({
			method: $form.attr('method'),
			url: $form.attr('action'),
			data: submitData
		}).done(function(){
			
		});
	});

});
