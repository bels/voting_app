package RoadHack::Model::Core;
use Mojo::Base -base;

#use Platform::Log;
has 'pg';
has 'debug';

sub voting_phase{
	my ($self,$campaign_id) = @_;
	
	my $reached_deadline = $self->pg->db->query('select nomination_deadline, case when now() >= nomination_deadline then 1 else 0 from campaign where id = ?',$campaign_id)->hash;
	
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
	
	my $campaign_id = $self->pg->db->query('select id from campaign order by election_date desc limit 1')->hash;
	
	return $campaign_id->{'id'};
}

sub get_offices{
	my ($self, $campaign_id) = @_;
	
	my $offices = $self->pg->db->query('select id,name from offices where campaign = ?', $campaign_id)->hashes->to_array;
	
	return $offices;
}

sub record_nominations{
	my ($self,$data) = @_;
	
	$self->pg->db->query('insert into nominations (name, office, campiagn) values (?,?,?)',$data->{'name'},$self->{'office'})
}

sub record_votes{
	my ($self,$data) = @_;
}
1;