package VotingApp::Controller::Core;
use Mojo::Base 'Mojolicious::Controller';

sub index{
	my $self = shift;
	
	my $campaign = $self->core->get_current_campaign();
	$self->stash(
		phase => $self->core->voting_phase($campaign->{'id'}),
		campaign => $campaign
	);
}

sub nominate_form{
	my $self = shift;

	my $campaign = $self->core->get_current_campaign();

	$self->stash(
		offices => $self->core->get_offices($campaign->{'id'}),
		campaign_id => $campaign->{'id'}
	);
}

sub nominate{
	my $self = shift;
	
	my $params = $self->req->params->to_hash;
	my $campaign = $self->core->get_current_campaign();

	my $data = {
		offices => $params->{'office'},
		office_ids => $params->{'office_id'},
		campaign => $campaign->{'id'},
		voter => $params->{'voter_email'}
	};
	$self->core->record_nominations($data);
	$self->render(json => {success => Mojo::JSON->true, message => 'Successfully nominated'});
}

sub vote_form{
	my $self = shift;

	my $campaign = $self->core->get_current_campaign();
	$self->stash(
		candidates => $self->core->get_candidates($campaign->{'id'}),
		campaign_id => $campaign->{'id'}
	)
}

sub vote{
	my $self = shift;
	
	my $params = $self->req->params->to_hash;

	my $campaign = $self->core->get_current_campaign();
	my $voter = $params->{'voter_email'};
	delete $params->{'voter_email'}; #disassociating this with the votes
	my $data = {
		votes => $params,
		campaign => $campaign->{'id'},
		voter => $voter
	};
	$self->core->record_votes($data);
	$self->render(json => {success => Mojo::JSON->true, message => 'Successfully voted'});
}

sub campaign_list{
	my $self = shift;
	
	$self->stash(
		campaigns => $self->core->get_campaign_list
	);
}

sub campaign{
	my $self = shift;
	
	my $votes_raw = $self->core->get_voting_results($self->param('campaign_id'));
	
	my $votes = {};
	foreach my $vote (@{$votes_raw}){
		if(ref $votes->{$vote->{'office'}} ne 'ARRAY'){
			$votes->{$vote->{'office'}} = [];
		}
		push(@{$votes->{$vote->{'office'}}},{name => $vote->{'name'}, votes => $vote->{'votes'} });
	}

	$self->stash(
		votes => $votes
	);
}

sub thanks{
	my $self = shift;
}
1;
