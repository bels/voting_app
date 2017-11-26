$(function(){

	var $valid_form = $('.form-horizontal').validate({
		rules: {
			voter_email: {
				required: true,
				email: true
			}
		}
	});
	$('#nominate-form').submit(function(e){
		e.preventDefault();
		if($valid_form.valid()){
			var $form = $(this);
			var submitData = $form.serialize();
			submitData['voter_email'] = $('#voter-email').val();
			$.ajax({
				method: $form.attr('method'),
				url: $form.attr('action'),
				data: submitData
			}).done(function(data){
				if(data.success){
					window.location.href = '/thanks';
				}
			});
		}
	});

	$('#vote-form').submit(function(e){
		e.preventDefault();
		var $form = $(this);
		var submitData = $form.serialize();
		$.ajax({
			method: $form.attr('method'),
			url: $form.attr('action'),
			data: submitData
		}).done(function(data){
			if(data.success){
				window.location.href = '/thanks';
			}
		});
	});
});
