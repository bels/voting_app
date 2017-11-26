package VotingApp::Controller::Auth;
use Mojo::Base 'Mojolicious::Controller';

sub login_form{
	my $self = shift;
}

sub login{
	my $self = shift;
warn $self->param('password');
warn $self->config('password');
	if($self->param('password') eq $self->config('password')){
		$self->session(logged_in => 1);
		$self->redirect_to($self->url_for($self->config('login_landing_page')));
	} else {
		$self->flash(error => 'Wrong password. Try again');
		$self->redirect_to($self->url_for('login'));
	}
}

sub check_session{
	my $self = shift;
	
	if($self->session('logged_in')){
		return 1;
	} else {
		$self->flash(message => 'Session expired');
		$self->redirect_to($self->url_for('login'));
	}
}
1;