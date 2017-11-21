package VotingApp::Model::Core;
use Mojo::Base -base;

#use Platform::Log;
has 'pg';
has 'debug';

sub voting_phase{
	my ($self,$campaign_id) = @_;

	my $reached_deadline = $self->pg->db->query('select nomination_deadline, case when now() >= nomination_deadline then 1 else 0 END from campaign where id = ?',$campaign_id)->hash;
	
	if($reached_deadline->{'case'}){
		#if we reached the nomination deadline it is time to vote.
		return 'voting';
	} else {
		return 'nomination';
	}
}

#will return the latest campaign id
sub get_current_campaign{
	my $self = shift;
	
	my $campaign = $self->pg->db->query('select * from campaign order by election_date desc limit 1')->hash;
	
	return $campaign;
}

sub get_offices{
	my ($self, $campaign_id) = @_;
	
	my $offices = $self->pg->db->query('select name,id from offices where campaign = ?', $campaign_id)->arrays->to_array;
	
	return $offices;
}

sub record_nominations{
	my ($self,$data) = @_;
	
	#first check to see if they are eligible to vote
	
	my $eligible = $self->pg->db->query('select count(*) from authorized_voters where voter = ? and active = true',$data->{'voter'})->hash;
	if($eligible->{'count'}){
		foreach my $nomination (@{$data->{'nominations'}){
			$self->pg->db->query('insert into nominations (name, office, campiagn) values (?,?,?)',$nomination->{'name'},$nomination->{'office'},$data->{'campaign'});
		}
		return 1;
	} else {
		#couldn't vote
		return 0;
	}
	
}

sub record_votes{
	my ($self,$data) = @_;
	
	#first check to see if this person is eligible to vote
	my $eligible = $self->pg->db->query('select count(*) from authorized_voters where voter = ? and active = true',$data->{'voter'})->hash;
	if($eligible->{'count'}){
		#second check to see if they have already voted
		my $already_voted = $self->pg->db->query('select count(*) from voter_tracking where voter = ? and campaign = ?', $data->{'voter'}, $data->{'campaign'})->hash;
		unless($already_voted->{'count'}){
			foreach my $vote (@{$data->{'votes'}}){
				$self->pg->db->query('insert into votes(candidate, campaign, office) values (?,?)',$vote->{'candidate'},$data->{'campaign'},$vote->{'office'}) ;
				$self->pg->db->query('insert into voter_tracking(voter,campaign) values(?,?)',$vote->{'voter'},$data->{'campaign'});
			}
		} else {
			return {code => -2, message => 'Already voted'};
		}
	} else {
		return {code => -1, message => 'Not eligible to vote'};
	}
}
1;
