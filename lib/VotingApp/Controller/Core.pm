package VotingApp::Controller::Core;
use Mojo::Base 'Mojolicious::Controller';

sub index{
	my $self = shift;
	
	my $campaign_id = $self->core->get_current_campaign();
	$self->stash(
		phase => $self->core->voting_phase($campaign_id)
	);
}

sub nominate_form{
	my $self = shift;

	my $campaign_id = $self->core->get_current_campaign();
	$self->stash(
		offices => $self->core->get_offices($campaign_id),
		campaign_id => $campaign_id
	);
}

sub nominate{
	my $self = shift;
	
	$self->core->record_nominations($self->req->params->to_hash);
	$self->redirect_to($self->url_for('thanks'));
}

sub vote_form{
	my $self = shift;

	my $campaign_id = $self->core->get_current_campaign();
	$self->stash(
		candidates => $self->core->get_candidates($campaign_id),
		campaign_id => $campaign_id
	)
}

sub vote{
	my $self = shift;
	
	$self->core->recored_votes($self->req->params->to_hash);
	$self->redirect_to($self->url_for('thanks'));
}

sub campaign_list{
	my $self = shift;
}

sub campaign{
	my $self = shift;
}

sub thanks{
	my $self = shift;
}
1;