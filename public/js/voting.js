$(function(){

	$('#nominate-form').submit(function(e){
		e.preventDefault();
		console.log('i did something')
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
				//window.location.href = '/thanks';
			}
		});
	});
});
